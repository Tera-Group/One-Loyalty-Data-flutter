package io.teragroup.one_loyalty_data_flutter

import OnTracking
import android.content.Context
import android.content.pm.PackageManager.NameNotFoundException
import android.os.Build
import android.provider.Settings
import com.teragroup.io.onappdata.OneLoyalty
import com.teragroup.io.onappdata.configs.Config
import com.teragroup.io.onappdata.model.LoyaltyDevice
import com.teragroup.io.onappdata.model.constant.DeviceType
import com.teragroup.io.onappdata.model.loyalty.Mission
import com.teragroup.io.onappdata.model.tracking.App
import com.teragroup.io.onappdata.model.tracking.AppContext
import com.teragroup.io.onappdata.model.tracking.Sdk
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.Locale
import java.util.TimeZone
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/** OneLoyaltyDataFlutterPlugin */
class OneLoyaltyDataFlutterPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "one_loyalty_data_flutter")
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                when (call.method) {
                    "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
                    "setupSDK" -> onSetup(call, result)
                    "getListMission" -> getListMission(call, result)
                    "getUser" -> getUser(call, result)
                    "trackingEvent" -> trackingEvent(call, result)
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error(e.message.orEmpty(), e.message, e.message)
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private suspend fun onSetup(call: MethodCall, result: Result) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val apiKey = arguments["apiKey"] as? String
            val clientId = arguments["clientId"] as? String
            if (!apiKey.isNullOrBlank() && !clientId.isNullOrBlank()) {
                val deviceId = kotlin.runCatching {
                    Settings.Secure.getString(applicationContext.contentResolver, Settings.Secure.ANDROID_ID)
                }.getOrNull().orEmpty()

                OneLoyalty.setup(
                    applicationContext,
                    Config(apiKey, clientId),
                    appContext = buildAppContext(context = applicationContext, deviceId)
                )
                result.success(true)
            } else {
                result.success(false)
            }

        } catch (e: Exception) {
            e.printStackTrace()
            result.success(false)
        }
    }

    private suspend fun getListMission(call: MethodCall, result: Result) {
        try {
            val missions = OneLoyalty.loyaltyService.getListMission()
            result.success(Mission.jsonStringFrom(missions))
        } catch (error: Exception) {
            result.error("get missions error", error.message, null)
        }
    }

    private suspend fun getUser(call: MethodCall, result: Result) {
        try {
            val user = OneLoyalty.loyaltyService.getUser()
            result.success(user.toJsonString())
        } catch (error: Exception) {
            result.error("get user error", error.message, null)
        }
    }

    private suspend fun trackingEvent(call: MethodCall, result: Result) {
        try {
            val arguments = call.arguments as Map<String, Any>
            val eventName = arguments["eventName"] as? String
            val properties = arguments["properties"] as? Map<String, Any>
            OnTracking.trackEvent(eventName.orEmpty(), properties)
            result.success(true)
        } catch (error: Exception) {
            result.error("Tracking event error", error.message, null)
        }
    }

    private fun buildAppContext(context: Context, deviceId: String): AppContext {
        val deviceName = "${Build.BRAND} ${Build.MODEL}".trim()
        val displayMetrics = context.resources.displayMetrics
        return AppContext(
            appInformation = context.getAppInfo(),
            device = LoyaltyDevice(
                id = deviceId,
                name = deviceName,
                timezone = TimeZone.getDefault().id,
                language = Locale.getDefault().language,
                os = "Android",
                osVersion = Build.VERSION.RELEASE,
                type = context.deviceType(),
                width = displayMetrics.widthPixels.toString(),
                height = displayMetrics.heightPixels.toString(),
                model = Build.MODEL
            )
        )
    }

    private fun Context.deviceType(): DeviceType {
        return DeviceType.TABLET.takeIf {
            resources.configuration.smallestScreenWidthDp >= 600
        } ?: DeviceType.PHONE
    }

    private fun Context.getAppInfo(): App {
        val packageInfo = try {
            packageManager.getPackageInfo(packageName, 0)
        } catch (e: NameNotFoundException) {
            null
        }
        val versionCode = packageInfo?.let {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                packageInfo.longVersionCode
            } else {
                packageInfo.versionCode.toLong()
            }
        } ?: 1L
        return App(
            build = versionCode.toString(),
            bundleId = packageName,
            name = packageManager.getApplicationLabel(applicationInfo).toString(),
            version = packageInfo?.versionName ?: "1.0"
        )
    }
}
