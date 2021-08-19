import 'package:k_ble_peripheral/src/util/uuid.dart';

import '../../k_ble_peripheral.dart';

class KAdvertising {
  final String id = uuid();
  KAdvertisingSetting setting;
  KAdvertisingData data = KAdvertisingData();
  KAdvertisingData scanResponseData = KAdvertisingData();
  bool isAdvertising = false;

  KAdvertising({required this.setting, KAdvertisingData? data, KAdvertisingData? scanResponseData}) {
    if (data != null) {
      this.data = data;
    }
    if (scanResponseData != null) {
      this.scanResponseData = scanResponseData;
    }
  }

  start() async {
    await AdvertisingHandler.start(this);
  }

  stop() async {
    await AdvertisingHandler.stop(this);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "Id": id,
      "AdvertiseSetting": setting.toMap(),
      "AdvertiseData": data.toMap(),
      "ScanResponseData": scanResponseData.toMap(),
    };
  }
}
