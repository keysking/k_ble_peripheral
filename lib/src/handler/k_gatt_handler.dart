import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';
import 'package:k_ble_peripheral/src/model/k_gatt_device.dart';
import 'package:k_ble_peripheral/src/model/k_gatt_service.dart';

class KGattHandler {
  static const _method = const MethodChannel('m:kbp/gatt');
  static const _connectionEvent = const EventChannel("e:kbp/gatt/connection");
  static final Map<String, KGattService> _serviceMap = Map();

  late final Stream<KGattConnextState> connectState;

  factory KGattHandler() => _getInstance();
  static KGattHandler get instance => _getInstance();
  static KGattHandler? _instance;

  KGattHandler._internal() {
    _connectionEvent.receiveBroadcastStream().listen((event) {});
    connectState = _connectionEvent.receiveBroadcastStream().map((event) {
      final map = Map<String, dynamic>.from(event);
      print("111111111111111111111111111111111111111111");
      print(map);
      return KGattConnextState(
        KGattDevice.fromMap(Map<String, dynamic>.from(map["device"])),
        map["status"] as int,
        map["newState"] as int,
      );
    });
  }
  static KGattHandler _getInstance() {
    if (_instance == null) {
      _instance = new KGattHandler._internal();
    }
    return _instance!;
  }

  addService(KGattService service) async {
    await _method.invokeMethod("addService", <String, dynamic>{
      "Service": service.toMap(),
    });
    _serviceMap[service.uuid] = service;
  }
}
