import 'package:flutter/services.dart';
import 'package:messages_apk/screens/help_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/chat_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
// import 'package:messages_apk/screens/googleMap_screen.dart';
import 'package:messages_apk/screens/registration_screen.dart';
import 'package:messages_apk/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/tabs_screen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Message App ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser != null
          ? TabsScreen.screenRoute
          : WelcomeScreen.screenRoute,
      routes: {
        TabsScreen.screenRoute: (context) =>
            TabsScreen(), // Initial route to TabsScreen
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        signInScreen.screenRoute: (context) => signInScreen(),
        registrationScreen.screenRoute: (context) => registrationScreen(),
        chatScreen.screenRoute: (context) => chatScreen(
              chatPartnerEmail: '',
            ),
        dashboardScreen.screenRoute: (context) => dashboardScreen(),
        // googleMapScreen.screenRoute: (context) => googleMapScreen(),
        // flutterApi.screenRoute: (context) => flutterApi(),
        ProfileScreen.screenRoute: (context) =>
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        UpdateProfileScreen.screenRoute: (context) => UpdateProfileScreen(
            currentUser: FirebaseAuth.instance.currentUser!),
        HelpScreen.screenRoute: (context) => HelpScreen(),
      },
    );
  }
}
