// import 'package:flutter/foundation.dart';
// import 'package:messages_apk/screens/admin/admin_panel_screen.dart';
// import 'package:messages_apk/screens/adminPannel/screens/dashboard_screen.dart';
// import 'package:messages_apk/screens/notification_screen.dart';
// import 'package:messages_apk/screens/passwordProcess/Forgot_password.dart';
// import 'package:messages_apk/screens/passwordProcess/get_started_screen.dart';
// import 'package:messages_apk/screens/profile/help_screen.dart';
// import 'package:messages_apk/screens/profile/profile_screen.dart';
// import 'package:messages_apk/screens/profile/update_profile_screen.dart';
// import 'package:messages_apk/screens/dashboard_screen.dart';
// import 'package:messages_apk/screens/auth/registration_screen.dart';
// import 'package:messages_apk/screens/passwordProcess/set_new_password.dart';
// import 'package:messages_apk/screens/auth/sign_in_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:messages_apk/screens/tabs_screen.dart';
// import 'package:messages_apk/screens/passwordProcess/verification_code.dart';
// import 'screens/auth/Welcome_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// import 'dart:io' show Platform;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (kIsWeb) {
//     await Firebase.initializeApp(
//         options: const FirebaseOptions(
//             // apiKey: "AIzaSyCoP-OdutejThx3BS-eROHcQBpzupP2DYw",
//             // authDomain: "messagesapk-c5194.firebaseapp.com",
//             // projectId: "messagesapk-c5194",
//             // storageBucket: "messagesapk-c5194.firebasestorage.app",
//             // messagingSenderId: "249966798374",
//             // appId: "1:249966798374:web:098f63881aaed99d99a8e7"));
//             apiKey: "AIzaSyCmke_n_quxNytAV89930s4UQB8axkYo7g",
//             authDomain: "qahwatyapp.firebaseapp.com",
//             projectId: "qahwatyapp",
//             storageBucket: "qahwatyapp.firebasestorage.app",
//             messagingSenderId: "711642542247",
//             appId: "1:711642542247:web:83b395f4f9b4e402912b82"));
//   } else {
//     await Firebase.initializeApp();
//   }
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   final _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Qahwaty',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: _auth.currentUser != null
//           ? TabsScreen.screenRoute
//           : GetStartedScreen.screenRoute,
//       routes: {
//         // admin
//         AdminPanelScreen.screenRoute: (context) => AdminPanelScreen(),

// //
//         TabsScreen.screenRoute: (context) => TabsScreen(),
//         GetStartedScreen.screenRoute: (context) => GetStartedScreen(),
//         // Initial route to TabsScreen
//         WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
//         signInScreen.screenRoute: (context) => signInScreen(),
//         registrationScreen.screenRoute: (context) => registrationScreen(),
//         // chatScreen.screenRoute: (context) => chatScreen(
//         //       chatPartnerEmail: '',
//         //     ),
//         dashboardScreen.screenRoute: (context) => dashboardScreen(),
//         DashboardScreen.screenRoute: (context) => DashboardScreen(),
//         // ========== notification process ==============
//         NotificationScreen.screenRoute: (context) => NotificationScreen(),

//         // ========== password process ==============
//         VerificationCodeScreen.screenRoute: (context) =>
//             VerificationCodeScreen(),
//         ForgotPasswordScreen.screenRoute: (context) => ForgotPasswordScreen(),
//         NewPasswordScreen.screenRoute: (context) => NewPasswordScreen(),

//         // ========= profile process =============
//         ProfileScreen.screenRoute: (context) =>
//             ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
//         UpdateProfileScreen.screenRoute: (context) => UpdateProfileScreen(
//             currentUser: FirebaseAuth.instance.currentUser!),
//         HelpScreen.screenRoute: (context) => HelpScreen(),
//         // lmerd
//       },
//     );
//   }
// }

import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:messages_apk/screens/card/thank_you_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/notification_screen.dart';
import 'package:messages_apk/screens/passwordProcess/Forgot_password.dart';
import 'package:messages_apk/screens/passwordProcess/get_started_screen.dart';
import 'package:messages_apk/screens/profile/help_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/auth/registration_screen.dart';
import 'package:messages_apk/screens/passwordProcess/set_new_password.dart';
import 'package:messages_apk/screens/auth/sign_in_screen.dart';
import 'package:messages_apk/screens/tabs_screen.dart';
import 'package:messages_apk/screens/passwordProcess/verification_code.dart';
import 'screens/auth/Welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCmke_n_quxNytAV89930s4UQB8axkYo7g",
          authDomain: "qahwatyapp.firebaseapp.com",
          projectId: "qahwatyapp",
          storageBucket: "qahwatyapp.firebasestorage.app",
          messagingSenderId: "711642542247",
          appId: "1:711642542247:web:83b395f4f9b4e402912b82"),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://urzxnpwtfrpwxtqvemio.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVyenhucHd0ZnJwd3h0cXZlbWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc3NjA2MTksImV4cCI6MjA2MzMzNjYxOX0.ETtc_ok67nTyu3zTF3bA31qvDrnaVe3JbMfb2H6EC-U', // Replace with your Supabase anon key
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Qahwaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser != null
          ? TabsScreen.screenRoute
          : GetStartedScreen.screenRoute,
      routes: {
        // thank
        ThankYouScreen.screenRoute: (context) => ThankYouScreen(),
        // admin
        TabsScreen.screenRoute: (context) => TabsScreen(),
        GetStartedScreen.screenRoute: (context) => GetStartedScreen(),
        WelcomeScreen.screenRoute: (context) => WelcomeScreen(),
        signInScreen.screenRoute: (context) => signInScreen(),
        registrationScreen.screenRoute: (context) => registrationScreen(),
        dashboardScreen.screenRoute: (context) => dashboardScreen(),
        DashboardScreen.screenRoute: (context) => DashboardScreen(),
        NotificationScreen.screenRoute: (context) => NotificationScreen(),
        VerificationCodeScreen.screenRoute: (context) =>
            VerificationCodeScreen(),
        ForgotPasswordScreen.screenRoute: (context) => ForgotPasswordScreen(),
        NewPasswordScreen.screenRoute: (context) => NewPasswordScreen(),
        ProfileScreen.screenRoute: (context) =>
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        UpdateProfileScreen.screenRoute: (context) => UpdateProfileScreen(
            currentUser: FirebaseAuth.instance.currentUser!),
        HelpScreen.screenRoute: (context) => HelpScreen(),
      },
    );
  }
}
