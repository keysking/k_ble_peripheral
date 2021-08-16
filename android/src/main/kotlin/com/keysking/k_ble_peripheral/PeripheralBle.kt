package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.bluetooth.le.AdvertiseCallback
import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.BluetoothLeAdvertiser
import android.content.Context
import android.util.Log
import com.keysking.k_ble_peripheral.model.KAdvertiseData
import com.keysking.k_ble_peripheral.model.KAdvertiseSetting

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
    private val advertisingCallback = object : AdvertiseCallback() {
        override fun onStartSuccess(settingsInEffect: AdvertiseSettings?) {
            // TODO 启动成功后放置Services
            super.onStartSuccess(settingsInEffect)
        }

        override fun onStartFailure(errorCode: Int) {
            // TODO 启动失败报错
            super.onStartFailure(errorCode)
        }
    }

    //    fun start() {
//        Log.e("KBlePeripheralPlugin", "start: ${context.packageName}")
//    }
    fun startAdvertising(advertiseSettings: KAdvertiseSetting, advertiseData: KAdvertiseData, scanResponseData: KAdvertiseData) {
        Log.e("KBlePeripheralPlugin", "start: ${context.packageName}~~~")
        // TODO auto open bluetooth when it closed

        // 广播设置
        val settings = advertiseSettings.toAdvertiseSetting()

        // 广播数据
        val data = advertiseData.toAdvertiseData()

        // 扫描回包数据
        val scanResponse = scanResponseData.toAdvertiseData()

        adapter.name = advertiseSettings.name

        advertiser.startAdvertising(settings, data, scanResponse, advertisingCallback)
    }
}