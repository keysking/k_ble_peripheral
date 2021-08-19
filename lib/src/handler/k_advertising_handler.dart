import 'package:flutter/services.dart';
import 'package:k_ble_peripheral/src/model/k_advertising.dart';

class AdvertisingHandler {
  static const method = const MethodChannel('m:kbp/advertising');
  static final Map<String, KAdvertising> _advertisingMap = Map();

  static List<KAdvertising> get advertisings => _advertisingMap.values.toList();

  static start(KAdvertising advertising) async {
    await method.invokeMethod<String>("startAdvertising", advertising.toMap());
    advertising.isAdvertising = true;
    _advertisingMap[advertising.id] = advertising;
  }

  static stop(KAdvertising advertising) async {
    await method.invokeMethod("stopAdvertising", <String, dynamic>{"id": advertising.id});
    advertising.isAdvertising = false;
    _advertisingMap.remove(advertising.id);
  }
}
