import 'dart:async';

import 'package:k_ble_peripheral/src/handler/k_gatt_handler.dart';
import 'package:k_ble_peripheral/src/util/uuid.dart';

import 'k_gatt_device.dart';

class KGattCharacteristic {
  static const int PROPERTY_BROADCAST = 0x01;
  static const int PROPERTY_READ = 0x02;
  static const int PROPERTY_WRITE_NO_RESPONSE = 0x04;
  static const int PROPERTY_WRITE = 0x08;
  static const int PROPERTY_NOTIFY = 0x10;
  static const int PROPERTY_INDICATE = 0x20;
  static const int PROPERTY_SIGNED_WRITE = 0x40;
  static const int PROPERTY_EXTENDED_PROPS = 0x80;

  static const int PERMISSION_READ = 0x01;
  static const int PERMISSION_READ_ENCRYPTED = 0x02;
  static const int PERMISSION_READ_ENCRYPTED_MITM = 0x04;
  static const int PERMISSION_WRITE = 0x10;
  static const int PERMISSION_WRITE_ENCRYPTED = 0x20;
  static const int PERMISSION_WRITE_ENCRYPTED_MITM = 0x40;
  static const int PERMISSION_WRITE_SIGNED = 0x80;
  static const int PERMISSION_WRITE_SIGNED_MITM = 0x100;

  String _entityId = randomId();
  String get entityId => _entityId;
  String uuid;
  int properties = 0;
  int permissions = 0;
  // late final Stream<String> onRead; // TODO not String
  KGattCharacteristic(this.uuid, {this.properties = 0, this.permissions = 0}) {
    KGattHandler.method.invokeMethod("char/create", toMap()).then((value) {
      print("char创建完成");
    });
    // onRead = KGattHandler.charReadEvent
    //     .receiveBroadcastStream()
    //     .where((event) => false)
    //     .map((event) => "TODO,修改条件和信息");
  }

  StreamSubscription listenRead(
      void Function(KGattDevice device, String requestId, int offset) onRead) {
    return KGattHandler()
        .eventStream
        .where((event) =>
            event['event'] == 'CharacteristicReadRequest' &&
            event["entityId"] == entityId)
        .listen((event) {
      final device = KGattDevice.fromMap(event['device']);
      onRead(device, event['requestId'], event['offset']);
    });
  }

  addProperty(int property) {
    properties += property;
    KGattHandler.method.invokeMethod("char/setProperties", properties);
  }

  addPermission(int permission) {
    permissions += permission;
    KGattHandler.method.invokeMethod("char/setPermissions", permissions);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entityId': entityId,
      'uuid': uuid,
      'properties': properties,
      'permissions': permissions,
    };
  }
}
