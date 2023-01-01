package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.Context
import android.util.Log
import com.keysking.k_ble_peripheral.model.KAdvertiseData
import com.keysking.k_ble_peripheral.model.KAdvertiseSetting
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.*

class AdvertisingHandler(context: Context) : MethodCallHandler {
    private val manager: BluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val adapter: BluetoothAdapter = manager.adapter
    private val advertiser: BluetoothLeAdvertiser = adapter.bluetoothLeAdvertiser

    /**
     * 广播启动回调函数
     */
    private class KAdvertiseCallback(val result: Result, val uuid: String) : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
            super.onStartSuccess(settingsInEffect)
            result.success(uuid)
        }

        override fun onStartFailure(errorCode: Int) {
            super.onStartFailure(errorCode)
            result.error(errorCode.toString(), "Advertising failed to start", null)
        }
    }

    private val advertiseCallbackMap = mutableMapOf<String, KAdvertiseCallback>()
    private fun startAdvertising(
        id: String, advertiseSettings: KAdvertiseSetting, advertiseData: KAdvertiseData, scanResponseData: KAdvertiseData, result: Result
    ) {
        // TODO auto open bluetooth when it closed

        // 广播设置
        val settings = advertiseSettings.toAdvertiseSetting()

        // 广播数据
        val data = advertiseData.toAdvertiseData()

        // 扫描回包数据
        val scanResponse = scanResponseData.toAdvertiseData()

        adapter.name = advertiseSettings.name

        val callback = KAdvertiseCallback(result, id)
        advertiseCallbackMap[id] = callback
        advertiser.startAdvertising(settings, data, scanResponse, callback)
    }

    private fun stopAdvertising(uuid: String?, result: Result) {
        // stop all advertising when uuid is null
        if (uuid == null) {
            advertiseCallbackMap.forEach {
                advertiser.stopAdvertising(it.value)
            }
        } else {
            val callback = advertiseCallbackMap[uuid]
            if (callback == null) {
                result.error("1", "The id is wrong or the advertising is turned off", null)
            } else {
                advertiser.stopAdvertising(callback)
                advertiseCallbackMap.remove(uuid)
                result.success(null)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d("KBlePeripheralPlugin", "onMethodCall->${call.method}")
        when (call.method) {
            "startAdvertising" -> {
                val id = call.argument<String>("Id")!!
                val kAdvertiseSetting = KAdvertiseSetting(call.argument<Map<String, Any>>("AdvertiseSetting")!!)
                val kAdvertiseData = KAdvertiseData(call.argument<Map<String, Any>>("AdvertiseData")!!)
                val scanResponseData = KAdvertiseData(call.argument<Map<String, Any>>("ScanResponseData")!!)

                startAdvertising(id, kAdvertiseSetting, kAdvertiseData, scanResponseData, result)
            }
            "stopAdvertising" -> {
                val id = call.argument<String>("id")
                stopAdvertising(id!!, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }
}