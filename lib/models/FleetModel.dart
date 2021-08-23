import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class FleetOwners{
  String city;
  String state;
  String company;
  String gst;
  String image;
  String mobile;
  String name;
  String email;
  String registration;
  String token;
  String uid;
  var joining;
  int sNo;
  FleetOwners({
   required this.name,
   required this.image,
   required this.email,
   required this.token,
   required this.uid,
    required this.city,
    required this.state,
    required this.company,
    required this.gst,
    required this.joining,
    required this.mobile,
    required this.registration,
    required this.sNo
});
}