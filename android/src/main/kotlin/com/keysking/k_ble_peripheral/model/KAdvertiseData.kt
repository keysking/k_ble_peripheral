package com.keysking.k_ble_peripheral.model

import android.bluetooth.le.AdvertiseData
import android.os.ParcelUuid
import android.util.Log

class KAdvertiseData() {
    private val serviceData: MutableMap<ParcelUuid, ByteArray?> = mutableMapOf()
    private val manufacturerData: MutableMap<Int, ByteArray> = mutableMapOf()
    private var includeDeviceName = true
    private var includeTxPowerLevel = true

    constructor(settingMap: Map<String, Any>) : this() {
        setByMap(settingMap)
    }

    fun toAdvertiseData(): AdvertiseData {
        val builder = AdvertiseData.Builder()
        serviceData.forEach {
            if (it.value == null) {
                builder.addServiceUuid(it.key)
            } else {
                builder.addServiceData(it.key, it.value)
            }
        }
        manufacturerData.forEach {
            builder.addManufacturerData(it.key, it.value)
        }
        builder.setIncludeDeviceName(includeDeviceName) // 是否在广播中携带设备的名称
        builder.setIncludeTxPowerLevel(includeTxPowerLevel) // 是否在广播中携带信号强度
        return builder.build()
    }

    fun setByMap(settingMap: Map<String, Any>) {
        val s = settingMap["serviceData"] as Map<*, *>
        s.forEach {
            val uuid = ParcelUuid.fromString(it.key as String)
            if (it.value == null) {
                serviceData[uuid] = null
            } else {
                val data = it.value as ArrayList<Byte>
                serviceData[uuid] = data.toByteArray()
            }
        }
        val m = settingMap["manufacturerData"] as Map<*, *>
        m.forEach {
            val id = it.key as Int
            val data = it.value as ArrayList<Byte>
            manufacturerData[id] = data.toByteArray()
        }
        includeTxPowerLevel = settingMap["includeTxPowerLevel"] as Boolean
        includeTxPowerLevel = settingMap["includeTxPowerLevel"] as Boolean
    }

}