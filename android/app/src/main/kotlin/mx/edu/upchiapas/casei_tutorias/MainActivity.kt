package mx.edu.upchiapas.casei_tutorias

import android.os.Bundle
import android.provider.Settings
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val securityChannel = "mx.edu.upchiapas.casei_tutorias/security"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, securityChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getEnvironmentState" -> result.success(
                        mapOf(
                            "adbEnabled" to isSettingEnabled(Settings.Global.ADB_ENABLED),
                            "developerOptionsEnabled" to isSettingEnabled(
                                Settings.Global.DEVELOPMENT_SETTINGS_ENABLED
                            )
                        )
                    )
                    else -> result.notImplemented()
                }
            }
    }

    private fun isSettingEnabled(settingName: String): Boolean {
        return Settings.Global.getInt(contentResolver, settingName, 0) == 1
    }
}
