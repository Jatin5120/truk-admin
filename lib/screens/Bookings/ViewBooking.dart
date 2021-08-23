import 'package:admin/constants.dart';
import 'package:admin/models/BookingModels.dart';
import 'package:flutter/material.dart';
class ViewBooking extends StatelessWidget {
  ViewBooking({
   required this.bm,
    required this.un,
    required this.an,
    required this.sourceAddress,
    required this.destAddress
});
  BookingModel bm;
  var an;
  var un;
  var destAddress;
  var sourceAddress;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Booking ID: ${bm.bookingId}"),
              Text("Booking Date: ${bm.bookingDate}"),
              Text("User: $un"),
              Text("Mobile: ${bm.contact}"),
              Text("Agent: $an"),
              Text("Source: $sourceAddress"),
              Text("Destination: $destAddress"),
              Text("PickUp Date: ${bm.pickupDate}"),
              Text("Load: ${bm.load}"),
              Text("Mandate: ${bm.mandate}"),
              Text("Material:"),
              Text("Material Name: ${bm.material[0]['materialName']}"),
              Text("Material Type: ${bm.material[0]['materialType']}"),
              Text("Quantity: ${bm.material[0]['quantity']}"),
              Text("Price: ${bm.price}"),
              Text("Payment Type: ${bm.payType}"),
              Text("Truck Number: ${bm.truckNumber}"),
              Text("Truck: ${bm.truckName}"),
              Text("Width: ${bm.material[0]['width']}"),
              Text("Height: ${bm.material[0]['height']}"),
              Text("Length: ${bm.material[0]['length']}"),
              Text("Insured: ${bm.insured}"),
              Text("Status: ${bm.status}")
            ],
          ),
        )
    );
  }
}
