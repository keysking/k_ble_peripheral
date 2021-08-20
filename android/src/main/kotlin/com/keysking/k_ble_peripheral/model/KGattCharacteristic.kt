package com.keysking.k_ble_peripheral.model

import android.bluetooth.BluetoothGattCharacteristic
import java.util.*

class KGattCharacteristic(var uuid: String) {
    var properties = 0
    var permissions = 0

    constructor(map: Map<String, Any>) : this("") {
        setByMap(map);
    }

    fun toCharacteristic(): BluetoothGattCharacteristic {
        val characteristic =
            BluetoothGattCharacteristic(UUID.fromString(uuid), properties, permissions)
//        characteristic.value = mutableListOf<Byte>(0x22).toByteArray()
//        service.addCharacteristic(characteristic)
        return characteristic
    }

    fun setByMap(map: Map<String, Any>) {
        uuid = map["uuid"] as String
        properties = map["properties"] as Int
        permissions = map["permissions"] as Int
    }
}