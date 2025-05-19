import 'package:flutter/material.dart';

class AdminPanelScreen extends StatelessWidget {
  static const screenRoute = '/admin-panel';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Panel")),
      body: Center(child: Text("Bienvenue sur le panneau d'administration")),
    );
  }
}
