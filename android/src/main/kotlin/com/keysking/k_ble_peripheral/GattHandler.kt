package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.bluetooth.BluetoothProfile.STATE_CONNECTED
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.keysking.k_ble_peripheral.delegate.CharacteristicDelegate
import com.keysking.k_ble_peripheral.delegate.DeviceDelegate
import com.keysking.k_ble_peripheral.delegate.GattServiceDelegate
import com.keysking.k_ble_peripheral.delegate.toMap
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Gatt相关资源的持有者和Gatt宏观操作的操作者与分配者
 */
class GattHandler(private val context: Context) : MethodCallHandler {
    private val manager: BluetoothManager =
        context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

    var eventSink: EventSink? = null
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    private val serverCallback = object : BluetoothGattServerCallback() {
        /**
         * 连接状态发生变化
         *  通过eventChannel通知flutter端
         */
        override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
            Log.d("KBlePeripheralPlugin", "onConnectionStateChange")
            if (newState == STATE_CONNECTED) {
                DeviceDelegate.newDevice(device)
            }
            uiThreadHandler.post {
                eventSink?.success(
                    mapOf(
                        Pair("event", "ConnectionStateChange"),
                        Pair("device", device.toMap()),
                        Pair("status", status),
                        Pair("newState", newState)
                    )
                )
            }
            super.onConnectionStateChange(device, status, newState)
        }

        /**
         * 当添加了一个Service到Gatt
         */
        override fun onServiceAdded(status: Int, service: BluetoothGattService?) {
            Log.d("KBlePeripheralPlugin", "onServiceAdded")
            super.onServiceAdded(status, service)
        }

        /**
         * 当某设备请求读取某个Characteristic的值
         */
        override fun onCharacteristicReadRequest(
            device: BluetoothDevice,
            requestId: Int,
            offset: Int,
            characteristic: BluetoothGattCharacteristic
        ) {
            super.onCharacteristicReadRequest(device, requestId, offset, characteristic)
            Log.d("KBlePeripheralPlugin", "onCharacteristicReadRequest")
            uiThreadHandler.post {
                eventSink?.success(
                    mapOf(
                        Pair("event", "CharacteristicReadRequest"),
                        Pair("device", device.toMap()),
                        Pair("requestId", requestId),
                        Pair("offset", offset),
                        Pair("entityId", CharacteristicDelegate.getEntityId(characteristic)),
                        Pair("characteristic", characteristic.toMap()),
                    )
                )
            }
//            gattServer.sendResponse(
//                device,
//                requestId,
//                BluetoothGatt.GATT_SUCCESS,
//                offset,
//                characteristic.value
//            )
        }

        /**
         * 当某设备请求写某个Characteristic的值
         */
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

        /**
         * 当某设备请求读某个Descriptor的值
         */
        override fun onDescriptorReadRequest(
            device: BluetoothDevice?,
            requestId: Int,
            offset: Int,
            descriptor: BluetoothGattDescriptor?
        ) {
            super.onDescriptorReadRequest(device, requestId, offset, descriptor)
            Log.d("KBlePeripheralPlugin", "onDescriptorReadRequest")
        }

        /**
         * 当某设备请求写某个Descriptor的值
         */
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
    private val gattServer: BluetoothGattServer = manager.openGattServer(context, serverCallback)

    init {
        GattServiceDelegate.gattServer = gattServer
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            // 新建Characteristic
            "char/create" -> {
                CharacteristicDelegate.createCharacteristic(call.arguments())
                result.success(null)
            }
            "service/create" -> {
                GattServiceDelegate.createKService(call.arguments())
                result.success(null)
            }
            "service/activate" -> {
                GattServiceDelegate.activate(call.arguments())
                result.success(null)
            }
            "service/inactivate" -> {
                GattServiceDelegate.inactivate(call.arguments())
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

}