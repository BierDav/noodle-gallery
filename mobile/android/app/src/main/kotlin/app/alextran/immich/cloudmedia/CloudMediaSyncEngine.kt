package app.alextran.immich.cloudmedia

import android.content.Context
import android.net.Uri
import android.util.Log
import app.alextran.immich.core.HttpClientManager
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import java.io.IOException
import java.time.Instant

private const val TAG = "CloudMediaSyncEngine"
private const val PAGE_SIZE = 1000

/** `${applicationId}.cloudmedia` - kept in sync with the `<provider>` entry in AndroidManifest.xml. */
fun cloudMediaAuthority(context: Context): String = "${context.packageName}.cloudmedia"

@Serializable
private data class SearchMetadataRequest(
  val page: Int,
  val size: Int,
  val withExif: Boolean = true,
  val withSharedSpaces: Boolean = true,
)

@Serializable
private data class SearchMetadataResponse(val assets: AssetsPage)

@Serializable
private data class AssetsPage(val items: List<AssetItem> = emptyList(), val nextPage: String? = null)

@Serializable
private data class AssetItem(
  val id: String,
  val type: String,
  val createdAt: String? = null,
  val duration: Int? = null,
  val width: Int? = null,
  val height: Int? = null,
  val isFavorite: Boolean = false,
  val visibility: String? = null,
  val originalMimeType: String? = null,
  val exifInfo: ExifInfo? = null,
)

@Serializable
private data class ExifInfo(
  val fileSizeInByte: Long? = null,
  val orientation: String? = null,
  val exifImageWidth: Int? = null,
  val exifImageHeight: Int? = null,
  val dateTimeOriginal: String? = null,
)

/**
 * Mirrors the server library into [CloudMediaSyncStore] via `POST /search/metadata`
 * (`withSharedSpaces: true`, which also folds in timeline-enabled partner-shared assets
 * automatically - see `SearchService.getUserIdsToSearch`), instead of the stateful
 * `/sync/stream` delta endpoint. See [CloudMediaSyncStore]'s doc comment for why: that
 * endpoint's checkpoint is keyed per login-session and shared with the main app's own Drift
 * sync, so a second independent consumer acking against it would corrupt the app's own sync
 * progress. `/search/metadata` is a plain stateless paginated listing, safe to poll repeatedly.
 *
 * Runs on the calling thread; callers (the ContentProvider's query methods, or a WorkManager
 * worker) are expected to already be off the main thread.
 */
object CloudMediaSyncEngine {
  private val json = Json { ignoreUnknownKeys = true }

  /** Returns true if the sync completed (regardless of whether anything changed). */
  fun sync(context: Context): Boolean {
    HttpClientManager.initialize(context)
    val baseUrl = HttpClientManager.getServerUrls().firstOrNull()
    if (baseUrl.isNullOrBlank()) {
      Log.i(TAG, "No server configured, skipping cloud media sync")
      return false
    }

    val store = CloudMediaSyncStore(context)
    val generationBefore = store.getGeneration()
    val endpoint = "${baseUrl.trimEnd('/')}/search/metadata"
    val seenIds = mutableSetOf<String>()

    var page = 1
    while (true) {
      val response = fetchPage(endpoint, page) ?: return false
      val rows = response.assets.items.mapNotNull { it.toCloudAssetRow() }
      seenIds.addAll(response.assets.items.map { it.id })
      store.applyUpserts(rows)

      page = response.assets.nextPage?.toIntOrNull() ?: break
    }

    store.sweepDeleted(seenIds)

    if (store.getGeneration() != generationBefore) {
      context.contentResolver.notifyChange(Uri.parse("content://${cloudMediaAuthority(context)}"), null)
    }
    return true
  }

  private fun fetchPage(endpoint: String, page: Int): SearchMetadataResponse? {
    val requestJson = json.encodeToString(
      SearchMetadataRequest.serializer(),
      SearchMetadataRequest(page = page, size = PAGE_SIZE)
    )
    val requestBuilder = Request.Builder()
      .url(endpoint)
      .post(requestJson.toRequestBody("application/json".toMediaType()))
    HttpClientManager.getAuthHeaders(endpoint).forEach { (key, value) -> requestBuilder.header(key, value) }

    return try {
      HttpClientManager.getClient().newCall(requestBuilder.build()).execute().use { response ->
        if (!response.isSuccessful) {
          Log.w(TAG, "search/metadata failed: HTTP ${response.code}")
          return null
        }
        val body = response.body?.string() ?: return null
        json.decodeFromString(SearchMetadataResponse.serializer(), body)
      }
    } catch (e: IOException) {
      Log.w(TAG, "search/metadata request failed", e)
      null
    } catch (e: Exception) {
      Log.w(TAG, "Failed to parse search/metadata response", e)
      null
    }
  }

  private fun AssetItem.toCloudAssetRow(): CloudAssetRow? {
    // Photo Picker only deals in stills and video; skip anything else (e.g. AUDIO/OTHER).
    if (type != "IMAGE" && type != "VIDEO") return null
    // "hidden" is the internal video half of a live photo/motion photo, not a standalone pick
    // target. "locked" (the PIN-protected locked folder) is already excluded server-side by the
    // default 'not-locked' visibility filter.
    if (visibility == "hidden") return null

    val takenMillis = parseIsoMillis(exifInfo?.dateTimeOriginal) ?: parseIsoMillis(createdAt) ?: 0L
    return CloudAssetRow(
      id = id,
      mediaType = type,
      mimeType = originalMimeType ?: if (type == "VIDEO") "video/mp4" else "image/jpeg",
      dateTakenMillis = takenMillis,
      durationMillis = duration?.toLong() ?: 0L,
      isFavorite = isFavorite,
      sizeBytes = exifInfo?.fileSizeInByte ?: 0L,
      width = width ?: exifInfo?.exifImageWidth ?: 0,
      height = height ?: exifInfo?.exifImageHeight ?: 0,
      orientation = exifOrientationToDegrees(exifInfo?.orientation),
    )
  }

  private fun parseIsoMillis(value: String?): Long? {
    if (value.isNullOrBlank()) return null
    return try {
      Instant.parse(value).toEpochMilli()
    } catch (_: Exception) {
      null
    }
  }

  /** EXIF orientation tag (string "1".."8", ignoring the mirrored variants) to rotation degrees. */
  private fun exifOrientationToDegrees(tag: String?): Int = when (tag?.trim()) {
    "3", "4" -> 180
    "5", "6" -> 90
    "7", "8" -> 270
    else -> 0
  }
}
