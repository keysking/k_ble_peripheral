import 'package:k_ble_peripheral/src/handler/k_gatt_handler.dart';
import 'package:k_ble_peripheral/src/model/k_gatt_characteristic.dart';
import 'package:k_ble_peripheral/src/util/uuid.dart';

class KGattService {
  static const int SERVICE_TYPE_PRIMARY = 0;
  static const int SERVICE_TYPE_SECONDARY = 1;
  String _entityId = randomId();
  String get entityId => _entityId;
  String uuid;
  int serviceType = SERVICE_TYPE_PRIMARY;
  List<KGattCharacteristic> characteristics = [];

  KGattService(
    this.uuid, {
    this.serviceType = SERVICE_TYPE_PRIMARY,
    List<KGattCharacteristic>? characteristics,
  }) {
    if (characteristics != null) {
      this.characteristics.addAll(characteristics);
    }
    // 创建service
    KGattHandler.method.invokeMethod("service/create", toMap());
  }

  addCharacteristic(KGattCharacteristic characteristic) async {
    await KGattHandler.method.invokeListMethod(
      "service/addCharacteristic",
      characteristic.entityId,
    );
    characteristics.add(characteristic);
  }

  activate() async {
    await KGattHandler.method.invokeMethod("service/activate", entityId);
  }

  inactivate() async {
    await KGattHandler.method.invokeMethod("service/inactivate", entityId);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'entityId': entityId,
      'uuid': uuid,
      'type': serviceType,
      'characteristics': characteristics.map((e) => e.toMap()).toList()
    };
  }
}
