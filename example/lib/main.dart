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
