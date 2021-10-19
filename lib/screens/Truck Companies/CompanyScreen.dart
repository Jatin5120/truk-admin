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
                            .collection("FleetOwners")
                            .orderBy('joining')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<FleetOwners> fleetOwners = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            FleetOwners owner =
                                FleetOwners.fromMap(docs.docs[i].data());
                            owner.sNo = i + 1;
                            fleetOwners.add(owner);
                          }
                          return CompanyReport(fleetOwners: fleetOwners);
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
            ),
          ],
        ),
      ),
    );
  }
}
