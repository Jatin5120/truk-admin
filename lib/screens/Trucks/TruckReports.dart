import 'dart:convert';

import 'package:admin/Helper/DownloadHelper.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/CancelledBookingModel.dart';
import 'package:admin/models/DriverModel.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:admin/models/truck.dart';
import 'package:admin/screens/Bookings/ViewBooking.dart';
import 'package:admin/screens/Drivers/ViewDrivers.dart';
import 'package:admin/screens/Truck%20Companies/ViewFleet.dart';
import 'package:admin/screens/Trucks/AddTruck.dart';
import 'package:admin/screens/Trucks/ViewTruck.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import '../../responsive.dart';

class TruckReport extends StatefulWidget {
  List<Truck> bm = [];
  TruckReport({required this.bm});
  @override
  _TruckReportState createState() => _TruckReportState();
}

class _TruckReportState extends State<TruckReport> {
  List<String> an = [];
  bool isLoading = true;
  int totalPages = 0;
  int totalBookings = 0;
  List<int> pages = [];
  int currPage = 1;
  var percentage;
  int iCount = 5;
  AddTruck _addTruckControllers = AddTruck();
  getData() async {
    setState(() {
      totalBookings = widget.bm.length;
      String s =
          "${((totalBookings / iCount) * iCount == totalBookings ? (totalBookings / iCount) : (totalBookings / iCount) + 1)}";
      int p = int.parse(s.split(".")[0]);
      totalPages = p * iCount == totalBookings ? p : p + 1;
    });
    for (int i = 0; i < widget.bm.length; i++) {
      setState(() {
        pages.add(i + 1);
        percentage = (((i + 1) / widget.bm.length) * 100).toStringAsFixed(2);
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
              Text("Fetching Data Please Wait ......\n $percentage % done")
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Trucks",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    ElevatedButton.icon(
                        onPressed: () {
                          Download().downloadTrucks(context, widget.bm);
                        },
                        icon: Icon(Icons.download),
                        label: Text("Download")),
                    ElevatedButton.icon(
                        onPressed: () {
                          Responsive.isDesktop(context)
                              ? showDialog(
                                  context: context,
                                  builder: (BuildContext context) => AddTruck(),
                                )
                              : Navigator.of(context)
                                  .push(new MaterialPageRoute<Null>(
                                      builder: (BuildContext context) {
                                        return new AddTruck();
                                      },
                                      fullscreenDialog: true));
                        },
                        icon: Icon(Icons.add),
                        label: Text("Add Truck"))
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable2(
                    columnSpacing: defaultPadding,
                    minWidth: 600,
                    columns: [
                      DataColumn(
                        label: Text("S. No."),
                      ),
                      DataColumn(
                        label: Text("Truck Number"),
                      ),
                      DataColumn(
                        label: Text("Truck Name"),
                      ),
                      DataColumn(
                        label: Text("Truck Type"),
                      ),
                      DataColumn(
                        label: Text("Owner"),
                      ),
                      DataColumn(
                        label: Text("Driver"),
                      ),
                      DataColumn(
                        label: Text("Contact"),
                      ),
                      DataColumn(
                        label: Text("Action"),
                      ),
                    ],
                    rows: List.generate(
                      widget.bm
                          .sublist(
                              (currPage * iCount) - iCount,
                              currPage * iCount <= widget.bm.length - 1
                                  ? currPage * iCount
                                  : widget.bm.length)
                          .length,
                      (index) => recentFileDataRow(
                          widget.bm.sublist(
                              (currPage * iCount) - iCount,
                              currPage * iCount <= widget.bm.length - 1
                                  ? currPage * iCount
                                  : widget.bm.length)[index],
                          context),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Rows Per Page: "),
                    Text("$iCount "),
                    PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return List.generate(pages.length, (index) {
                          return PopupMenuItem(
                            value: pages[index],
                            child: Text("${pages[index]}"),
                          );
                        });
                      },
                      child: Icon(
                        Icons.arrow_drop_up,
                        size: 15.0,
                        color: Colors.black,
                      ),
                      onSelected: (value) {
                        setState(() {
                          currPage = 1;
                          iCount = int.parse(value.toString());
                          String s =
                              "${((totalBookings / iCount) * iCount == totalBookings ? (totalBookings / iCount) : (totalBookings / iCount) + 1)}";
                          int p = int.parse(s.split(".")[0]);
                          totalPages = p * iCount == totalBookings ? p : p + 1;
                        });
                      },
                    ),
                    Text("Page: $currPage of $totalPages "),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (currPage != 1) {
                              currPage -= 1;
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            if (currPage != totalPages) {
                              currPage += 1;
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_forward_ios))
                  ],
                )
              ],
            ),
          );
  }
}

_onTap(Truck fileInfo, context) {
  Responsive.isDesktop(context)
      ? showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                backgroundColor: secondaryColor,
                content: ViewTruck(bm: fileInfo),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"),
                    color: primaryColor,
                  ),
                ],
              ))
      : Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return new ViewTruck(bm: fileInfo);
          },
          fullscreenDialog: true));
}

recentFileDataRow(Truck fileInfo, context) {
  return DataRow(
    cells: [
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.sNo}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.truknumber}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.trukName}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.trukType}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.ownerName}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.driver}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text("${fileInfo.mobileNumber}"),
          ), onTap: () {
        _onTap(fileInfo, context);
      }),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: [
            FlatButton(
              color: primaryColor,
              onPressed: () {},
              child: Text("Block"),
            ),
          ],
        ),
      )),
    ],
  );
}
