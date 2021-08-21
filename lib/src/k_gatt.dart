import 'package:k_ble_peripheral/k_ble_peripheral.dart';
import 'package:k_ble_peripheral/src/model/k_gatt_device.dart';
import 'package:k_ble_peripheral/src/model/k_gatt_service.dart';

import 'handler/k_gatt_handler.dart';

class KGatt {
  late final Stream<KGattConnextState> connectState;

  factory KGatt() => _getInstance();
  static KGatt? _instance;

  KGatt._internal() {
    connectState = KGattHandler()
        .eventStream
        .where((event) => event['event'] == 'ConnectionStateChange')
        .map(
          (event) => KGattConnextState(
            KGattDevice.fromMap(Map<String, dynamic>.from(event["device"])),
            event["status"] as int,
            event["newState"] as int,
          ),
        );
  }
  static KGatt _getInstance() {
    if (_instance == null) {
      _instance = new KGatt._internal();
    }
    return _instance!;
  }
}
