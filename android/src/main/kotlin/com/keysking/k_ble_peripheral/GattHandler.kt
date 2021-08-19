package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.content.Context
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.*
import java.lang.invoke.MethodHandle
import java.util.*

class GattHandler(private val context: Context) : MethodCallHandler {
    private val manager: BluetoothManager =
        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    private val adapter: BluetoothAdapter = manager.adapter

    private class KGattServerCallback : BluetoothGattServerCallback() {
        lateinit var server: BluetoothGattServer
        override fun onConnectionStateChange(device: BluetoothDevice?, status: Int, newState: Int) {
            Log.d("KBlePeripheralPlugin", "onConnectionStateChange")
            super.onConnectionStateChange(device, status, newState)
        }

        override fun onServiceAdded(status: Int, service: BluetoothGattService?) {
            Log.d("KBlePeripheralPlugin", "onServiceAdded")
            super.onServiceAdded(status, service)
        }

        override fun onCharacteristicReadRequest(
            device: BluetoothDevice?,
            requestId: Int,
            offset: Int,
            characteristic: BluetoothGattCharacteristic
        ) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
            Log.d("KBlePeripheralPlugin", "onCharacteristicReadRequest")
            server.sendResponse(
                device,
                requestId,
                BluetoothGatt.GATT_SUCCESS,
                offset,
                characteristic.value
            );
        }

        override fun onCharacteristicWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            characteristic: BluetoothGattCharacteristic?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onCharacteristicWriteRequest(
                device,
                requestId,
                characteristic,
                preparedWrite,
                responseNeeded,
                offset,
                value
            )
            Log.d("KBlePeripheralPlugin", "onCharacteristicWriteRequest")
        }

        override fun onDescriptorReadRequest(
            device: BluetoothDevice?,
            requestId: Int,
            offset: Int,
            descriptor: BluetoothGattDescriptor?
        ) {
            super.onDescriptorReadRequest(device, requestId, offset, descriptor)
            Log.d("KBlePeripheralPlugin", "onDescriptorReadRequest")
        }

        override fun onDescriptorWriteRequest(
            device: BluetoothDevice?,
            requestId: Int,
            descriptor: BluetoothGattDescriptor?,
            preparedWrite: Boolean,
            responseNeeded: Boolean,
            offset: Int,
            value: ByteArray?
        ) {
            super.onDescriptorWriteRequest(
                device,
                requestId,
                descriptor,
                preparedWrite,
                responseNeeded,
                offset,
                value
            )
            Log.d("KBlePeripheralPlugin", "onDescriptorWriteRequest")
        }

        override fun onExecuteWrite(device: BluetoothDevice?, requestId: Int, execute: Boolean) {
            super.onExecuteWrite(device, requestId, execute)
            Log.d("KBlePeripheralPlugin", "onExecuteWrite")
        }

        override fun onNotificationSent(device: BluetoothDevice?, status: Int) {
            super.onNotificationSent(device, status)
            Log.d("KBlePeripheralPlugin", "onNotificationSent")
        }

        override fun onMtuChanged(device: BluetoothDevice?, mtu: Int) {
            super.onMtuChanged(device, mtu)
            Log.d("KBlePeripheralPlugin", "onMtuChanged")
        }

        override fun onPhyUpdate(device: BluetoothDevice?, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyUpdate(device, txPhy, rxPhy, status)
            Log.d("KBlePeripheralPlugin", "onPhyUpdate")
        }

        override fun onPhyRead(device: BluetoothDevice?, txPhy: Int, rxPhy: Int, status: Int) {
            super.onPhyRead(device, txPhy, rxPhy, status)
            Log.d("KBlePeripheralPlugin", "onPhyRead")
        }
    }

    fun addGattService() {
        val callback = KGattServerCallback()
        val gattServer = manager.openGattServer(context, callback)
        callback.server = gattServer
        val service =
            BluetoothGattService(UUID.randomUUID(), BluetoothGattService.SERVICE_TYPE_PRIMARY)
        val characteristic = BluetoothGattCharacteristic(
            UUID.randomUUID(),
            BluetoothGattCharacteristic.PROPERTY_READ,
            BluetoothGattCharacteristic.PERMISSION_READ
        )
        characteristic.value = mutableListOf<Byte>(0x22).toByteArray()
        service.addCharacteristic(characteristic)

        gattServer.addService(service)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            else -> result.notImplemented()
        }
    }

}