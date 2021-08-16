import 'dart:async';
import 'package:flutter/services.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';
import 'package:k_ble_peripheral/src/model/k_advertise_data.dart';

class KBlePeripheral {
  static const method = const MethodChannel('m:kbp/main');

  // 单例
  static KBlePeripheral? _instance;

  factory KBlePeripheral() {
    var instance = _instance;
    if (instance == null) {
      instance = KBlePeripheral._internal();
      _instance = instance;
    }
    return instance;
  }

  KBlePeripheral._internal();

  KAdvertiseSetting advertiseSetting = KAdvertiseSetting();
  KAdvertiseData advertiseData = KAdvertiseData();
  KAdvertiseData scanResponseData = KAdvertiseData();

  startAdvertising() async {
    await method.invokeMethod("startAdvertising", <String, dynamic>{
      "AdvertiseSetting": advertiseSetting.toMap(),
      "AdvertiseData": advertiseData.toMap(),
      "ScanResponseData": scanResponseData.toMap(),
    });
  }
}
