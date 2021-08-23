import 'package:flutter/material.dart';

class BookingModel{
  var bookingId;
  var bookingDate;
  String agent;
  var destination;
  String driver;
  String ewayBill;
  bool insured;
  String load;
  String mandate;
  List material;
  String contact;
  String payType;
  String pickupDate;
  String price;
  String source;
  String status;
  String truckNumber;
  String truckName;
  String user;
  BookingModel({
   required this.bookingDate,
   required this.user,
   required this.destination,
   required this.source,
   required this.status,
   required this.driver,
   required this.contact,
   required this.price,
   required this.agent,
    required this.bookingId,
    required this.ewayBill,
    required this.insured,
    required this.load,
    required this.mandate,
    required this.material,
    required this.payType,
    required this.pickupDate,
    required this.truckName,
    required this.truckNumber,
});
}