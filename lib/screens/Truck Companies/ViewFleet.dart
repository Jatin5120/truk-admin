import 'package:admin/constants.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:flutter/material.dart';

class ViewFleets extends StatelessWidget {
  const ViewFleets({
    required this.bm,
  });
  final FleetOwners bm;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      color: secondaryColor,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.deepOrange,
            backgroundImage: NetworkImage(bm.image),
          ),
          Text("Name: ${bm.name}"),
          Text("Email: ${bm.email}"),
          Text("Mobile: ${bm.mobile}"),
          Text("Id: ${bm.joining}"),
          Text("Company: ${bm.company}"),
          Text("Registration Number: ${bm.registration}"),
          Text("GST: ${bm.gst}"),
          Text("State: ${bm.state}"),
          Text("City: ${bm.city}"),
        ],
      ),
    ));
  }
}
