import 'package:admin/models/FleetModel.dart';
import 'package:admin/models/truck.dart';
import 'package:admin/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'TruckHeader.dart';
import 'TruckReports.dart';

class TruckScreen extends StatelessWidget {
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
                            .collection("Truks")
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Center(child: CircularProgressIndicator());
                          }
                          QuerySnapshot docs = snapshot.data;
                          List<Truck> bm = [];
                          for (int i = 0; i < docs.docs.length; i++) {
                            print(docs.docs[i]['driver']);
                            print(docs.docs[i]['length']);
                            print(docs.docs[i]['height']);
                            print(docs.docs[i]['breadth']);
                            print(docs.docs[i]['grossWeight']);
                            print(docs.docs[i]['mobileNumber']);
                            print(docs.docs[i]['ownerId']);
                            print(docs.docs[i]['ownerName']);
                            print(docs.docs[i]['panTin']);
                            print(docs.docs[i]['permitType']);
                            print(docs.docs[i]['trukName']);
                            print(docs.docs[i]['trukNumber']);
                            print(docs.docs[i]['trukType']);
                            Truck truck = Truck(
                                sNo: i + 1,
                                driver: docs.docs[i]['driver'],
                                length: docs.docs[i]['length'],
                                height: docs.docs[i]['height'],
                                breadth: docs.docs[i]['breadth'],
                                grossWeight: docs.docs[i]['grossWeight'],
                                mobileNumber: docs.docs[i]['mobileNumber'],
                                ownerId: docs.docs[i]['ownerId'],
                                ownerName: docs.docs[i]['ownerName'],
                                panTin: docs.docs[i]['panTin'],
                                permitType: docs.docs[i]['permitType'],
                                trukName: docs.docs[i]['trukName'],
                                truknumber: docs.docs[i]['trukNumber'],
                                trukType: docs.docs[i]['trukType']);
                            bm.add(truck);
                          }
                          return TruckReport(bm: bm);
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
