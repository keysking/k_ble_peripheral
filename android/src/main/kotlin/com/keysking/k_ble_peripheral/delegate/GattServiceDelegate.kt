package com.keysking.k_ble_peripheral.delegate

import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattService
import com.keysking.k_ble_peripheral.delegate.CharacteristicDelegate.createCharacteristic
import com.keysking.k_ble_peripheral.model.KGattService
import java.util.*

object GattServiceDelegate {
    // 保存所有创建的service,key值是entityId,用于检索
    private val services = mutableMapOf<String, KGattService>()

    fun addService(gattServer: BluetoothGattServer, map: Map<String, Any>) {
        val kService = createKService(map)
        addService(gattServer, kService)
    }

    fun addService(gattServer: BluetoothGattServer, kService: KGattService) {
        gattServer.addService(kService.service)
    }

    /**
     * 通过map创建Service
     */
    fun createKService(map: Map<String, Any>): KGattService {
        val entityId = map["entityId"] as String
        val uuid = map["uuid"] as String
        val serviceType = map["type"] as Int
        val service = BluetoothGattService(UUID.fromString(uuid), serviceType)
        val cList = map["characteristics"] as List<Map<String, Any>>
        cList.forEach {
            service.addCharacteristic(createCharacteristic(it))
        }
        val kService = KGattService(entityId, service, false)
        services[entityId] = kService
        return kService
    }
}


