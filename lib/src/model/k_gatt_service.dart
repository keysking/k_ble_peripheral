import 'package:k_ble_peripheral/src/model/k_gatt_characteristic.dart';

class KGattService {
  static const int SERVICE_TYPE_PRIMARY = 0;
  static const int SERVICE_TYPE_SECONDARY = 1;
  String uuid;
  int serviceType = SERVICE_TYPE_PRIMARY;
  List<KGattCharacteristic> characteristics = [];

  KGattService(this.uuid);

  addCharacteristic(KGattCharacteristic characteristic) {
    characteristics.add(characteristic);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uuid': uuid,
      'type': serviceType,
      'characteristics': characteristics.map((e) => e.toMap()).toList()
    };
  }
}
