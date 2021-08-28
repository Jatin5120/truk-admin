import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Wrap(
          children: [
            Text(
                "TruKApp is a revolutionary application connecting shippers to the Live Truck Market and enabling hassle free cargo shipment booking across the country. We also provide various other services like Truck Load Identification, fleet management services etc. to Transporters through our cutting edge technologies.\n\n"
                "It was founded in January 2021 by a group of passionate entrepreneurs from the NIT Warangal Almamater.\n\n"
                "TrukApp is here to simplify logistics right from Intercity to Intracity transportation, Full Truck Load to Partial Truck Load deliveries, Identifying Truck Space for any type of cargo and a fleet management interface to transporters to name a few.\n\n"
                "With the help of Technology, TrukApp provides world class support from the beginning to the end of the cargo delivery life cycle. Our Technologies like real-time cargo tracking, freight security, fleet management, Integrated Payment Gateway etc. enable both Shippers and Transporters to transact on their fingertips.\n\n"),
            Text("This is who we are, TrukApp - Logistics Simplified!"),
          ],
        ),
      ),
    );
  }
}
