import 'package:flutter/foundation.dart';
import 'package:messages_apk/screens/passwordProcess/Forgot_password.dart';
import 'package:messages_apk/screens/passwordProcess/get_started_screen.dart';
import 'package:messages_apk/screens/profile/help_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/registration_screen.dart';
import 'package:messages_apk/screens/passwordProcess/set_new_password.dart';
import 'package:messages_apk/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/tabs_screen.dart';
import 'package:messages_apk/screens/passwordProcess/verification_code.dart';
import 'screens/Welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'dart:io' show Platform;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCoP-OdutejThx3BS-eROHcQBpzupP2DYw",
            authDomain: "messagesapk-c5194.firebaseapp.com",
            projectId: "messagesapk-c5194",
            storageBucket: "messagesapk-c5194.firebasestorage.app",
            messagingSenderId: "249966798374",
            appId: "1:249966798374:web:098f63881aaed99d99a8e7"));
  } else {
    await Firebase.initializeApp();
  }
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
          : GetStartedScreen.screenRoute,
      routes: {
        TabsScreen.screenRoute: (context) => TabsScreen(),
        GetStartedScreen.screenRoute: (context) => GetStartedScreen(),
        // Initial route to TabsScreen
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        signInScreen.screenRoute: (context) => signInScreen(),
        registrationScreen.screenRoute: (context) => registrationScreen(),
        // chatScreen.screenRoute: (context) => chatScreen(
        //       chatPartnerEmail: '',
        //     ),
        dashboardScreen.screenRoute: (context) => dashboardScreen(),
        // verification code
        VerificationCodeScreen.screenRoute: (context) =>
            VerificationCodeScreen(),
        ForgotPasswordScreen.screenRoute: (context) => ForgotPasswordScreen(),
        NewPasswordScreen.screenRoute: (context) => NewPasswordScreen(),
        // profile
        ProfileScreen.screenRoute: (context) =>
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        UpdateProfileScreen.screenRoute: (context) => UpdateProfileScreen(
            currentUser: FirebaseAuth.instance.currentUser!),
        HelpScreen.screenRoute: (context) => HelpScreen(),
      },
    );
  }
}
