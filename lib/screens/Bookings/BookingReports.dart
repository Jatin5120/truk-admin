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
  List<BookingModel> bm =[];
  BookingReport({
   required this.bm
});
  @override
  _BookingReportState createState() => _BookingReportState();
}

class _BookingReportState extends State<BookingReport> {
  List<String> un=[];
  List<String> an=[];
  bool isLoading=true;
  int totalPages=0;
  int totalBookings = 0;
  List<int> pages=[];
  int currPage=1;
  var percentage;
  int iCount= 5;
  List<String> destAddress=[];
  List<String> sourceAddress=[];
  getData() async {
    setState(() {
      totalBookings = widget.bm.length;
      String s= "${((totalBookings/iCount)*iCount==totalBookings?(totalBookings/iCount):(totalBookings/iCount)+1)}";
      int p = int.parse(s.split(".")[0]);
      totalPages = p*iCount==totalBookings?p:p+1;
    });
    for(int i=0;i<widget.bm.length;i++) {
      setState(() {
        pages.add(i+1);
        percentage= (((i+1)/widget.bm.length)*100).toStringAsFixed(2);
      });
      await FirebaseFirestore.instance.collection('Users').get().then((value) {
        for (var data in value.docs) {
          if (data.id == widget.bm[i].user) {
            setState(() {
              un.add(data['name']);
            });
          }
        }
      });
      await FirebaseFirestore.instance.collection('FleetOwners').get().then((
          value) {
        for (var data in value.docs) {
          if (data.id == widget.bm[i].agent) {
            setState(() {
              an.add(data['name']);
            });
          }
        }
      });
      try {
        http.Response response = await http.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget
                .bm[i].destination.toString().split(',')[0]},${widget.bm[i]
                .destination.toString()
                .split(',')[1]}&key=$kGoogleApiKey"));
        var data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          for (var d in data['results']) {
            setState(() {
              destAddress.add(d['formatted_address']);
            });
          }
        }
        else {
          print(response.statusCode);
        }
        http.Response response2 = await http.get(Uri.parse(
            "https://maps.googleapis.com/maps/api/geocode/json?latlng=${widget
                .bm[i].source.toString().split(',')[0]},${widget.bm[i].source
                .toString().split(',')[1]}&key=$kGoogleApiKey"));
        var data2 = jsonDecode(response2.body);
        if (response2.statusCode == 200) {
          for (var d in data2['results']) {
            setState(() {
              sourceAddress.add(d['formatted_address']);
            });
          }
        }
        else {
          print(response2.statusCode);
        }
      } catch (e) {
        print("Error: $e ");
      }
      finally {
        print("completed");
      }
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
                "Bookings",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              ElevatedButton.icon(onPressed: (){
                Download().downloadBookings(context, widget.bm, destAddress, sourceAddress,un,an);
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
                  label: Text("Eway Bill"),
                ),
              ],
              rows: List.generate(
                widget.bm.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length).length,
                    (index) => recentFileDataRow(widget.bm.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                        un.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                        an.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                        destAddress.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],
                        sourceAddress.sublist((currPage*iCount)-iCount,currPage*iCount<=widget.bm.length-1?currPage*iCount:widget.bm.length)[index],context),
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
_onTap(BookingModel fileInfo,String un, String an,String destAddress,String sourceAddress, context){
  Responsive.isDesktop(context)?showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
    backgroundColor: secondaryColor,
    content: ViewBooking(bm: fileInfo,an: an,un: un,destAddress: destAddress,sourceAddress: sourceAddress,),
    actions: [
      FlatButton(onPressed: (){
        Navigator.pop(context);
      }, child: Text("Cancel"),color: primaryColor,),
    ],
  )):Navigator.of(context).push(new MaterialPageRoute<Null>(
      builder: (BuildContext context) {
        return new ViewBooking(bm: fileInfo,an: an,un: un,destAddress: destAddress,sourceAddress: sourceAddress,);
      },
      fullscreenDialog: true
  ));
}

recentFileDataRow(BookingModel fileInfo, String un, String an,String destAddress,String sourceAddress, context){
  return DataRow(
    cells: [
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text("${fileInfo.bookingId}"),
      ),
      onTap: (){
        _onTap(fileInfo,un,an,destAddress,sourceAddress,context);
      }
      ),
      DataCell(
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(un),
      ),
          onTap: (){
            _onTap(fileInfo,un,an,destAddress,sourceAddress,context);
          }
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Text(an),
      ),
          onTap: (){
            _onTap(fileInfo,un,an,destAddress,sourceAddress,context);
          }
      ),
      DataCell(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: FlatButton(
          color: primaryColor,
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
      )),
    ],
  );
}
