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

   Future<String> startAdvertising() async {
    final id = await method.invokeMethod<String>("startAdvertising", <String, dynamic>{
      "AdvertiseSetting": advertiseSetting.toMap(),
      "AdvertiseData": advertiseData.toMap(),
      "ScanResponseData": scanResponseData.toMap(),
    });
    print("开启成功");
    return id!;
  }

  stopAdvertising(String id) async {
    await method.invokeMethod("stopAdvertising", <String, dynamic>{"id": id});
    print("关闭成功");
  }
}
