import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreateFleet extends StatefulWidget {
  // CreateFleet({});
  @override
  _CreateFleetState createState() => _CreateFleetState();
}

class _CreateFleetState extends State<CreateFleet> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _upi = new TextEditingController();
  TextEditingController _company = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondaryColor,
      content: SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
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
                      width: 200,
                      height: 100,
                      child: TextFormField(
                        controller: _email,
                        enabled: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Email ID',
                          labelText: 'Email ID',
                        ),
                      ),
                    ),
                  ),
                ]),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 100,
                        child: TextFormField(
                          controller: _upi,
                          enabled: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "UPI",
                            labelText: 'UPI',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 100,
                        child: TextFormField(
                          controller: _company,
                          enabled: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Company",
                            labelText: 'Company',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 100,
                        child: TextFormField(
                          controller: _city,
                          enabled: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "City",
                            labelText: 'City',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 200,
                        height: 100,
                        child: TextFormField(
                          controller: _state,
                          enabled: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "State",
                            labelText: 'State',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    height: 100,
                    child: TextFormField(
                      controller: _phone,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Phone",
                        labelText: 'phone',
                      ),
                    ),
                  ),
                ),
              ]),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance.collection("FleetOwners").doc().set({
              "city": _city.text,
              "email": _email.text,
              'company': _company.text,
              "gst": "",
              "image": "",
              "joining": "",
              "mobile": _phone.text,
              "name": _name.text,
              'notification': false,
              "regNumber": "",
              "state": _state.text,
              "token": "",
              "uid": "",
              'upiId': _upi.text,
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
          child: TextButton(
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
