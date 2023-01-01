package com.keysking.k_ble_peripheral.delegate

import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattService
import com.keysking.k_ble_peripheral.model.KGattCharacteristic
import com.keysking.k_ble_peripheral.model.KGattService
import java.util.*

object GattServiceDelegate {
    // 保存所有创建的service,key值是entityId,用于检索
    private val services = mutableMapOf<String, KGattService>()
    lateinit var gattServer: BluetoothGattServer

    /**
     * 激活Service
     */
    fun activate(entityId: String) {
        val kService = services[entityId] ?: throw NotFoundGattService
        gattServer.addService(kService.service)
        kService.activated = true
    }

    /**
     * 注销Service
     */
    fun inactivate(entityId: String) {
        val kService = services[entityId] ?: throw NotFoundGattService
        gattServer.removeService(kService.service)
        kService.activated = false
    }

    fun createKService(entityId: String, uuid: String, type: Int, characteristics: List<KGattCharacteristic>): KGattService {
        val service = BluetoothGattService(UUID.fromString(uuid), type)
        characteristics.forEach {
            service.addCharacteristic(it.characteristic)
        }
        val kService = KGattService(entityId, service, false)
        services[entityId] = kService
        return kService
    }
}

object NotFoundGattService : RuntimeException("Not Found Gatt Service,may be the entityId is wrong.")

