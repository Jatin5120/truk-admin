import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';

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
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
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
              Container(
                width: double.infinity,
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
              )
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
                  height: 100,
                  child: TextFormField(
                    controller: _expiry,
                    enabled: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select the Date',
                      labelText: 'Expiry Date',
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
                  width: 200,
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 200,
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
        ],
      ),
    );
  }
}

