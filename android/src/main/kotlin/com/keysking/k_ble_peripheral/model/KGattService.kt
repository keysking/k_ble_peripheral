package com.keysking.k_ble_peripheral.model

import android.bluetooth.BluetoothGattService

data class KGattService(
    val entityId: String,
    val service: BluetoothGattService,
    var activated: Boolean = false,
)