package com.keysking.k_ble_peripheral

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.keysking.k_ble_peripheral.model.KAdvertiseData
import com.keysking.k_ble_peripheral.model.KAdvertiseSetting

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** KBlePeripheralPlugin */
class KBlePeripheralPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var context: Context
    private lateinit var peripheralBle: PeripheralBle
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onAttachedToEngine")
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "m:kbp/main")
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "startAdvertising" -> {
                Log.d("KBlePeripheralPlugin", "startAdvertising")
                val kAdvertiseSetting = KAdvertiseSetting()
                call.argument<Map<String, Any>>("AdvertiseSetting")?.let {
                    kAdvertiseSetting.setByMap(it)
                }
                val kAdvertiseData = KAdvertiseData()
                call.argument<Map<String, Any>>("AdvertiseData")?.let {
                    kAdvertiseData.setByMap(it)
                }
                val scanResponseData = KAdvertiseData()
                call.argument<Map<String, Any>>("ScanResponseData")?.let {
                    scanResponseData.setByMap(it)
                }
                peripheralBle.startAdvertising(kAdvertiseSetting, kAdvertiseData, scanResponseData, result)
            }
            "stopAdvertising" -> {
                Log.d("KBlePeripheralPlugin", "stopAdvertising")
                val id = call.argument<String>("id")
                peripheralBle.stopAdvertising(id!!, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onDetachedFromEngine")
        methodChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        context = binding.activity
        peripheralBle = PeripheralBle(context)
        Log.d("KBlePeripheralPlugin", "onAttachedToActivity!!")
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d("KBlePeripheralPlugin", "onDetachedFromActivityForConfigChanges")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onReattachedToActivityForConfigChanges")
    }

    override fun onDetachedFromActivity() {
        Log.d("KBlePeripheralPlugin", "onDetachedFromActivity")
    }
}
