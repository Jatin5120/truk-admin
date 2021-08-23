import 'package:admin/constants.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/CancelledBookingModel.dart';
import 'package:flutter/material.dart';
class ViewCB extends StatelessWidget {
  ViewCB({
    required this.bm,
    required this.un,
    required this.an,
    required this.r
  });
  CancelledBookings bm;
  var an;
  var un;
  var r;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Booking ID: ${bm.id}"),
              Text("Cancelled Time: ${bm.time}"),
              Text("User: $un"),
              Text("Agent: $an"),
              Text("Refund To Be Done: $r")
            ],
          ),
        )
    );
  }
}
