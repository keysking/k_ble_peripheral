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
  final notifyList = <KGattDevice>[];
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
                if (enabled) {
                  notifyList.add(device);
                  print(notifyList.length);
                } else {
                  notifyList.removeWhere(
                      (element) => element.address == device.address);
                  print(notifyList.length);
                }
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
              notifyList.forEach((device) {
                characteristic2.notify(device.address, [
                  0x00,
                  0x01,
                  0x02,
                  0x03,
                  0x04,
                  0x05,
                  0x06,
                  0x07,
                  0x08,
                  0x09,
                  0x10,
                  0x11,
                  0x12,
                  0x13,
                  0x14,
                  0x15,
                  0x16,
                  0x17,
                  0x18,
                  0x19,
                  0x20,
                  0x21,
                  0x22,
                  0x23,
                  0x24,
                  0x25,
                  0x26,
                  0x27,
                  0x28,
                  0x29,
                  0x30,
                  0x31,
                  0x32,
                  0x33,
                  0x34,
                  0x35,
                  0x36,
                  0x37,
                  0x38,
                  0x39,
                  0x40,
                  0x41,
                  0x42,
                  0x43,
                  0x44,
                  0x45,
                  0x46,
                  0x47,
                  0x48,
                  0x49,
                  0x50,
                  0x51,
                  0x52,
                  0x53,
                  0x54,
                  0x55,
                  0x56,
                  0x57,
                  0x58,
                  0x59,
                  0x60,
                  0x61,
                  0x62,
                  0x63,
                  0x64,
                  0x65,
                  0x66,
                  0x67,
                  0x68,
                  0x69,
                  0x70,
                  0x71,
                  0x72,
                  0x73,
                  0x74,
                  0x75,
                  0x76,
                  0x77,
                  0x78,
                  0x79,
                  0x80,
                  0x81,
                  0x82,
                  0x83,
                  0x84,
                  0x85,
                  0x86,
                  0x87,
                  0x88,
                  0x89,
                  0x90,
                  0x91,
                  0x92,
                  0x93,
                  0x94,
                  0x95,
                  0x96,
                  0x97,
                  0x98,
                  0x99,
                  0xa0,
                  0xa1,
                  0xa2,
                  0xa3,
                  0xa4,
                  0xa5,
                  0xa6,
                  0xa7,
                  0xa8,
                  0xa9,
                ]);
              });
            },
            child: Text("Notify")),
      ],
    );
  }
}
