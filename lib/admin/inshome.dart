import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:langapp/admin/callbbox.dart';

class InsHome extends StatefulWidget {
  late ColorScheme dync;
  InsHome({required this.dync, super.key});

  @override
  State<InsHome> createState() => _InsHomeState();
}

class _InsHomeState extends State<InsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: widget.dync.inversePrimary,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: GNav(
          duration: Duration(milliseconds: 1000),
          tabBorderRadius: 20,
          tabMargin: EdgeInsets.all(3),
          color: widget.dync.primary,
          tabBackgroundColor: widget.dync.primary,
          activeColor: Colors.white,
          backgroundColor: widget.dync.inversePrimary,
          tabs: [
            GButton(
              icon: Icons.home,
            ),
            GButton(icon: Icons.mail),
            GButton(
              icon: Icons.settings,
            ),
          ],
          onTabChange: (value) {
            setState(() {});
          },
        ),
      ),
      body: callbox(
        dync: widget.dync,
      ),
    );
  }
}
