import 'package:admin/models/DriverModel.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Drivers/DriverReports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'DriverHeader.dart';

class DriverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            DriverHeader(),
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
                            .collection("RegisteredDriver")
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(
                                child: CircularProgressIndicator());
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<Drivers> bm = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            Drivers driver= Drivers(
                                sN: i+1,
                                Aadhar: docs.docs[i]['adhaar'],
                                Agent: docs.docs[i]['agent'],
                                DL: docs.docs[i]['dl'],
                                LED: docs.docs[i]['licenseExpiryDate'],
                                Mobile: docs.docs[i]['mobile'],
                                Name: docs.docs[i]['name'],
                                Pan: docs.docs[i]['pan']
                            );
                            bm.add(driver);
                          }
                          return DriverReport(bm: bm);
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
