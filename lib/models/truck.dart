import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class Truck{
  String breadth;
  String height;
  String length;
  String grossWeight;
  String driver;
  String mobileNumber;
  String ownerId;
  String ownerName;
  String panTin;
  String permitType;
  String trukName;
  String truknumber;
  String trukType;
  int sNo;
  Truck({
   required this.driver,
    required this.sNo,
   required this.length,
   required this.height,
   required this.breadth,
   required this.grossWeight,
   required this.mobileNumber,
   required this.ownerId,
   required this.ownerName,
   required this.panTin,
   required this.permitType,
   required this.trukName,
   required this.truknumber,
   required this.trukType
});
}