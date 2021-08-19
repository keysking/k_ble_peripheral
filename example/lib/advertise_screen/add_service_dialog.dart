import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddServiceDialog extends StatefulWidget {
  final void Function(String uuid, List<int> data) onAdd;
  const AddServiceDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddServiceDialogState createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();

  final uuidTextController = TextEditingController();
  final dataTextController = TextEditingController();

  @override
  void initState() {
    uuidTextController.text = "0000ffff-0000-1000-8000-00805f9b34fb";
    dataTextController.text = "3132";
    super.initState();
  }

  String? validateUuid(String? uuid) {
    if (uuid == null) return 'Incorrect UUID';
    RegExp exp = RegExp(
        r'\b[0-9a-f]{8}\b-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-\b[0-9a-f]{12}\b');
    return exp.hasMatch(uuid) ? null : 'Incorrect UUID';
  }

  String? validateData(String? data) {
    if (data == null) return 'Incorrect Data';
    RegExp exp = RegExp(r'^[0-9a-f]*$');
    return exp.hasMatch(data) ? null : 'Incorrect Data';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: const BouncingScrollPhysics()),
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: uuidTextController,
                validator: validateUuid,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'UUID:',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: dataTextController,
                validator: validateData,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: 'Data:',
                    prefixText: '0x',
                    border: OutlineInputBorder()),
              ),
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
                    onPressed: (_formKey.currentState?.validate() ?? true)
                        ? () async {
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text("Add"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
