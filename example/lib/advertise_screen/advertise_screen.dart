import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';

import 'new_advertise_dialog.dart';

class AdvertiseScreen extends StatefulWidget {
  const AdvertiseScreen({Key? key}) : super(key: key);

  @override
  _AdvertiseScreenState createState() => _AdvertiseScreenState();
}

class _AdvertiseScreenState extends State<AdvertiseScreen> {
  final List<String> advertises = ["KKK"];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.all(8),
      children: [
        Text("Advertising List:", style: TextStyle(fontSize: 20)),
        ...advertises.map(
          (e) => Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e, style: TextStyle(fontSize: 20)), // name
                  ],
                ),
              ),
            ),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        child: NewAdvertiseDialog(),
                      ));
            },
            child: Text("New Advertise"))
      ],
    );
  }
}
