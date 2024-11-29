package io.teragroup.one_loyalty_data_flutter

import androidx.annotation.NonNull
import android.content.Context

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.teragroup.io.onappdata.OneLoyalty
import com.teragroup.io.onappdata.configs.Config
import com.teragroup.io.onappdata.model.DeviceTimezone
import com.teragroup.io.onappdata.serializer.JsonProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

import android.provider.Settings
import java.util.TimeZone

/** OneLoyaltyDataFlutterPlugin */
class OneLoyaltyDataFlutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var appContext: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "one_loyalty_data_flutter")
    channel.setMethodCallHandler(this)
    appContext = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "setupSDK") {
      CoroutineScope(Dispatchers.IO).launch {
        val arguments = call.arguments as Map<String, Any>
        val apiKey = arguments["apiKey"] as? String
        val apiToken = arguments["apiToken"] as? String
        val clientId = arguments["clientId"] as? String

        OneLoyalty.setup(appContext.application, Config(apiKey = apiKey.orEmpty(), apiToken = apiToken.orEmpty(), clientId = clientId.orEmpty()))
        val deviceId = try {
          Settings.Secure.getString(context.contentResolver, Settings.Secure.ANDROID_ID)
        } catch (e: Exception) {
          ""
        }
        OneLoyalty.cacheDeviceTimezone(DeviceTimezone(deviceId, timezone = TimeZone.getDefault().id))
        withContext(Dispatchers.Main) {
          result.success(true)
        }
      }
    } else if (call.method == "getListMission") {
      CoroutineScope(Dispatchers.IO).launch {
        val response = OneLoyalty.loyaltyService.getListMission()
        withContext(Dispatchers.Main) {
          result.success(response)
        }
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
