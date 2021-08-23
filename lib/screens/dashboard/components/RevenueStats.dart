import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'RevenueStats_card.dart';

class RevenueStats extends StatefulWidget {
  int cod;
  int totalR;
  int commision;
  RevenueStats({
   required this.commision,
   required this.cod,
   required this.totalR
});
  @override
  _RevenueStatsState createState() => _RevenueStatsState();
}

class _RevenueStatsState extends State<RevenueStats> {


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Revenue Stats",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          StorageInfoCard(
            svgSrc: "assets/icons/revenue.svg",
            title: "Total Revenue",
            amountOfFiles: "1.3GB",
            numOfFiles: widget.totalR,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/cash.svg",
            title: "Total COD",
            amountOfFiles: "15.3GB",
            numOfFiles: widget.cod,
          ),
          StorageInfoCard(
            svgSrc: "assets/icons/commission.svg",
            title: "Total Commission",
            amountOfFiles: "1.3GB",
            numOfFiles: widget.commision,
          ),
        ],
      ),
    );
  }
}

