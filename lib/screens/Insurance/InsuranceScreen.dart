import 'package:admin/responsive.dart';
import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class InsuranceScreen extends StatelessWidget {
  const InsuranceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Responsive.isDesktop(context)
          ? null
          : AppBar(
        elevation: 0.0,
        backgroundColor: bgColor,
      ),
      drawer: !Responsive.isDesktop(context) ? SideMenu() : null,
    );
  }
}
