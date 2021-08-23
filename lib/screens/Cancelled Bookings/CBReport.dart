import 'dart:convert';

import 'package:admin/Helper/DownloadHelper.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/CancelledBookingModel.dart';
import 'package:admin/screens/Bookings/ViewBooking.dart';
import 'package:admin/screens/Cancelled%20Bookings/ViewCB.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';
import '../../responsive.dart';

class CBReport extends StatefulWidget {
  List<CancelledBookings> bm =[];
  CBReport({
    required this.bm
  });
  @override
  _CBReportState createState() => _CBReportState();
}

class _CBReportState extends State<CBReport> {
  List<String> un=[];
  List<String> an=[];
  List<int> r = [];
  bool isLoading=true;
  int totalPages=0;
  int totalBookings = 0;
  List<int> pages=[];
  int currPage=1;
  var percentage;
  int iCount= 5;
  int x=0;
  int y=0;
  getData() async {
    setState(() {
      totalBookings = widget.bm.length;
      String s= "${((totalBookings/iCount)*iCount==totalBookings?(totalBookings/iCount):(totalBookings/iCount)+1)}";
      int p = int.parse(s.split(".")[0]);
      totalPages = p*iCount==totalBookings?p:p+1;
    });
    for(int i=0;i<widget.bm.length;i++){
      setState(() {
        x=0;
        y=widget.bm[i].amount;
        pages.add(i+1);
        percentage= (((i+1)/widget.bm.length)*100).toStringAsFixed(2);
      });
      await FirebaseFirestore.instance.collection('FleetOwners').get().then((value) {
        for(var d in value.docs){
          an.add(d['name']);
        }
      });
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        for(var d in value.docs){
          un.add(d['name']);
        }
      });
      await FirebaseFirestore.instance.collection('Refunds').where('bookingId',isEqualTo: widget.bm[i].id).get().then((value) {
        for(var d in value.docs){
          setState(() {
            x+=int.parse(d['amount']);
          });
        }
        setState(() {
          y=y-x;
          r.add(y);
        });
      });
    }
    setState(() {
      isLoading=false;
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
    return isLoading?Container(
        child: Column(
          children: [
            CircularProgressIndicator(),
            Text("Fetching Data Please Wait ......\n $percentage % done")
          ],
        )
    ):Container(
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
                "Cancelled Bookings",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ElevatedButton.icon(onPressed: (){
                Download().downloadCB(context, widget.bm, r,un,an);
              }, icon: Icon(Icons.download), label: Text("Download"))
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("Id"),
                ),
                DataColumn(
                  label: Text("User"),
                ),
                DataColumn(
                  label: Text("Agent"),
                ),
                DataColumn(
                  label: Text("Refunds"),
                ),
              ],
              rows: List.generate(
                widget.bm.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length).length,
                    (index) => recentFileDataRow(widget.bm.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                    un.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                    an.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                    r.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],context),
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
                child: Icon(Icons.arrow_drop_up,size: 15.0,color: Colors.black,),
                onSelected: (value){
                  setState(() {
                    currPage=1;
                    iCount=int.parse(value.toString());
                    String s= "${((totalBookings/iCount)*iCount==totalBookings?(totalBookings/iCount):(totalBookings/iCount)+1)}";
                    int p = int.parse(s.split(".")[0]);
                    totalPages = p*iCount==totalBookings?p:p+1;
                  });
                },
              ),
              Text("Page: $currPage of $totalPages "),
              IconButton(onPressed: (){
                setState(() {
                  if(currPage!=1){
                    currPage-=1;
                  }
                });
              }, icon: Icon(Icons.arrow_back_ios)),
              IconButton(onPressed: (){
                setState(() {
                  if(currPage!=totalPages){
                    currPage+=1;
                  }
                });
              }, icon: Icon(Icons.arrow_forward_ios))
            ],
          )
        ],
      ),
    );
  }
}
_onTap(CancelledBookings fileInfo,String un, String an,int r, context){
  Responsive.isDesktop(context)?showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
    backgroundColor: secondaryColor,
    content: ViewCB(bm: fileInfo,un: un,an: an, r: r,),
    actions: [
      FlatButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel"),color: primaryColor,),
    ],
  )):Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new ViewCB(bm: fileInfo,un: un,an: an, r: r,);
      },
      fullscreenDialog: true
  ));
}

recentFileDataRow(CancelledBookings fileInfo, String un,String an, int r, context){
  return DataRow(
    cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text("${fileInfo.id}"),
      ),
          onTap: (){
            _onTap(fileInfo,un,an,r,context);
          }
      ),
      DataCell(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(un),
          ),
          onTap: (){
            _onTap(fileInfo,un,an,r,context);
          }
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(an),
      ),
          onTap: (){
            _onTap(fileInfo,un,an,r,context);
          }
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FlatButton(
          color: primaryColor,
          onPressed: () async {
            if(r>0){
              String fileUrl = "https://dashboard.razorpay.com/#/access/signin";
              if (await canLaunch(fileUrl)) {
                launch(fileUrl);
              } else {
                Fluttertoast.showToast(msg: "Cannot navigate to RazorPay Link");
              }
            }
            else{
              Fluttertoast.showToast(msg: "Insufficient Amount to Refund");
            }
          },
          child: Text("Refund $r"),
        ),
      )),
    ],
  );
}
