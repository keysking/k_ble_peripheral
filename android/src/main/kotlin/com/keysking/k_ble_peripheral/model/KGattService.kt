package com.keysking.k_ble_peripheral.model

import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothGattService.SERVICE_TYPE_PRIMARY
import java.util.*


class KGattService(var uuid: String) {
    var serviceType = SERVICE_TYPE_PRIMARY
    val characteristics = mutableListOf<KGattCharacteristic>()

    constructor(map: Map<String, Any>) : this("") {
        setByMap(map)
    }

    fun toService(): BluetoothGattService {
        val service = BluetoothGattService(UUID.fromString(uuid), serviceType)
        characteristics.forEach {
            service.addCharacteristic(it.toCharacteristic())
        }
        return service
    }

    fun setByMap(map: Map<String, Any>) {
        uuid = map["uuid"] as String
        serviceType = map["type"] as Int
        val cList = map["characteristics"] as List<Map<String, Any>>
        cList.forEach {
            val c = KGattCharacteristic(it)
            characteristics.add(c)
        }
    }
}