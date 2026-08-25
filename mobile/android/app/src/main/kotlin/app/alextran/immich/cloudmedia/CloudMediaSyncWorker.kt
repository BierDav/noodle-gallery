package app.alextran.immich.cloudmedia

import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters

private const val TAG = "CloudMediaSyncWorker"

/**
 * Periodic (and one-off, right after the provider is first enabled) refresh of
 * [CloudMediaSyncStore] so the system Photo Picker sees new/changed/deleted server assets without
 * requiring a live query - `WorkManager` runs `doWork()` on its own background thread, and
 * [CloudMediaSyncEngine] does plain blocking HTTP/SQLite work, so no Flutter engine is needed
 * here (contrast with `background.BackgroundWorker`, which spins up a headless one for uploads).
 */
class CloudMediaSyncWorker(context: Context, params: WorkerParameters) : Worker(context, params) {
  override fun doWork(): Result {
    val success = try {
      CloudMediaSyncEngine.sync(applicationContext)
    } catch (e: Exception) {
      Log.w(TAG, "Cloud media sync failed", e)
      false
    }
    return if (success) Result.success() else Result.retry()
  }
}
