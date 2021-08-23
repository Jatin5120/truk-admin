import 'package:admin/constants.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/DriverModel.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:admin/models/truck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
class ViewTruck extends StatelessWidget {
  ViewTruck({
   required this.bm,
});
  Truck bm;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${bm.trukName}"),
              Text("Type: ${bm.trukType}"),
              Text("Number: ${bm.truknumber}"),
              Text("Height: ${bm.height}"),
              Text("Width: ${bm.breadth}"),
              Text("length: ${bm.length}"),
              Text("Gross Weight: ${bm.grossWeight}"),
              Text("Pan Tin: ${bm.panTin}"),
              Text("Permit Type: ${bm.permitType}"),
              Text("Owner: ${bm.ownerName}"),
              Text("Driver: ${bm.driver}"),
              Text("Contact: ${bm.mobileNumber}"),
            ],
          ),
        )
    );
  }
}
