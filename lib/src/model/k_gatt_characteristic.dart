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
    KGattHandler.method.invokeMethod("char/create", toMap());
  }

  /// 监听读取characteristic值的请求
  StreamSubscription listenRead(
      void Function(KGattDevice device, int requestId, int offset) onRead) {
    return KGattHandler()
        .eventStream
        .where((event) =>
            event['event'] == 'CharacteristicReadRequest' &&
            event["entityId"] == entityId)
        .listen((event) {
      print(event);
      print(_entityId);
      final device = KGattDevice.fromMap(Map.from(event['device']));
      onRead(device, event['requestId'], event['offset']);
    });
  }

  /// 监听写characteristic值的请求
  StreamSubscription listenWrite(
      void Function(
    KGattDevice device,
    int requestId,
    int offset,
    bool preparedWrite,
    bool responseNeeded,
  )
          onWrite) {
    return KGattHandler()
        .eventStream
        .where((event) =>
            event['event'] == 'CharacteristicWriteRequest' &&
            event["entityId"] == entityId)
        .listen((event) {
      print(event);
      print(_entityId);
      final device = KGattDevice.fromMap(Map.from(event['device']));
      onWrite(
        device,
        event['requestId'],
        event['offset'],
        event['preparedWrite'],
        event['responseNeeded'],
      );
    });
  }

  /// 监听主机设备订阅或取消订阅Notification
  StreamSubscription listenNotificationState(
      void Function(KGattDevice device, bool enabled) onStateChange) {
    return KGattHandler()
        .eventStream
        .where((event) =>
            event['event'] == 'NotificationStateChange' &&
            event["entityId"] == entityId)
        .listen((event) {
      final device = KGattDevice.fromMap(Map.from(event['device']));
      onStateChange(device, event['enabled']);
    });
  }

  ///添加property
  addProperty(int property) {
    properties += property;
    KGattHandler.method.invokeMethod("char/setProperties", properties);
  }

  /// 添加permission
  addPermission(int permission) {
    permissions += permission;
    KGattHandler.method.invokeMethod("char/setPermissions", permissions);
  }

  /// 回复
  sendResponse(
      String deviceAddress, int requestId, int offset, List<int> value) async {
    await KGattHandler.method
        .invokeMapMethod("char/sendResponse", <String, dynamic>{
      "deviceAddress": deviceAddress,
      "requestId": requestId,
      "offset": offset,
      "value": value,
    });
  }

  /// 发送notify
  void notify() {}
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entityId': entityId,
      'uuid': uuid,
      'properties': properties,
      'permissions': permissions,
    };
  }
}
