import 'package:admin/constants.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/DriverModel.dart';
import 'package:flutter/material.dart';
class ViewDrivers extends StatelessWidget {
  ViewDrivers({
   required this.bm,
    required this.an,
});
  Drivers bm;
  var an;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${bm.Name}"),
              Text("Agent: $an"),
              Text("Mobile: ${bm.Mobile}"),
              // Text("Id: ${bm.Id}"),
              Text("DL: ${bm.DL}"),
              Text("Liscence Expiry Date: ${bm.LED}"),
              Text("Adhaar: ${bm.Aadhar}"),
              Text("Pan: ${bm.Pan}"),
            ],
          ),
        )
    );
  }
}
