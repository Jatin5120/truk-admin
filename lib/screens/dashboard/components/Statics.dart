import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class StaticsM extends StatefulWidget {
  @override
  _StaticsMState createState() => _StaticsMState();
}

class _StaticsMState extends State<StaticsM> {
  int totalDrivers=0;
  int totalUsers=0;
  int totalCompanies=0;
  int totalTrucks=0;
  bool isLoading= true;
  List<statisticalData> data=[];
  getWidgetData(){
    setState(() {
      data=[
        statisticalData(
          title: "Total Drivers",
          numOfFiles: totalDrivers,
          svgSrc: "assets/icons/driver2.svg",
          color: primaryColor,
          percentage: 100,
        ),
        statisticalData(
          title: "Total fleet owners",
          numOfFiles: totalCompanies,
          svgSrc: "assets/icons/owner.svg",
          color: Color(0xFFFFA113),
          percentage: 100,
        ),
        statisticalData(
          title: "Total Users",
          numOfFiles: totalUsers,
          svgSrc: "assets/icons/user.svg",
          color: Color(0xFFA4CDFF),
          percentage: 100,
        ),
        statisticalData(
          title: "Total Trucks",
          numOfFiles: totalTrucks,
          svgSrc: "assets/icons/truck_svg.svg",
          color: Color(0xFF007EE5),
          percentage: 100,
        ),
      ];
      isLoading=false;
    });
  }
  getData() async {
    await FirebaseFirestore.instance.collection('FleetOwners').get().then((value){
      setState(() {
        totalCompanies = value.docs.length;
      });
    });
    await FirebaseFirestore.instance.collection('RegisteredDriver').get().then((value){
      setState(() {
        totalDrivers= value.docs.length;
      });
    });
    await FirebaseFirestore.instance.collection('Truks').get().then((value){
      setState(() {
        totalTrucks=value.docs.length;
      });
    });
    await FirebaseFirestore.instance.collection('Users').get().then((value){
      setState(() {
        totalUsers=value.docs.length;
      });
    });
    getWidgetData();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return isLoading?CircularProgressIndicator():Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Meta Data",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            // ElevatedButton.icon(
            //   style: TextButton.styleFrom(
            //     padding: EdgeInsets.symmetric(
            //       horizontal: defaultPadding * 1.5,
            //       vertical:
            //           defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
            //     ),
            //   ),
            //   onPressed: () {},
            //   icon: Icon(Icons.add),
            //   label: Text("Add New"),
            // ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
            data: data,
          ),
          tablet: FileInfoCardGridView(data: data,),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
            data: data,
          ),
        ),
      ],
    );
  }
}


class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.data
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<statisticalData> data;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: data[index]),
    );
  }
}
