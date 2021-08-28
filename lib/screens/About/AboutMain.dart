import 'package:admin/responsive.dart';
import 'package:admin/screens/About/AboutScreen.dart';

import 'package:admin/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import '../../constants.dart';

class AboutMain extends StatelessWidget {
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
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: AboutScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
