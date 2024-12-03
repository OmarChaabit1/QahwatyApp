import 'package:flutter/services.dart';
import 'package:messages_apk/screens/chat_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
// import 'package:messages_apk/screens/googleMap_screen.dart';
import 'package:messages_apk/screens/registration_screen.dart';
import 'package:messages_apk/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'screens/Welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:messages_apk/screens/flutter_api.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Message App ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser != null
          ? dashboardScreen.screenRoute
          : WelcomeScreen.screenRoute,
      routes: {
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        signInScreen.screenRoute: (context) => signInScreen(),
        registrationScreen.screenRoute: (context) => registrationScreen(),
        chatScreen.screenRoute: (context) => chatScreen(),
        dashboardScreen.screenRoute: (context) => dashboardScreen(),
        // googleMapScreen.screenRoute: (context) => googleMapScreen(),
        // flutterApi.screenRoute: (context) => flutterApi(),
      },
    );
  }
}
