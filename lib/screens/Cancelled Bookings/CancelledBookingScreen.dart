import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/CancelledBookingModel.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Bookings/BookingReports.dart';
import 'package:admin/screens/Cancelled%20Bookings/CBHeader.dart';
import 'package:admin/screens/Cancelled%20Bookings/CBReport.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class CBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CBHeader(),
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
                            .collection("CancelledBooking").orderBy('bookingId',descending: true)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator());
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<CancelledBookings> bm = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            CancelledBookings booking= CancelledBookings(
                                agent: docs.docs[i]['agent'],
                                user: docs.docs[i]['uid'],
                                id: docs.docs[i]['bookingId'],
                                time: DateFormat('dd/MM/yyyy, hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(docs.docs[i]['time'])),
                                amount: docs.docs[i]['amount'],
                                cBy: docs.docs[i]['cancelledby'],
                                reason: docs.docs[i]['reason']
                            );
                            bm.add(booking);
                          }
                          return CBReport(bm: bm);
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
