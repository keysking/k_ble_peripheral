package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.Context
import android.util.Log
import android.view.KeyCharacterMap
import com.keysking.k_ble_peripheral.model.KAdvertiseData
import com.keysking.k_ble_peripheral.model.KAdvertiseSetting
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.util.*

class PeripheralBle(private val context: Context) {
    private val manager: BluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val adapter: BluetoothAdapter = manager.adapter
    private val advertiser: BluetoothLeAdvertiser = adapter.bluetoothLeAdvertiser

    private val serverCallback = object : BluetoothGattServerCallback() {
        override fun onConnectionStateChange(device: BluetoothDevice?, status: Int, newState: Int) {
            super.onConnectionStateChange(device, status, newState)
        }

        override fun onCharacteristicReadRequest(device: BluetoothDevice?, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic?) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
        }
    }

    /**
     * 广播启动回调函数
     */
    private class KAdvertiseCallback(val result: Result, val uuid: UUID) : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
            // TODO 启动成功后放置Services
            super.onStartSuccess(settingsInEffect)
            result.success(uuid.toString())
        }

        override fun onStartFailure(errorCode: Int) {
            // TODO 启动失败报错
            super.onStartFailure(errorCode)
            result.error(errorCode.toString(), "", null)
        }
    }

    private val advertiseCallbackMap = mutableMapOf<String, KAdvertiseCallback>()
    fun startAdvertising(advertiseSettings: KAdvertiseSetting, advertiseData: KAdvertiseData, scanResponseData: KAdvertiseData, result: Result) {
        // TODO auto open bluetooth when it closed

        // 广播设置
        val settings = advertiseSettings.toAdvertiseSetting()

        // 广播数据
        val data = advertiseData.toAdvertiseData()

        // 扫描回包数据
        val scanResponse = scanResponseData.toAdvertiseData()

        adapter.name = advertiseSettings.name

        val uuid = UUID.randomUUID()
        val callback = KAdvertiseCallback(result, uuid)
        advertiseCallbackMap[uuid.toString()] = callback
        advertiser.startAdvertising(settings, data, scanResponse, callback)
    }

    fun stopAdvertising(uuid: String, result: Result) {
        val callback = advertiseCallbackMap[uuid]
        if (callback == null) {
            result.error("1", "id错误或对应广播已关闭", null)
        } else {
            advertiser.stopAdvertising(callback)
            advertiseCallbackMap.remove(uuid)
            result.success(null)
        }
    }
}