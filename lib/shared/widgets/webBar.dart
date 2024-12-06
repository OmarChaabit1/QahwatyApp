import 'package:flutter/material.dart';

class WebAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 200,
      leading: Image.asset(
        'assets/images/LOGO_MIDLJJOB.png',
        fit: BoxFit.cover,
      ),
      toolbarHeight: 100,
    );
  }
}