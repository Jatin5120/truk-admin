import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';

class AddTruck extends StatefulWidget {
  const AddTruck({Key? key}) : super(key: key);

  @override
  _AddTruckState createState() => _AddTruckState();
}

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class _AddTruckState extends State<AddTruck> {
  TextEditingController owner = new TextEditingController();
  TextEditingController _no = new TextEditingController();
  TextEditingController _pan = new TextEditingController();
  TextEditingController _model = new TextEditingController();
  TextEditingController _weight = new TextEditingController();
  TextEditingController _truktype = new TextEditingController();
  TextEditingController _length = new TextEditingController();
  TextEditingController _breadth = new TextEditingController();
  TextEditingController _height = new TextEditingController();
  TextEditingController _trukno = new TextEditingController();
  TextEditingController _permit = new TextEditingController();

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 250,
                    height: 100,
                    child: TextFormField(
                      controller: owner,
                      enabled: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write your Name',
                        labelText: 'Truck Owner Name',
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
                          hintText: 'Write your Mobile Number',
                          labelText: 'Mobile Number',
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
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _pan,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Write your PAN',
                          labelText: 'PAN / TIN',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: PopupMenuButton(
                        onSelected: (result) {
                          setState(() {
                            _model.text = result.toString();
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Single Axle"),
                            value: 'Single Axle',
                          ),
                          PopupMenuItem(
                            child: Text("Double Axle"),
                            value: 'Double Axle',
                          ),
                          PopupMenuItem(
                            child: Text('Triple Axle'),
                            value: 'Triple Axle',
                          ),
                          PopupMenuItem(
                            child: Text('Multi Axle'),
                            value: 'Multi Axle',
                          ),
                        ],
                        child: TextFormField(
                          controller: _model,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Truck Model',
                          ),
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
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _weight,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Weight',
                          labelText: 'Gross Weight(Tons)',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 250,
                      height: 100,
                      child: PopupMenuButton(
                        onSelected: (result) {
                          setState(() {
                            _truktype.text = result.toString();
                          });
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Text("Closed Truck"),
                            value: 'Closed Truck',
                          ),
                          PopupMenuItem(
                            child: Text("Open Truck"),
                            value: 'Open Truck',
                          ),
                        ],
                        child: TextFormField(
                          controller: _truktype,
                          enabled: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Truck Type',
                          ),
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
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _length,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Truck Length',
                          labelText: 'Length(in feet)',
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
                        controller: _breadth,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Breadth',
                          labelText: 'Breadth(in feet)',
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
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _height,
                        enabled: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Truck Height',
                          labelText: 'Height(in feet)',
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
                        controller: _trukno,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Vehicle Number',
                          labelText: 'Truck Number',
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
                      width: 250,
                      height: 100,
                      child: TextFormField(
                        controller: _permit,
                        enabled: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Permit Type',
                          labelText: 'Permit Type',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection("Truks")
                .doc(_trukno.text)
                .set({
              'available': false,
              'driver': '',
              'ownerId': '',
              'ownerName': owner.text,
              'mobileNumber': _no.text,
              'panTin': _pan.text,
              'trukType': _truktype.text,
              'grossWeight': _weight.text,
              'trukName': _model.text,
              'length': _length.text,
              "breadth": _breadth.text,
              "height": _height.text,
              "trukNumber": _trukno.text,
              "permitType": _permit.text,
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
