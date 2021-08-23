import 'package:admin/models/BookingModels.dart';
import 'package:admin/models/CancelledBookingModel.dart';
import 'package:admin/models/DriverModel.dart';
import 'package:admin/models/FleetModel.dart';
import 'package:admin/models/truck.dart';
import 'package:admin/widgets/AlertBox.dart';
import 'package:admin/widgets/AlertProgress.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'dart:html' as ht;

import '../constants.dart';
class Download{
  downloadBookings(context,List<BookingModel> bm, List<String> dAddress, List<String> sAddress,List<String> un, List<String> an){
    try{
      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('ID');
      sheet.getRangeByName('B1').setText('Date');
      sheet.getRangeByName('C1').setText('User');
      sheet.getRangeByName('D1').setText('Mobile');
      sheet.getRangeByName('E1').setText('Agent');
      sheet.getRangeByName('F1').setText('Source');
      sheet.getRangeByName('G1').setText('Destination');
      sheet.getRangeByName('H1').setText('Pick Up Date');
      sheet.getRangeByName('I1').setText('Load');
      sheet.getRangeByName('J1').setText('Mandate');
      sheet.getRangeByName('K1').setText('Material');
      sheet.getRangeByName('L1').setText('Quantity');
      sheet.getRangeByName('M1').setText('Price');
      sheet.getRangeByName('N1').setText('Payment Type');
      sheet.getRangeByName('O1').setText('Truck Name');
      sheet.getRangeByName('P1').setText('Truck Number');
      sheet.getRangeByName('Q1').setText('Insured');
      sheet.getRangeByName('R1').setText('Status');
      for (int i = 0; i < bm.length; i++) {
        BookingModel data = bm[i];
        sheet.getRangeByName('A${i + 2}').setText('${data.bookingId}');
        sheet.getRangeByName('B${i + 2}').setText('${data.bookingDate}');
        sheet.getRangeByName('C${i + 2}').setText('${un[i]}');
        sheet.getRangeByName('D${i + 2}').setText('${data.contact}');
        sheet.getRangeByName('E${i + 2}').setText('${an[i]}');
        sheet.getRangeByName('F${i + 2}').setText('${sAddress[i]}');
        sheet.getRangeByName('G${i + 2}').setText('${dAddress[i]}');
        sheet.getRangeByName('H${i + 2}').setText('${data.pickupDate}');
        sheet.getRangeByName('I${i + 2}').setText('${data.load}');
        sheet.getRangeByName('J${i + 2}').setText('${data.mandate}');
        sheet.getRangeByName('K${i + 2}').setText('Material Name: ${data.material[0]['materialName']}\nMaterial Type: ${data.material[0]['materialType']}');
        sheet.getRangeByName('L${i + 2}').setText('${data.material[0]['quantity']}');
        sheet.getRangeByName('M${i + 2}').setText('${data.price}');
        sheet.getRangeByName('N${i + 2}').setText('${data.payType}');
        sheet.getRangeByName('O${i + 2}').setText('${data.truckName}');
        sheet.getRangeByName('P${i + 2}').setText('${data.truckNumber}');
        sheet.getRangeByName('Q${i + 2}').setText('${data.insured}');
        sheet.getRangeByName('R${i + 2}').setText('${data.status}');
      }
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        backgroundColor: secondaryColor,
        content: ProgressAlert(),
      ),
      barrierDismissible: false
      );
      try{
        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();
        final blob = ht.Blob([bytes]);
        final url = ht.Url.createObjectUrlFromBlob(blob);
        final anchor = ht.document.createElement('a') as ht.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'BookingReport.xlsx';
        ht.document.body!.children.add(anchor);
        anchor.click();
        ht.document.body!.children.remove(anchor);
        ht.Url.revokeObjectUrl(url);
      }
      catch(e){
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
          backgroundColor: secondaryColor,
          content: Alert(msg: "An Error occurred: $e"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"),color: primaryColor,),
          ],
        ),
            barrierDismissible: false
        );
      }
      Navigator.pop(context);
    }catch(e){
      Alert(msg: "An Error occurred: $e",);
    }
  }
  downloadCB(context,List<CancelledBookings> bm, List<int> r,List<String> un, List<String> an){
    try{
      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('ID');
      sheet.getRangeByName('B1').setText('Date');
      sheet.getRangeByName('C1').setText('User');
      sheet.getRangeByName('D1').setText('Agent');
      sheet.getRangeByName('E1').setText('Refund To Be Done');
      for (int i = 0; i < bm.length; i++) {
        CancelledBookings data = bm[i];
        sheet.getRangeByName('A${i + 2}').setText('${data.id}');
        sheet.getRangeByName('B${i + 2}').setText('${data.time}');
        sheet.getRangeByName('C${i + 2}').setText('${un[i]}');
        sheet.getRangeByName('D${i + 2}').setText('${an[i]}');
        sheet.getRangeByName('E${i + 2}').setText('${an[i]}');
      }
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        backgroundColor: secondaryColor,
        content: ProgressAlert(),
      ),
          barrierDismissible: false
      );
      try{
        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();
        final blob = ht.Blob([bytes]);
        final url = ht.Url.createObjectUrlFromBlob(blob);
        final anchor = ht.document.createElement('a') as ht.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'CancelledBookingReport.xlsx';
        ht.document.body!.children.add(anchor);
        anchor.click();
        ht.document.body!.children.remove(anchor);
        ht.Url.revokeObjectUrl(url);
      }
      catch(e){
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
          backgroundColor: secondaryColor,
          content: Alert(msg: "An Error occurred: $e"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"),color: primaryColor,),
          ],
        ),
            barrierDismissible: false
        );
      }
      Navigator.pop(context);
    }catch(e){
      Alert(msg: "An Error occurred: $e",);
    }
  }
  downloadDriver(context,List<Drivers> bm,List<String> an){
    try{
      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('S.No.');
      sheet.getRangeByName('B1').setText('Name');
      sheet.getRangeByName('C1').setText('Agent');
      sheet.getRangeByName('D1').setText('Mobile');
      sheet.getRangeByName('E1').setText('DL');
      sheet.getRangeByName('F1').setText('Liscence Expiry Date');
      sheet.getRangeByName('G1').setText('Aadhar');
      sheet.getRangeByName('H1').setText('Pan');
      for (int i = 0; i < bm.length; i++) {
        Drivers data = bm[i];
        sheet.getRangeByName('A${i + 2}').setText('${data.sN}');
        sheet.getRangeByName('B${i + 2}').setText('${data.Name}');
        sheet.getRangeByName('C${i + 2}').setText('${an[i]}');
        sheet.getRangeByName('D${i + 2}').setText('${data.Mobile}');
        sheet.getRangeByName('E${i + 2}').setText('${data.DL}');
        sheet.getRangeByName('F${i + 2}').setText('${data.LED}');
        sheet.getRangeByName('G${i + 2}').setText('${data.Aadhar}');
        sheet.getRangeByName('H${i + 2}').setText('${data.Pan}');
      }
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        backgroundColor: secondaryColor,
        content: ProgressAlert(),
      ),
          barrierDismissible: false
      );
      try{
        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();
        final blob = ht.Blob([bytes]);
        final url = ht.Url.createObjectUrlFromBlob(blob);
        final anchor = ht.document.createElement('a') as ht.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'Drivers.xlsx';
        ht.document.body!.children.add(anchor);
        anchor.click();
        ht.document.body!.children.remove(anchor);
        ht.Url.revokeObjectUrl(url);
      }
      catch(e){
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
          backgroundColor: secondaryColor,
          content: Alert(msg: "An Error occurred: $e"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"),color: primaryColor,),
          ],
        ),
            barrierDismissible: false
        );
      }
      Navigator.pop(context);
    }catch(e){
      Alert(msg: "An Error occurred: $e",);
    }
  }
  downloadFleets(context,List<FleetOwners> bm){
    try{
      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('S.No.');
      sheet.getRangeByName('B1').setText('Joining');
      sheet.getRangeByName('C1').setText('Registration');
      sheet.getRangeByName('D1').setText('Name');
      sheet.getRangeByName('E1').setText('Email');
      sheet.getRangeByName('F1').setText('Contact');
      sheet.getRangeByName('G1').setText('GST');
      sheet.getRangeByName('H1').setText('Token');
      sheet.getRangeByName('I1').setText('City');
      sheet.getRangeByName('J1').setText('State');
      for (int i = 0; i < bm.length; i++) {
        FleetOwners data = bm[i];
        sheet.getRangeByName('A${i + 2}').setText('${data.sNo}');
        sheet.getRangeByName('B${i + 2}').setText('${data.joining}');
        sheet.getRangeByName('C${i + 2}').setText('${data.registration}');
        sheet.getRangeByName('D${i + 2}').setText('${data.name}');
        sheet.getRangeByName('E${i + 2}').setText('${data.email}');
        sheet.getRangeByName('F${i + 2}').setText('${data.mobile}');
        sheet.getRangeByName('G${i + 2}').setText('${data.gst}');
        sheet.getRangeByName('H${i + 2}').setText('${data.token}');
        sheet.getRangeByName('I${i + 2}').setText('${data.city}');
        sheet.getRangeByName('J${i + 2}').setText('${data.state}');
      }
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        backgroundColor: secondaryColor,
        content: ProgressAlert(),
      ),
          barrierDismissible: false
      );
      try{
        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();
        final blob = ht.Blob([bytes]);
        final url = ht.Url.createObjectUrlFromBlob(blob);
        final anchor = ht.document.createElement('a') as ht.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'FleetOwners.xlsx';
        ht.document.body!.children.add(anchor);
        anchor.click();
        ht.document.body!.children.remove(anchor);
        ht.Url.revokeObjectUrl(url);
      }
      catch(e){
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
          backgroundColor: secondaryColor,
          content: Alert(msg: "An Error occurred: $e"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"),color: primaryColor,),
          ],
        ),
            barrierDismissible: false
        );
      }
      Navigator.pop(context);
    }catch(e){
      Alert(msg: "An Error occurred: $e",);
    }
  }
  downloadTrucks(context,List<Truck> bm){
    try{
      final Workbook workbook = new Workbook();
      final Worksheet sheet = workbook.worksheets[0];
      sheet.getRangeByName('A1').setText('S.No.');
      sheet.getRangeByName('B1').setText('Truck Name');
      sheet.getRangeByName('C1').setText('Truck Number');
      sheet.getRangeByName('D1').setText('Truck Type');
      sheet.getRangeByName('E1').setText('Height');
      sheet.getRangeByName('F1').setText('Length');
      sheet.getRangeByName('G1').setText('Width');
      sheet.getRangeByName('H1').setText('Gross Weight');
      sheet.getRangeByName('I1').setText('Owner');
      sheet.getRangeByName('J1').setText('Driver');
      sheet.getRangeByName('K1').setText('Contact');
      sheet.getRangeByName('L1').setText('Pan Tin');
      sheet.getRangeByName('M1').setText('Permit Type');
      for (int i = 0; i < bm.length; i++) {
        Truck data = bm[i];
        sheet.getRangeByName('A${i + 2}').setText('${data.sNo}');
        sheet.getRangeByName('B${i + 2}').setText('${data.trukName}');
        sheet.getRangeByName('C${i + 2}').setText('${data.truknumber}');
        sheet.getRangeByName('D${i + 2}').setText('${data.trukType}');
        sheet.getRangeByName('E${i + 2}').setText('${data.height}');
        sheet.getRangeByName('F${i + 2}').setText('${data.length}');
        sheet.getRangeByName('G${i + 2}').setText('${data.breadth}');
        sheet.getRangeByName('H${i + 2}').setText('${data.grossWeight}');
        sheet.getRangeByName('I${i + 2}').setText('${data.ownerName}');
        sheet.getRangeByName('J${i + 2}').setText('${data.driver}');
        sheet.getRangeByName('K${i + 2}').setText('${data.mobileNumber}');
        sheet.getRangeByName('L${i + 2}').setText('${data.panTin}');
        sheet.getRangeByName('M${i + 2}').setText('${data.permitType}');
      }
      showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
        backgroundColor: secondaryColor,
        content: ProgressAlert(),
      ),
          barrierDismissible: false
      );
      try{
        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();
        final blob = ht.Blob([bytes]);
        final url = ht.Url.createObjectUrlFromBlob(blob);
        final anchor = ht.document.createElement('a') as ht.AnchorElement
          ..href = url
          ..style.display = 'none'
          ..download = 'Trucks.xlsx';
        ht.document.body!.children.add(anchor);
        anchor.click();
        ht.document.body!.children.remove(anchor);
        ht.Url.revokeObjectUrl(url);
      }
      catch(e){
        Navigator.pop(context);
        showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
          backgroundColor: secondaryColor,
          content: Alert(msg: "An Error occurred: $e"),
          actions: [
            FlatButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text("Cancel"),color: primaryColor,),
          ],
        ),
            barrierDismissible: false
        );
      }
      Navigator.pop(context);
    }catch(e){
      Alert(msg: "An Error occurred: $e",);
    }
  }
}