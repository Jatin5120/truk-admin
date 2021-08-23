import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:http/http.dart' as http;

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  bool isLoading = true;
  List<Map<String, dynamic>> dataReport = [];
  int oCount = 0;
  var percentage;
  int bCount = 0;
  String s = "";
  int uCount = 0;
  getData() async {
    for (int i = 0; i < states.length; i++) {
      setState(() {
        oCount = 0;
        bCount = 0;
        uCount = 0;
        s = "Analyzing Data For State: ${states[i]}";
        percentage = (((i + 1) / states.length) * 100).toStringAsFixed(2);
      });
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var u in value.docs) {
          if (u['state'].toString().toLowerCase() == states[i].toLowerCase()) {
            setState(() {
              uCount += 1;
            });
          }
        }
      });
      await FirebaseFirestore.instance
          .collection('FleetOwners')
          .get()
          .then((values) {
        for (var v in values.docs) {
          if (v['state'].toString().toLowerCase() == states[i].toLowerCase()) {
            setState(() {
              oCount += 1;
            });
          }
        }
      });
      await FirebaseFirestore.instance
          .collection('Shipment')
          .get()
          .then((valuee) async {
        for (var w in valuee.docs) {
          http.Response response = await http.get(Uri.parse(
              "https://maps.googleapis.com/maps/api/geocode/json?latlng=${w['source'].toString().split(',')[0]},${w['source'].toString().split(',')[1]}&key=$kGoogleApiKey"));
          var data = jsonDecode(response.body);
          if (response.statusCode == 200) {
            for (var d in data['results']) {
              if (d['formatted_address']
                  .toString()
                  .toLowerCase()
                  .contains(states[i].toLowerCase())) {
                setState(() {
                  bCount += 1;
                });
                break;
              }
            }
          } else {
            print(response.statusCode);
          }
        }
      });
      setState(() {
        dataReport.add({
          'state': states[i],
          'users': uCount,
          'agents': oCount,
          'bookings': bCount
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            child: Column(
            children: [
              CircularProgressIndicator(),
              Text(
                  "Generating State Wise Analytics Report Please Wait ......\n$s\n $percentage % done")
            ],
          ))
        : Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "State Wise Analytics",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable2(
                    columnSpacing: defaultPadding,
                    minWidth: 600,
                    columns: [
                      DataColumn(
                        label: Text("State"),
                      ),
                      DataColumn(
                        label: Padding(
                          padding: const EdgeInsets.only(left: 50.0),
                          child: Text("Users"),
                        ),
                      ),
                      DataColumn(
                        label: Text("Truck Companies"),
                      ),
                      DataColumn(
                        label: Text("Bookings"),
                      ),
                    ],
                    rows: List.generate(
                      dataReport.length,
                      (index) => recentFileDataRow(dataReport[index]),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

DataRow recentFileDataRow(Map<String, dynamic> fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.deepOrange,
              child: Text(fileInfo['state'].toString()[0]),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Text(fileInfo['state']),
              ),
            ),
          ],
        ),
      ),
      DataCell(Padding(
        padding: const EdgeInsets.only(left: 50.0),
        child: Text("${fileInfo['users']}"),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text("${fileInfo['agents']}"),
      )),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text("${fileInfo['bookings']}"),
      )),
    ],
  );
}
