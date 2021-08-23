import 'package:admin/screens/Bookings/BookingMain.dart';
import 'package:admin/screens/Cancelled%20Bookings/CancelledBookingMain.dart';
import 'package:admin/screens/Drivers/DriverMain.dart';
import 'package:admin/screens/Marketting%20Screen/MarkettingMain.dart';
import 'package:admin/screens/Promotional%20Coupons/CouponsMain.dart';
import 'package:admin/screens/Truck%20Companies/CompanyMain.dart';
import 'package:admin/screens/Trucks/TruckMain.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: Image.asset("assets/images/logo.png"),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MainScreen()));
            },
          ),
          DrawerListTile(
            title: "Bookings",
            svgSrc: "assets/icons/bookmark.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>BookingMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Cancelled Booking",
            svgSrc: "assets/icons/cancelbookmark.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>CBookingMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Drivers",
            svgSrc: "assets/icons/driver.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>DriverMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Truck Companies",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>CompaniesMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Trucks",
            svgSrc: "assets/icons/truck_svg.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>TruckMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Marketing",
            svgSrc: "assets/icons/menu_store.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>MarketingMainScreen()));
            },
          ),
          DrawerListTile(
            title: "Promotional Coupons",
            svgSrc: "assets/icons/coupon.svg",
            press: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>CouponsMain()));
            },
          ),
          DrawerListTile(
            title: "Notification",
            svgSrc: "assets/icons/menu_notification.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "About",
            svgSrc: "assets/icons/about.svg",
            press: () {},
          ),
          DrawerListTile(
            title: "Settings",
            svgSrc: "assets/icons/menu_setting.svg",
            press: () {},
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
