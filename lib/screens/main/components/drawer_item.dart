import 'package:admin/screens/About/AboutMain.dart';
import 'package:admin/screens/Bookings/BookingMain.dart';
import 'package:admin/screens/Cancelled%20Bookings/CancelledBookingMain.dart';
import 'package:admin/screens/Drivers/DriverMain.dart';
import 'package:admin/screens/Insurance/InsuranceMainScreen.dart';
import 'package:admin/screens/Marketting%20Screen/MarkettingMain.dart';
import 'package:admin/screens/Notification/NotificationMain.dart';
import 'package:admin/screens/Promotional%20Coupons/CouponsMain.dart';
import 'package:admin/screens/Truck%20Companies/CompanyMain.dart';
import 'package:admin/screens/Trucks/TruckMain.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../main_screen.dart';

class DrawerItem {
  final String title;
  final String svgPath;
  final Widget? screen;

  DrawerItem({
    required this.title,
    required this.svgPath,
    this.screen,
  });
}

List<DrawerItem> drawerItems = [
  DrawerItem(
    title: 'Dashboard',
    svgPath: iconPath + 'menu_dashboard.svg',
    screen: MainScreen(),
  ),
  DrawerItem(
    title: 'Bookings',
    svgPath: iconPath + 'bookmark.svg',
    screen: BookingMainScreen(),
  ),
  DrawerItem(
    title: 'Cancelled Bookings',
    svgPath: iconPath + 'cancelbookmark.svg',
    screen: CBookingMainScreen(),
  ),
  DrawerItem(
    title: 'Drivers',
    svgPath: iconPath + 'driver.svg',
    screen: DriverMainScreen(),
  ),
  DrawerItem(
    title: 'Truck Companies',
    svgPath: iconPath + 'menu_store.svg',
    screen: CompaniesMainScreen(),
  ),
  DrawerItem(
    title: 'Trucks',
    svgPath: iconPath + 'truck_svg.svg',
    screen: TruckMainScreen(),
  ),
  DrawerItem(
    title: 'Insurance',
    svgPath: iconPath + 'insurance.svg',
    screen: InsuranceMainScreen(),
  ),
  DrawerItem(
    title: 'Marketing',
    svgPath: iconPath + 'menu_store.svg',
    screen: MarketingMainScreen(),
  ),
  DrawerItem(
    title: 'Promotional Coupons',
    svgPath: iconPath + 'menu_store.svg',
    screen: CouponsMain(),
  ),
  DrawerItem(
    title: 'Notification',
    svgPath: iconPath + 'menu_notification.svg',
    screen: NotificationMain(),
  ),
  DrawerItem(
    title: 'About',
    svgPath: iconPath + 'about.svg',
    screen: AboutMain(),
  ),
  DrawerItem(
    title: 'Settings',
    svgPath: iconPath + 'menu_setting.svg',
    screen: null,
  ),
];
