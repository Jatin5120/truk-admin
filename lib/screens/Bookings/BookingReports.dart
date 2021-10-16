import 'dart:convert';

import 'package:admin/Helper/DownloadHelper.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/screens/Bookings/ViewBooking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../responsive.dart';

class BookingReport extends StatefulWidget {
  List<BookingModel> bm = [];

  BookingReport({required this.bm});

  @override
  _BookingReportState createState() => _BookingReportState();
}

class _BookingReportState extends State<BookingReport> {
  List<String> userNames = [];
  List<String> agentNames = [];
  bool isLoading = true;
  int totalPages = 0;
  int totalBookings = 0;
  List<int> pages = [];
  int currPage = 1;
  var percentage;
  static int iCount = 10;
  List<String> destAddress = [];
  List<String> sourceAddress = [];
  List<String> pendingAmount = [];

  static const List<String> _tableHeader = [
    'Id',
    'User',
    'Agent',
    'Eway Bill',
    'Total amount',
    'Payment mode',
    'Shipment status',
    // 'Pending amount',
  ];

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
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var data in value.docs) {
          if (data.id == widget.bm[i].user) {
            setState(() {
              userNames.add(data['name']);
            });
          }
        }
      });
      await FirebaseFirestore.instance
          .collection('FleetOwners')
          .get()
          .then((value) {
        for (var data in value.docs) {
          if (data.id == widget.bm[i].agent) {
            setState(() {
              agentNames.add(data['name']);
            });
          }
        }
      });
      try {
        http.Response response = await http.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.bm[i].destination.toString().split(',')[0]},${widget.bm[i].destination.toString().split(',')[1]}&key=$kGoogleApiKey"));
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          for (var d in data['results']) {
            setState(() {
              destAddress.add(d['formatted_address']);
            });
          }
        } else {
          print(response.statusCode);
        }
        http.Response response2 = await http.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget.bm[i].source.toString().split(',')[0]},${widget.bm[i].source.toString().split(',')[1]}&key=$kGoogleApiKey"));
        var data2 = jsonDecode(response2.body);
        if (response2.statusCode == 200) {
          for (var d in data2['results']) {
            setState(() {
              sourceAddress.add(d['formatted_address']);
            });
          }
        } else {
          print(response2.statusCode);
        }
      } catch (e) {
        print("Error: $e ");
      } finally {
        print("completed");
      }
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
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text(
                  "$percentage % done\nFetching Data Please Wait .  .  .",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Bookings",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Download().downloadBookings(
                            context,
                            widget.bm,
                            destAddress,
                            sourceAddress,
                            userNames,
                            agentNames,
                          );
                        },
                        icon: Icon(Icons.download),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(4.0),
                        ),
                        label: Text("Download"),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable2(
                    columnSpacing: defaultPadding,
                    minWidth: 600,
                    columns: [
                      for (int i = 0; i < _tableHeader.length; i++) ...[
                        DataColumn(
                          label: Text(_tableHeader[i]),
                        ),
                      ],
                    ],
                    rows: List.generate(
                      widget.bm
                          .sublist(
                            (currPage * iCount) - iCount,
                            currPage * iCount <= widget.bm.length - 1
                                ? currPage * iCount
                                : widget.bm.length,
                          )
                          .length,
                      (index) => recentFileDataRow(
                        context: context,
                        index: index,
                        fileInfo: widget.bm.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.bm.length - 1
                              ? currPage * iCount
                              : widget.bm.length,
                        )[index],
                        userName: userNames.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.bm.length - 1
                              ? currPage * iCount
                              : widget.bm.length,
                        )[index],
                        agentName: agentNames.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.bm.length - 1
                              ? currPage * iCount
                              : widget.bm.length,
                        )[index],
                        destAddress: destAddress.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.bm.length - 1
                              ? currPage * iCount
                              : widget.bm.length,
                        )[index],
                        sourceAddress: sourceAddress.sublist(
                          (currPage * iCount) - iCount,
                          currPage * iCount <= widget.bm.length - 1
                              ? currPage * iCount
                              : widget.bm.length,
                        )[index],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Rows Per Page: "),
                      Text("$iCount "),
                      PopupMenuButton(
                        itemBuilder: (BuildContext context) {
                          return List.generate(
                            pages.length,
                            (index) {
                              return PopupMenuItem(
                                value: pages[index],
                                child: Text("${pages[index]}"),
                              );
                            },
                          );
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
                            totalPages =
                                p * iCount == totalBookings ? p : p + 1;
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
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (currPage != totalPages) {
                              currPage += 1;
                            }
                          });
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}

_onTap(
  BookingModel fileInfo,
  String userName,
  String agentName,
  String destAddress,
  String sourceAddress,
  context,
) {
  Responsive.isDesktop(context)
      ? showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            backgroundColor: secondaryColor,
            content: ViewBooking(
              bm: fileInfo,
              an: agentName,
              un: userName,
              destAddress: destAddress,
              sourceAddress: sourceAddress,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel"),
                style: ElevatedButton.styleFrom(primary: primaryColor),
              ),
            ],
          ),
        )
      : Navigator.of(context).push(
          MaterialPageRoute<Null>(
            builder: (BuildContext context) {
              return new ViewBooking(
                bm: fileInfo,
                an: agentName,
                un: userName,
                destAddress: destAddress,
                sourceAddress: sourceAddress,
              );
            },
            fullscreenDialog: true,
          ),
        );
}

DataRow recentFileDataRow({
  required BuildContext context,
  required int index,
  required BookingModel fileInfo,
  required String userName,
  required String agentName,
  required String destAddress,
  required String sourceAddress,
}) {
  return DataRow(
    cells: [
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("${fileInfo.bookingId}"),
        ),
        onTap: () {
          _onTap(fileInfo, userName, agentName, destAddress, sourceAddress, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(userName),
        ),
        onTap: () {
          _onTap(fileInfo, userName, agentName, destAddress, sourceAddress, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(agentName),
        ),
        onTap: () {
          _onTap(fileInfo, userName, agentName, destAddress, sourceAddress, context);
        },
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: primaryColor),
            onPressed: () async {
              String fileUrl = fileInfo.ewayBill;
              if (await canLaunch(fileUrl)) {
                launch(fileUrl);
              } else {
                Fluttertoast.showToast(msg: "Cannot find Eway Bill");
              }
            },
            child: Text("Eway Bill"),
          ),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Rs. ${fileInfo.price}"),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(fileInfo.payType),
        ),
      ),
      DataCell(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(fileInfo.status),
        ),
      ),
    ],
    color: MaterialStateProperty.resolveWith((Set states) {
      if (index % 2 == 0) return tableRowColor1;
      return tableRowColor2;
    }),
  );
}
