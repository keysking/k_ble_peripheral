import 'package:flutter/material.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ble = KBlePeripheral();
  var advertiseIds = <String>[];

  @override
  void initState() {
    super.initState();
    ble.advertiseSetting.connectable = true;
    ble.advertiseSetting.name = "kkk111";
    ble.advertiseSetting.advertiseMode =
        KAdvertiseSetting.ADVERTISE_MODE_BALANCED;
    ble.advertiseData.addManufacturer(0x0A8F, [0x31, 0x32]);
    ble.advertiseData
        .addServiceData("0000ffff-0000-1000-8000-00805f9b34fb", [0x34, 0x35]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Advertisement name:'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final id = await ble.startAdvertising();
                  setState(() {
                    advertiseIds.add(id);
                  });
                },
                child: Text("start"),
              ),
              ...advertiseIds.map(
                (id) => ElevatedButton(
                  onPressed: () async {
                    await ble.stopAdvertising(id);
                    setState(() {
                      advertiseIds.remove(id);
                    });
                  },
                  child: Text("stop advertising($id)"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
