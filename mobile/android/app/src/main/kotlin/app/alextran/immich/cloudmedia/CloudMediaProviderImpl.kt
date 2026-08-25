package app.alextran.immich.cloudmedia

import android.content.Context
import android.database.Cursor
import android.database.MatrixCursor
import android.graphics.Point
import android.os.Build
import android.os.Bundle
import android.os.CancellationSignal
import android.os.OperationCanceledException
import android.os.ParcelFileDescriptor
import android.provider.CloudMediaProvider
import android.provider.CloudMediaProviderContract
import android.provider.CloudMediaProviderContract.MediaCollectionInfo
import android.content.res.AssetFileDescriptor
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.work.Constraints
import androidx.work.Configuration
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.ExistingWorkPolicy
import androidx.work.NetworkType
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import app.alextran.immich.core.HttpClientManager
import okhttp3.Request
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException
import java.util.concurrent.TimeUnit

private const val TAG = "CloudMediaProviderImpl"
private const val DEFAULT_PAGE_SIZE = 1000
private const val MAX_PAGE_SIZE = 5000
private val ASSET_ID_PATTERN = Regex("^[0-9a-fA-F-]{36}$")

private const val PREVIEW_CACHE_MAX_BYTES = 200L * 1024 * 1024 // 200 MiB
private const val ORIGINAL_CACHE_MAX_BYTES = 1024L * 1024 * 1024 // 1 GiB

private const val SYNC_WORK_NAME = "immich/CloudMediaSyncV1"
private const val SYNC_WORK_NAME_ONE_OFF = "immich/CloudMediaSyncOneOffV1"

/**
 * Exposes the server library to Android's system Photo Picker (Settings > Apps > Default apps >
 * Photo picker app > Cloud media app), so other apps' "choose a photo" pickers can pull straight
 * from the server without the user having to download things into the device's own MediaStore
 * first.
 *
 * Only ever loaded on API 34+ - see `ImmichApp.enableCloudMediaProviderIfSupported` for why the
 * `<provider>` manifest entry ships disabled and how it gets turned on. Metadata is served from
 * [CloudMediaSyncStore], a local mirror kept fresh by [CloudMediaSyncEngine] (a periodic
 * WorkManager job, scheduled from [onCreate] below, plus an immediate one-off so a freshly
 * enabled provider isn't empty until the next periodic tick). [onOpenPreview]/[onOpenMedia] fetch
 * and cache the actual bytes from the server on demand, since originals aren't pre-downloaded
 * to the device for anything the user hasn't opened in-app.
 */
@RequiresApi(Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
class CloudMediaProviderImpl : CloudMediaProvider() {
  private lateinit var store: CloudMediaSyncStore

  override fun onCreate(): Boolean {
    val context = context ?: return false
    HttpClientManager.initialize(context)
    store = CloudMediaSyncStore(context)

    // Providers are created before Application.onCreate() - WorkManager may not be initialized
    // yet. ImmichApp.onCreate() guards its own init call the same way for the reverse ordering.
    if (!WorkManager.isInitialized()) {
      WorkManager.initialize(context, Configuration.Builder().build())
    }
    schedulePeriodicSync(context)
    scheduleOneOffSync(context)
    return true
  }

  override fun onGetMediaCollectionInfo(extras: Bundle): Bundle {
    return Bundle().apply {
      putString(MediaCollectionInfo.MEDIA_COLLECTION_ID, store.getCollectionId())
      putLong(MediaCollectionInfo.LAST_MEDIA_SYNC_GENERATION, store.getGeneration())
    }
  }

  override fun onQueryMedia(extras: Bundle): Cursor {
    val (since, pageSize) = parsePagingExtras(extras)
    store.queryMedia(since, pageSize + 1).use { source ->
      return paginate(source, pageSize, "sync_generation")
    }
  }

  override fun onQueryDeletedMedia(extras: Bundle): Cursor {
    val (since, pageSize) = parsePagingExtras(extras)
    store.queryDeletedMedia(since, pageSize + 1).use { source ->
      return paginate(source, pageSize, "sync_generation")
    }
  }

  override fun onOpenPreview(
    mediaId: String,
    size: Point,
    extras: Bundle?,
    signal: CancellationSignal?
  ): AssetFileDescriptor {
    val file = fetchAndCache("previews", mediaId, "thumbnail?size=preview", PREVIEW_CACHE_MAX_BYTES, signal)
    val pfd = ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
    return AssetFileDescriptor(pfd, 0, AssetFileDescriptor.UNKNOWN_LENGTH)
  }

  override fun onOpenMedia(
    mediaId: String,
    extras: Bundle?,
    signal: CancellationSignal?
  ): ParcelFileDescriptor {
    val file = fetchAndCache("originals", mediaId, "original", ORIGINAL_CACHE_MAX_BYTES, signal)
    return ParcelFileDescriptor.open(file, ParcelFileDescriptor.MODE_READ_ONLY)
  }

  private fun parsePagingExtras(extras: Bundle): Pair<Long, Int> {
    val requestedGeneration = extras.getLong(CloudMediaProviderContract.EXTRA_SYNC_GENERATION, 0L)
    val pageToken = extras.getString(CloudMediaProviderContract.EXTRA_PAGE_TOKEN)
    val since = pageToken?.toLongOrNull() ?: requestedGeneration
    val pageSize = extras.getInt(CloudMediaProviderContract.EXTRA_PAGE_SIZE, DEFAULT_PAGE_SIZE)
      .coerceIn(1, MAX_PAGE_SIZE)
    return since to pageSize
  }

  /**
   * Copies up to `pageSize` rows from `source` (which was queried for pageSize+1) into a bounded
   * [MatrixCursor], attaching a continuation token in the result's extras when the extra row
   * proves there's more. `source` is exhausted/closed by the caller's `use {}`.
   */
  private fun paginate(source: Cursor, pageSize: Int, generationColumn: String): Cursor {
    val genIndex = source.getColumnIndexOrThrow(generationColumn)
    val result = MatrixCursor(source.columnNames)
    var lastGeneration: Long? = null
    var rowCount = 0
    while (rowCount < pageSize && source.moveToNext()) {
      val row = arrayOfNulls<Any?>(source.columnCount)
      for (i in 0 until source.columnCount) {
        row[i] = when (source.getType(i)) {
          Cursor.FIELD_TYPE_INTEGER -> source.getLong(i)
          Cursor.FIELD_TYPE_FLOAT -> source.getDouble(i)
          Cursor.FIELD_TYPE_BLOB -> source.getBlob(i)
          else -> source.getString(i)
        }
      }
      result.addRow(row)
      lastGeneration = source.getLong(genIndex)
      rowCount++
    }
    if (source.moveToNext() && lastGeneration != null) {
      result.extras = Bundle().apply {
        putString(CloudMediaProviderContract.EXTRA_PAGE_TOKEN, lastGeneration.toString())
      }
    }
    return result
  }

  private fun fetchAndCache(
    subdir: String,
    mediaId: String,
    serverPath: String,
    maxCacheBytes: Long,
    signal: CancellationSignal?
  ): File {
    // mediaId ends up as both a local cache filename and a server URL path segment - reject
    // anything that isn't a plain asset UUID to rule out path traversal / request smuggling.
    if (!ASSET_ID_PATTERN.matches(mediaId)) {
      throw FileNotFoundException("Invalid media id")
    }
    val context = context ?: throw FileNotFoundException("Provider not attached")
    val dir = File(context.cacheDir, "cloudmedia/$subdir")
    val destination = File(dir, mediaId)
    if (destination.exists() && destination.length() > 0) {
      destination.setLastModified(System.currentTimeMillis())
      return destination
    }

    val baseUrl = HttpClientManager.getServerUrls().firstOrNull()
      ?: throw FileNotFoundException("No server configured")
    val url = "${baseUrl.trimEnd('/')}/assets/$mediaId/$serverPath"
    downloadToFile(url, destination, signal)
    trimCache(dir, maxCacheBytes)
    return destination
  }

  private fun downloadToFile(url: String, destination: File, signal: CancellationSignal?) {
    val requestBuilder = Request.Builder().url(url)
    HttpClientManager.getAuthHeaders(url).forEach { (key, value) -> requestBuilder.header(key, value) }
    val call = HttpClientManager.getClient().newCall(requestBuilder.build())
    signal?.setOnCancelListener { call.cancel() }

    val tmp = File(destination.parentFile, "${destination.name}.tmp")
    try {
      call.execute().use { response ->
        if (signal?.isCanceled == true) throw OperationCanceledException()
        if (!response.isSuccessful) throw FileNotFoundException("HTTP ${response.code} for $url")
        val body = response.body ?: throw FileNotFoundException("Empty response body for $url")

        destination.parentFile?.mkdirs()
        body.byteStream().use { input ->
          FileOutputStream(tmp).use { output -> input.copyTo(output) }
        }
      }
    } catch (e: IOException) {
      tmp.delete()
      if (signal?.isCanceled == true) throw OperationCanceledException()
      throw FileNotFoundException("Failed to fetch $url: ${e.message}")
    }

    if (signal?.isCanceled == true) {
      tmp.delete()
      throw OperationCanceledException()
    }
    if (!tmp.renameTo(destination)) {
      tmp.delete()
      throw FileNotFoundException("Failed to cache $url")
    }
  }

  private fun trimCache(dir: File, maxBytes: Long) {
    val files = dir.listFiles()?.filter { it.isFile && !it.name.endsWith(".tmp") } ?: return
    var total = files.sumOf { it.length() }
    if (total <= maxBytes) return
    for (file in files.sortedBy { it.lastModified() }) {
      if (total <= maxBytes) break
      total -= file.length()
      file.delete()
    }
  }

  private fun schedulePeriodicSync(context: Context) {
    val work = PeriodicWorkRequestBuilder<CloudMediaSyncWorker>(6, TimeUnit.HOURS)
      .setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build())
      .build()
    WorkManager.getInstance(context)
      .enqueueUniquePeriodicWork(SYNC_WORK_NAME, ExistingPeriodicWorkPolicy.KEEP, work)
  }

  private fun scheduleOneOffSync(context: Context) {
    if (store.getGeneration() > 0) return // already has data from a previous sync
    val work = OneTimeWorkRequestBuilder<CloudMediaSyncWorker>()
      .setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build())
      .build()
    WorkManager.getInstance(context)
      .enqueueUniqueWork(SYNC_WORK_NAME_ONE_OFF, ExistingWorkPolicy.KEEP, work)
    Log.i(TAG, "Enqueued initial cloud media sync")
  }
}
