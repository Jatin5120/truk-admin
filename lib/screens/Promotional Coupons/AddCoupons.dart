import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Coupons extends StatefulWidget {
  const Coupons({Key? key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  TextEditingController _code = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _discount = new TextEditingController();
  TextEditingController _expiry = new TextEditingController();
  TextEditingController _min = new TextEditingController();

  TextEditingController _max = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _pincode = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _code,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type the code',
                      labelText: 'Code',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  color: secondaryColor,
                  child: TextFormField(
                    controller: _description,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Describe the coupon',
                      labelText: 'Description',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _discount,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type the minimum Discount %',
                      labelText: 'Discount Percent',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _expiry,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select the Date',
                      labelText: 'Expiry Date',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _min,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Minimum Amount',
                      labelText: 'Minimum Amount',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _max,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Maximum Amount',
                      labelText: 'Maximum Amount',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _name,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Your Name',
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                child: Container(
                  width: 500,
                  height: 100,
                  child: TextFormField(
                    controller: _pincode,
                    enabled: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter PIN CODE',
                      labelText: 'Pin Code',
                    ),
                  ),
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              int discount = int.parse(_discount.text);
              int min = int.parse(_min.text);
              int max = int.parse(_max.text);
              int expiry = int.parse(_expiry.text);
              String str = _pincode.text;
              List<String> lstring = str.split(',');
              Iterable<int> pincodeList = lstring.map(int.parse);
              FirebaseFirestore.instance.collection("Coupons").doc().set({
                "code": _code.text,
                "description": _description.text,
                "discountPercent": discount,
                "expiry": expiry,
                "min": min,
                "max": max,
                "name": _name.text,
                "pincode": pincodeList,
              }).catchError((e) {
                print(e);
              }).then(
                (value) => {
                  print("success"),
                  _code.clear(),
                  _discount.clear(),
                  _description.clear(),
                  _expiry.clear(),
                  _max.clear(),
                  _min.clear(),
                  _name.clear(),
                  _pincode.clear(),
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text("Upload"),
            ),
          ),
        ],
      ),
    );
  }
}
