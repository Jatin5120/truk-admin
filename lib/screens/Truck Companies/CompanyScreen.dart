import 'package:admin/models/DriverModel.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Drivers/DriverReports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'CompanyHeader.dart';
import 'CompanyReports.dart';

class CompanyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            CompanyHeader(),
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
                            .collection("FleetOwners").orderBy('joining')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator());
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<FleetOwners> bm = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            FleetOwners owner= FleetOwners(
                              sNo: i+1,
                                name: docs.docs[i]['name'],
                                image: docs.docs[i]['image'],
                                email: docs.docs[i]['email'],
                                token: docs.docs[i]['token'],
                                uid: docs.docs[i]['uid'],
                                city: docs.docs[i]['city'],
                                state: docs.docs[i]['state'],
                                company: docs.docs[i]['company'],
                                gst: docs.docs[i]['gst'],
                                joining: docs.docs[i]['joining'],
                                mobile: docs.docs[i]['mobile'],
                                registration: docs.docs[i]['regNumber']
                            );
                            bm.add(owner);
                          }
                          return CompanyReport(bm: bm);
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
