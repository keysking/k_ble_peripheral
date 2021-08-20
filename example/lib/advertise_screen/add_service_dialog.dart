import 'package:flutter/material.dart';

class AddServiceDialog extends StatefulWidget {
  final void Function(String uuid, List<int>? data) onAdd;
  const AddServiceDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddServiceDialogState createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();

  final uuidTextController = TextEditingController();
  final dataTextController = TextEditingController();
  var noData = false;
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
    RegExp exp = RegExp(r'^([0-9a-f]{2})*$');
    return exp.hasMatch(data) ? null : 'Incorrect Data';
  }

  List<int> dataToList(String data) {
    final list = <int>[];
    for (int i = 0; i <= data.length - 2; i += 2) {
      final hex = data.substring(i, i + 2);
      final number = int.parse(hex, radix: 16);
      list.add(number);
    }
    return list;
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
              if (!noData)
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("No Data:"),
                  Checkbox(
                      value: noData,
                      onChanged: (value) {
                        setState(() {
                          noData = value ?? false;
                        });
                      }),
                ],
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
                            widget.onAdd(
                                uuidTextController.text,
                                noData
                                    ? null
                                    : dataToList(dataTextController.text));
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
