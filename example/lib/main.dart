import 'package:flutter/material.dart';
import 'package:k_ble_peripheral_example/advertise_screen/advertise_screen.dart';
import 'package:k_ble_peripheral_example/gatt_screen/gatt_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pages = [AdvertiseScreen(), GattScreen()];
  var currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example for k_ble_peripheral'),
        ),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.online_prediction),
              label: 'Advertice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_remote),
              label: 'GATT Service',
            ),
          ],
        ),
      ),
    );
  }
}


// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final ble = KBlePeripheral();
//   var advertiseIds = <String>[];
//
//   @override
//   void initState() {
//     super.initState();
//     ble.advertiseSetting.connectable = true;
//     ble.advertiseSetting.name = "kkk111";
//     ble.advertiseSetting.advertiseMode =
//         KAdvertiseSetting.ADVERTISE_MODE_BALANCED;
//     ble.advertiseData.addManufacturer(0x0A8F, [0x31, 0x32]);
//     ble.advertiseData
//         .addServiceData("0000ffff-0000-1000-8000-00805f9b34fb", [0x34, 0x35]);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               TextField(
//                 onChanged: (value){
//                   setState(() {
//                     ble.advertiseSetting.name = value;
//                   });
//                 },
//                 decoration: InputDecoration(labelText: 'Advertisement name:'),
//               ),
//               ElevatedButton(
//                 onPressed: () async {
//                   final id = await ble.startAdvertising();
//                   setState(() {
//                     advertiseIds.add(id);
//                   });
//                 },
//                 child: Text("start"),
//               ),
//               ...advertiseIds.map(
//                 (id) => ElevatedButton(
//                   onPressed: () async {
//                     await ble.stopAdvertising(id);
//                     setState(() {
//                       advertiseIds.remove(id);
//                     });
//                   },
//                   child: Text("stop advertising($id)"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
