package app.alextran.immich

import android.app.Application
import android.content.ComponentName
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.work.Configuration
import androidx.work.WorkManager
import app.alextran.immich.background.BackgroundEngineLock
import app.alextran.immich.background.BackgroundWorkerApiImpl

class ImmichApp : Application() {
  override fun onCreate() {
    super.onCreate()
    // CloudMediaProviderImpl.onCreate() runs before this (content providers are created before
    // Application.onCreate()) and may have already initialized WorkManager to schedule its sync
    // worker - initializing twice throws, so only do it here if that didn't happen.
    if (!WorkManager.isInitialized()) {
      WorkManager.initialize(this, Configuration.Builder().build())
    }
    enableCloudMediaProviderIfSupported()
    // always start BackupWorker after WorkManager init; this fixes the following bug:
    // After the process is killed (by user or system), the first trigger (taking a new picture) is lost.
    // Thus, the BackupWorker is not started. If the system kills the process after each initialization
    // (because of low memory etc.), the backup is never performed.
    // As a workaround, we also run a backup check when initializing the application
    Handler(Looper.getMainLooper()).postDelayed({
      // We can only check the engine count and not the status of the lock here,
      // as the previous start might have been killed without unlocking.
      if (BackgroundEngineLock.connectEngines > 0) return@postDelayed
      BackgroundWorkerApiImpl.enqueueBackgroundWorker(this)
    }, 15000)
  }

  /**
   * `CloudMediaProviderImpl` extends the platform `android.provider.CloudMediaProvider`, which
   * doesn't exist below API 34 - simply referencing that class (even just to obtain its
   * `Class` object) would throw `NoClassDefFoundError` on older devices. The `<provider>` entry
   * in the manifest therefore ships `android:enabled="false"`, so ActivityThread never attempts
   * to load it at process start on any API level. Here we flip it on, by string component name
   * only (never `CloudMediaProviderImpl::class`, which would force-load the class), exclusively
   * on API 34+ where the superclass genuinely exists. The flag persists in the system's package
   * state once set, so this only needs to run once - after the user's first launch on a
   * qualifying device, the provider registers itself with the OS and stays enabled.
   */
  private fun enableCloudMediaProviderIfSupported() {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return
    val component = ComponentName(this, "app.alextran.immich.cloudmedia.CloudMediaProviderImpl")
    if (packageManager.getComponentEnabledSetting(component) != PackageManager.COMPONENT_ENABLED_STATE_ENABLED) {
      packageManager.setComponentEnabledSetting(
        component,
        PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
        PackageManager.DONT_KILL_APP
      )
    }
  }
}
