import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/Statics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/report.dart';
import 'components/RevenueStats.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  @override
  void setState(fn) {
    if(mounted) {
      super.setState(fn);
    }
  }

  int cod = 0;
  int totalR = 0;
  int commission = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      StaticsM(),
                      SizedBox(height: defaultPadding),
                      Report(),
                      SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) ...[
                        SizedBox(height: defaultPadding),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Shipment")
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return Center(child: CircularProgressIndicator());
                            }
                            QuerySnapshot docs = snapshot.data;
                            for (int i = 0; i < docs.docs.length; i++) {
                              ///GET DATA HERE
                              if (docs.docs[i]['paymentStatus'] == 'COD') {
                                cod += int.parse(docs.docs[i]['price']);
                              }
                              totalR += int.parse(docs.docs[i]['price']);
                            }
                            return RevenueStats(
                              commission: commission,
                              cod: cod,
                              totalR: totalR,
                            );
                          },
                        ),
                      ]
                    ],
                  ),
                ),
                // On Mobile means if the screen is less than 850 we don't want to show it
                if (!Responsive.isMobile(context)) ...[
                  SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 2,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Shipment")
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data == null) {
                          return Center(child: CircularProgressIndicator());
                        }
                        QuerySnapshot docs = snapshot.data;
                        for (int i = 0; i < docs.docs.length; i++) {
                          ///GET DATA HERE
                          if (docs.docs[i]['paymentStatus'] == 'COD') {
                            cod += int.parse(docs.docs[i]['price']);
                          }
                          totalR += int.parse(docs.docs[i]['price']);
                        }
                        return RevenueStats(
                          commission: commission,
                          cod: cod,
                          totalR: totalR,
                        );
                      },
                    ),
                  ),
                ],
              ],
            )
          ],
        ),
      ),
    );
  }
}
