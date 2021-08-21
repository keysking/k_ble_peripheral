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
                      KGattCharacteristic.PROPERTY_WRITE_NO_RESPONSE);
              // 创建service
              final service = KGattService(
                "0000ffaf-0000-1000-8000-00805f9b34fb",
                characteristics: [characteristic],
              );
              service.activate();
            },
            child: Text("Add Service")),
      ],
    );
  }
}
