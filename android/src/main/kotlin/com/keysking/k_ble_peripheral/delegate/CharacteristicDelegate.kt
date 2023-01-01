package com.keysking.k_ble_peripheral.delegate

import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import com.keysking.k_ble_peripheral.model.KGattCharacteristic
import java.util.*

const val NotifyDescriptorUuid = "00002902-0000-1000-8000-00805f9b34fb"

object CharacteristicDelegate {
    // 保存所有创建的characteristic,key值是entityId,用于检索
    private val characteristics = mutableMapOf<String, KGattCharacteristic>()

    fun getEntityId(c: BluetoothGattCharacteristic): String? {
        characteristics.forEach {
            if (it.value.characteristic == c) {
                return it.key
            }
        }
        return null
    }

    fun getKChar(entityId: String): KGattCharacteristic {
        return characteristics[entityId] ?: throw NotFoundCharacteristic
    }

    fun createCharacteristic(uuid: String, properties: Int, permissions: Int, entityId: String): KGattCharacteristic {
        val characteristic = BluetoothGattCharacteristic(UUID.fromString(uuid), properties, permissions)
        // If Notify is required, the corresponding Descriptor is automatically added
        if ((properties and BluetoothGattCharacteristic.PROPERTY_NOTIFY) != 0) {
            val descriptor = BluetoothGattDescriptor(
                UUID.fromString(NotifyDescriptorUuid), BluetoothGattDescriptor.PERMISSION_WRITE or BluetoothGattDescriptor.PERMISSION_READ
            )
            descriptor.value = BluetoothGattDescriptor.ENABLE_NOTIFICATION_VALUE
            characteristic.addDescriptor(descriptor)
        }
        val kChar = KGattCharacteristic(entityId, characteristic)
        characteristics[entityId] = kChar
        return kChar
    }
}

fun BluetoothGattCharacteristic.toMap(): MutableMap<String, Any?> {
    return mutableMapOf(
        Pair("uuid", uuid.toString()),
        Pair("properties", properties),
        Pair("permissions", permissions),
    )
}

object NotFoundCharacteristic : RuntimeException("Not Found Gatt Characteristic,may be the entityId is wrong.")