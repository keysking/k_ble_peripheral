package com.keysking.k_ble_peripheral.model

import android.bluetooth.le.AdvertiseSettings

/**
 * 广播设置
 */
class KAdvertiseSetting() {
    constructor(settingMap: Map<String, Any>) : this() {
        setByMap(settingMap)
    }

    // 广播名称
    var name: String? = null

    // 是否可以被连接
    var connectable = true

    // 广播超时
    var timeout = 0

    // 广播模式(LOW_POWER/BALANCED/LOW_LATENCY)
    var advertiseMode = AdvertiseSettings.ADVERTISE_MODE_BALANCED

    var txPowerLevel = AdvertiseSettings.ADVERTISE_TX_POWER_HIGH

    fun toAdvertiseSetting(): AdvertiseSettings = AdvertiseSettings.Builder()
        .setConnectable(connectable)
        .setTimeout(timeout)
        .setAdvertiseMode(advertiseMode)
        .setTxPowerLevel(txPowerLevel)
        .build()

    fun setByMap(settingMap: Map<String, Any>) {
        name = settingMap["name"] as String?
        connectable = settingMap["connectable"] as Boolean
        timeout = settingMap["timeout"] as Int
        advertiseMode = settingMap["advertiseMode"] as Int
        txPowerLevel = settingMap["txPowerLevel"] as Int
    }
}