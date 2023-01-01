package com.keysking.k_ble_peripheral

import android.bluetooth.*
import android.bluetooth.BluetoothProfile.STATE_CONNECTED
import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.keysking.k_ble_peripheral.delegate.*
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
/**
 * GattHandler is the holder and distributor of Gatt resources
 */
class GattHandler(context: Context) : MethodCallHandler {
    private val manager: BluetoothManager = context.getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager

    var eventSink: EventSink? = null
    private val uiThreadHandler: Handler = Handler(Looper.getMainLooper())

    private val serverCallback = object : BluetoothGattServerCallback() {
        override fun onConnectionStateChange(device: BluetoothDevice, status: Int, newState: Int) {
            Log.d("KBlePeripheralPlugin", "onConnectionStateChange")
            if (newState == STATE_CONNECTED) {
                DeviceDelegate.newDevice(device)
            }
            // send event to flutter
            uiThreadHandler.post {
                eventSink?.success(
                    mapOf(
                        Pair("event", "ConnectionStateChange"), Pair("device", device.toMap()), Pair("status", status), Pair("newState", newState)
                    )
                )
            }
            super.onConnectionStateChange(device, status, newState)
        }

        override fun onServiceAdded(status: Int, service: BluetoothGattService?) {
            Log.d("KBlePeripheralPlugin", "onServiceAdded")
            super.onServiceAdded(status, service)
        }


        override fun onCharacteristicReadRequest(device: BluetoothDevice, requestId: Int, offset: Int, characteristic: BluetoothGattCharacteristic) {
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
        }

        override fun onCharacteristicWriteRequest(device: BluetoothDevice, requestId: Int, characteristic: BluetoothGattCharacteristic, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray?) {
            super.onCharacteristicWriteRequest(device, requestId, characteristic, preparedWrite, responseNeeded, offset, value)
            Log.d("KBlePeripheralPlugin", "onCharacteristicWriteRequest")
            uiThreadHandler.post {
                eventSink?.success(
                    mapOf(
                        Pair("event", "CharacteristicWriteRequest"),
                        Pair("entityId", CharacteristicDelegate.getEntityId(characteristic)),
                        Pair("device", device.toMap()),
                        Pair("requestId", requestId),
                        Pair("characteristic", characteristic.toMap()),
                        Pair("preparedWrite", preparedWrite),
                        Pair("responseNeeded", responseNeeded),
                        Pair("offset", offset),
                        Pair("value", value),
                    )
                )
            }
        }

        override fun onDescriptorReadRequest(device: BluetoothDevice?, requestId: Int, offset: Int, descriptor: BluetoothGattDescriptor?) {
            super.onDescriptorReadRequest(device, requestId, offset, descriptor)
            Log.d("KBlePeripheralPlugin", "onDescriptorReadRequest")
        }

        /**
         * 当某设备请求写某个Descriptor的值
         */
        override fun onDescriptorWriteRequest(device: BluetoothDevice, requestId: Int, descriptor: BluetoothGattDescriptor, preparedWrite: Boolean, responseNeeded: Boolean, offset: Int, value: ByteArray) {
            super.onDescriptorWriteRequest(device, requestId, descriptor, preparedWrite, responseNeeded, offset, value)
            Log.d("KBlePeripheralPlugin", "onDescriptorWriteRequest")
            Log.d(
                "KBlePeripheralPlugin", """
                device: $device,
                requestId: $requestId,
                descriptor: ${descriptor.uuid},
                preparedWrite: $preparedWrite,
                responseNeeded: $responseNeeded,
                offset: $offset,
                value: ${value.toList()}
            """.trimIndent()
            )
            // id NotifyDescriptorUuid
            if (descriptor.uuid.toString() == NotifyDescriptorUuid) {
                Log.d("KBlePeripheralPlugin", "onDescriptorWriteRequest:sendResponse")
                val characteristic = descriptor.characteristic
                val entityId = CharacteristicDelegate.getEntityId(characteristic)
                uiThreadHandler.post {
                    eventSink?.success(
                        mapOf(
                            Pair("event", "NotificationStateChange"), Pair("entityId", entityId), Pair("device", device.toMap()), Pair(
                                "enabled", value.contentEquals(BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE)
                            )
                        )
                    )
                }
                gattServer.sendResponse(
                    device, requestId, BluetoothGatt.GATT_SUCCESS, offset, value
                )
            }
        }

        /**
         * 当一个分包写入执行完成时
         */
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
            // create new Characteristic
            "char/create" -> {
                val arguments = call.arguments as Map<*, *>
                val uuid = arguments["uuid"] as String
                val properties = arguments["properties"] as Int
                val permissions = arguments["permissions"] as Int
                val entityId = arguments["entityId"] as String

                CharacteristicDelegate.createCharacteristic(uuid, properties, permissions, entityId)
                result.success(null)
            }
            "char/sendResponse" -> {
                val arguments = call.arguments as Map<*, *>
                val address = arguments["deviceAddress"] as String
                val requestId = arguments["requestId"] as Int
                val offset = arguments["offset"] as Int
                val value = (arguments["value"] as ArrayList<Byte>).toByteArray()

                val device = DeviceDelegate.getDevice(address)
                gattServer.sendResponse(device, requestId, BluetoothGatt.GATT_SUCCESS, offset, value)
                result.success(null)
            }
            "char/notify" -> {
                val arguments = call.arguments as Map<*, *>
                val address = arguments["deviceAddress"] as String
                val entityId = arguments["charEntityId"] as String
                val confirm = arguments["confirm"] as Boolean
                val value = (arguments["value"] as ArrayList<Byte>).toByteArray()

                val device = DeviceDelegate.getDevice(address)
                val kChar = CharacteristicDelegate.getKChar(entityId)
                kChar.characteristic.value = value
                gattServer.notifyCharacteristicChanged(device, kChar.characteristic, confirm)
                result.success(null)
            }
            "service/create" -> {
                val arguments = call.arguments as Map<*, *>
                val entityId = arguments["entityId"] as String
                val uuid = arguments["uuid"] as String
                val type = arguments["type"] as Int
                val characteristics = (arguments["characteristics"] as List<Map<String, Any>>).map {
                    val charUuid = it["uuid"] as String
                    val charProperties = it["properties"] as Int
                    val charPermissions = it["permissions"] as Int
                    val charEntityId = it["entityId"] as String
                    CharacteristicDelegate.createCharacteristic(charUuid, charProperties, charPermissions, charEntityId)
                }

                GattServiceDelegate.createKService(entityId, uuid, type, characteristics)
//                GattServiceDelegate.createKService(call.arguments as Map<String, Any>)
                result.success(null)
            }
            "service/activate" -> {
                GattServiceDelegate.activate(call.arguments as String)
                result.success(null)
            }
            "service/inactivate" -> {
                GattServiceDelegate.inactivate(call.arguments as String)
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

}