import 'package:admin/models/BookingModels.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Bookings/BookingReports.dart';
import 'package:admin/screens/dashboard/components/header.dart';
import 'package:admin/screens/dashboard/components/Statics.dart';
import 'package:admin/screens/dashboard/components/RevenueStats.dart';
import 'package:admin/screens/dashboard/components/report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import 'BookingHeader.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            BookingHeader(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Shipment").orderBy('bookingId',descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator());
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<BookingModel> bm = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            List<String> stringCor = docs.docs[i]['destination'].toString().split(",");
                            List<String>sourceCor=docs.docs[i]['source'].toString().split(',');

                            BookingModel booking= BookingModel(
                                bookingDate: DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(docs.docs[i]['bookingDate'])),
                                user: docs.docs[i]['uid'],
                                destination: docs.docs[i]['destination'],
                                source: docs.docs[i]['source'],
                                status: docs.docs[i]['status'],
                                driver: docs.docs[i]['driver'],
                                contact: docs.docs[i]['mobile'],
                                price: docs.docs[i]['price'],
                                agent: docs.docs[i]['agent'],
                                bookingId: docs.docs[i]['bookingId'],
                                ewayBill: docs.docs[i]['ewaybill'],
                                insured: docs.docs[i]['insured'],
                                load: docs.docs[i]['load'],
                                mandate: docs.docs[i]['mandate'],
                                material: docs.docs[i]['materials'],
                                payType: docs.docs[i]['paymentStatus'],
                                pickupDate: docs.docs[i]['pickupDate'],
                                truckName: docs.docs[i]['trukName'],
                                truckNumber: docs.docs[i]['truk']);
                            bm.add(booking);
                          }
                          return BookingReport(bm: bm);
                        },
                      ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      //if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                //if (!Responsive.isMobile(context))
                  // Expanded(
                  //   flex: 2,
                  //   child: StarageDetails(),
                  // ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
