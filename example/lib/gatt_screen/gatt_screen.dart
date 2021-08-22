import 'dart:math';

import 'package:flutter/material.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';

class GattScreen extends StatelessWidget {
  GattScreen({Key? key}) : super(key: key) {
    KGatt().connectState.listen((event) {
      print("===================================");
      print(event.device);
      print("state:${event.status},new:${event.newState}");
    });
  }
  late KGattCharacteristic characteristic2;
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: const BouncingScrollPhysics(),
      ),
      padding: const EdgeInsets.all(8),
      children: [
        Text("Services List:", style: TextStyle(fontSize: 20)),
        ElevatedButton(
            onPressed: () {
              // 创建 characteristic
              final characteristic = KGattCharacteristic(
                  "0000fff1-0000-1000-8000-00805f9b34fb",
                  properties: KGattCharacteristic.PROPERTY_READ +
                      KGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE,
                  permissions: KGattCharacteristic.PERMISSION_READ +
                      KGattCharacteristic.PERMISSION_WRITE);

              characteristic.listenRead((device, requestId, offset) {
                print("有设备想read:$device ,$requestId,$offset");
                characteristic.sendResponse(device.address, requestId, offset,
                    [0x31, 0x30, 0x34, 0x3a]);
              });
              // 创建 characteristic
              characteristic2 = KGattCharacteristic(
                  "0000fff2-0000-1000-8000-00805f9b34fb",
                  properties: KGattCharacteristic.PROPERTY_READ +
                      KGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE +
                      KGattCharacteristic.PROPERTY_NOTIFY,
                  permissions: KGattCharacteristic.PERMISSION_READ +
                      KGattCharacteristic.PERMISSION_WRITE);

              characteristic2.listenRead((device, requestId, offset) {
                print("有设备想read2:$device ,$requestId,$offset");
                characteristic2.sendResponse(
                    device.address, requestId, offset, [0x31, 0x33]);
              });
              characteristic2.listenWrite(
                  (device, requestId, offset, preparedWrite, responseNeeded) {
                print("有设备想write2:$device ,$requestId,$offset");
              });
              characteristic2.listenNotificationState((device, enabled) {
                print("有设备${enabled ? '' : '取消'}订阅char2:${device.address}");
              });
              // 创建service
              final service = KGattService(
                "0000ffaf-0000-1000-8000-00805f9b34fb",
                characteristics: [characteristic, characteristic2],
              );
              service.activate();
            },
            child: Text("Add Service")),
        ElevatedButton(
            onPressed: () {
              final random = Random();
              final length = 3 + random.nextInt(10);
              final data = <int>[];
              for (int i = 0; i < length; i++) {
                data.add(0x30 + random.nextInt(10));
              }
              characteristic2.notify();
            },
            child: Text("Notify")),
      ],
    );
  }
}
