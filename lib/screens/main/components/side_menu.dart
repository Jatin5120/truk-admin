import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'drawer_item.dart';

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
            decoration: BoxDecoration(color: Colors.white),
            child: Image.asset("assets/images/logo.png"),
          ),
          for (int i = 0; i < drawerItems.length; i++) ...[
            DrawerListTile(
              title: drawerItems[i].title,
              svgPath: drawerItems[i].svgPath,
              index: i,
              screen: drawerItems[i].screen,
            ),
          ]
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
    required this.svgPath,
    required this.index,
    this.screen,
  }) : super(key: key);

  final String title;
  final String svgPath;
  final Widget? screen;
  final int index;

  static int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: screen == null
          ? () {}
          : () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => screen!,
                ),
              );
              _selectedIndex = index;
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _selectedIndex == index ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: [
            SvgPicture.asset(
              svgPath,
              color: _selectedIndex == index ? Colors.white : Colors.white54,
              height: 16,
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: _selectedIndex == index ? Colors.white : Colors.white54,
                overflow: TextOverflow.ellipsis,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
