import 'package:admin/models/DriverModel.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/Drivers/DriverReports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'MarketingFinal.dart';
import 'MarkettingHeader.dart';

class MarketingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            MarketingHeader(),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      MarketingFinal(),
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
