package com.keysking.k_ble_peripheral.model

import android.bluetooth.BluetoothDevice
import android.os.Build

fun BluetoothDevice.toMap(): Map<String, Any?> {
    val mAlisa = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) alias else null
    // TODO device.bluetoothClass
    return mutableMapOf(
        Pair("address", address),
        Pair("name", name),
        Pair("bondState", bondState),
        Pair("alias", mAlisa),
        Pair("type", type),
    )
}