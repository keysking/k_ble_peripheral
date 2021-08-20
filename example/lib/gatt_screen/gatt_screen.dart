import 'package:flutter/material.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';

class GattScreen extends StatelessWidget {
  GattScreen({Key? key}) : super(key: key) {
    KGattHandler().connectState.listen((event) {
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
              final service =
                  KGattService("0000ffaf-0000-1000-8000-00805f9b34fb");
              final characteristic =
                  KGattCharacteristic("0000fff1-0000-1000-8000-00805f9b34fb");
              characteristic.addProperty(KGattCharacteristic.PROPERTY_READ);
              service.addCharacteristic(characteristic);
              KGattHandler().addService(service);
            },
            child: Text("Add Service")),
      ],
    );
  }
}
