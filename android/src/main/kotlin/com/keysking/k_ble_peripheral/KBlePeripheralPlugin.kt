package com.keysking.k_ble_peripheral

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel

/** KBlePeripheralPlugin */
class KBlePeripheralPlugin : FlutterPlugin, ActivityAware {
    private lateinit var advertisingChannel: MethodChannel
    private lateinit var gattChannel: MethodChannel
    private lateinit var gattConnectionEventChannel: EventChannel
    private lateinit var context: Context
    private lateinit var advertisingHandler: AdvertisingHandler
    private lateinit var gattHandler: GattHandler
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onAttachedToEngine!")
        advertisingChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "m:kbp/advertising")
        gattChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "m:kbp/gatt")
        gattConnectionEventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "e:kbp/gatt/connection")
        gattConnectionEventChannel.setStreamHandler(object : StreamHandler {
            override fun onListen(arguments: Any?, events: EventSink) {
                gattHandler.connectionEventSink = events
            }

            override fun onCancel(arguments: Any?) {
                gattHandler.connectionEventSink = null
            }
        })
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onDetachedFromEngine")
        advertisingChannel.setMethodCallHandler(null)
        gattChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d("KBlePeripheralPlugin", "onAttachedToActivity!!")
        context = binding.activity
        advertisingHandler = AdvertisingHandler(context)
        gattHandler = GattHandler(context)
        advertisingChannel.setMethodCallHandler(advertisingHandler)
        gattChannel.setMethodCallHandler(gattHandler)
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
