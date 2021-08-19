import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_ble_peripheral/k_ble_peripheral.dart';

import 'add_service_dialog.dart';

class NewAdvertiseDialog extends StatefulWidget {
  const NewAdvertiseDialog({Key? key}) : super(key: key);

  @override
  _NewAdvertiseDialogState createState() => _NewAdvertiseDialogState();
}

class _NewAdvertiseDialogState extends State<NewAdvertiseDialog> {
  var name = "k";
  final nameTextFieldController = TextEditingController();
  final timeoutTextFieldController = TextEditingController();
  final Map<String, List<int>?> services = Map();
  var connentable = true;

  @override
  void initState() {
    nameTextFieldController.text = 'K';
    timeoutTextFieldController.text = '0';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: const BouncingScrollPhysics()),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("New advertise info :"),
            TextField(
              controller: nameTextFieldController,
              decoration: InputDecoration(labelText: 'Name:'),
            ),
            TextField(
              controller: timeoutTextFieldController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  labelText: 'Timeout:',
                  hintText: 'Unit:ms  Empty or 0 means no timeout'),
            ),
            Row(
              children: [
                Text("connectable:"),
                Switch(
                  value: connentable,
                  onChanged: (value) {
                    setState(() {
                      connentable = value;
                    });
                  },
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: AddServiceDialog(
                      onAdd: (uuid, data) {
                        // TODO 添加service
                      },
                    ),
                  ),
                );
              },
              child: Text("Add Service"),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red)),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final advertisingSetting = KAdvertisingSetting(
                        name: nameTextFieldController.text,
                        connectable: connentable,
                        timeout: timeoutTextFieldController.text.isEmpty
                            ? 0
                            : int.parse(timeoutTextFieldController.text),
                      );
                      final advertisingData = KAdvertisingData();
                      advertisingData.addServiceData(
                          "0000ffff-0000-1000-8000-00805f9b34fb", [0x31, 0x32]);
                      final advertising = KAdvertising(
                          setting: advertisingSetting, data: advertisingData);
                      await advertising.start();
                      Navigator.pop(context);
                    },
                    child: Text("Advertise")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
