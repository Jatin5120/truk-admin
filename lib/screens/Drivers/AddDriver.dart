import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../../constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({Key? key}) : super(key: key);

  @override
  _AddDriverState createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _no = new TextEditingController();
  TextEditingController _pan = new TextEditingController();
  TextEditingController _hvc = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  var _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      content: SingleChildScrollView(
        // key: _formKey,
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _name,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                          labelText: 'Name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _no,
                        enabled: true,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Phone Number',
                          labelText: 'Phone Number',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _pan,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Aadhar Number / PAN',
                          labelText: 'Aadhar Number / PAN',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _hvc,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'License Number (HVC)',
                          labelText: 'License Number (HVC)',
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: Form(
                        key: _formkey,
                        child: InkWell(
                          onTap: () {
                            showMonthPicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 1, 5),
                              lastDate: DateTime(DateTime.now().year + 20, 9),
                              initialDate: DateTime.now(),
                              locale: Locale("en"),
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  _date.text =
                                      "${date.month}/${date.year.toString().split("")[2]}${date.year.toString().split("")[3]}";
                                });
                              }
                            });
                          },
                          child: TextFormField(
                            controller: _date,
                            enabled: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'dd-mm-yyyy',
                              labelText: 'License Expiry Date',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection("RegisteredDriver")
                .doc()
                .set({
              "adhaar": _pan.text,
              "agent": "",
              'cstatus': true,
              "dl": _hvc.text,
              "id": "",
              "licenseExpiryDate": _date.text,
              "mobile": _no.text,
              "name": _name.text,
              "pan": _pan.text
            }).catchError((e) {
              print(e);
            }).then((value) => {
                      print("success"),
                      Navigator.pop(context),
                    });
          },
          child: Text("Upload"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
        ),
      ],
    );
  }
}

  // class Task {
  // String name;
  // DateTime date;
  //
  // Task({this.name, this.date});
  // }

