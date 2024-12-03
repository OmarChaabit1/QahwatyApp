import 'package:flutter/material.dart';
import 'package:messages_apk/screens/chat_screen.dart';
// import 'package:messages_apk/screens/Welcome_screen.dart';
import 'package:messages_apk/screens/googleMap_screen.dart';
import 'package:messages_apk/widgets/my_buttons.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:messages_apk/screens/flutter_api.dart';

// import 'package:flutter_map/flutter_map.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

class dashboardScreen extends StatefulWidget {
  static const String screenRoute = 'dashboard_screen';
  const dashboardScreen({super.key});

  @override
  _dashboardScreenState createState() => _dashboardScreenState();
}

class _dashboardScreenState extends State<dashboardScreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
   
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Image.asset(
              'images/homePage.gif',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.white,
                size: 28,
              ),
              onPressed: () {
                Navigator.pushNamed(context, chatScreen.screenRoute);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.chat,
                color: Colors.red,
                size: 28,
              ),
              onPressed: () {
                // Navigator.pushNamed(context, flutterApi.screenRoute);
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await _auth.signOut();
                //Navigator.pushNamed(context,WelcomeScreen.screenRoute);
                Navigator.pop(context);
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(
              Icons.close,
              color: Colors.white,
              size: 38,
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          MyButton(
            color: Colors.blueGrey,
            title: 'Get Current Location',
            onPressed: () {
              
            },
          ),
          const SizedBox(height: 20),
          MyButton(
            color: Colors.blue[900]!,
            title: 'Open Google Map',
            onPressed: () {
             
            },
          ),
        ],
      )),
    );
  }
}
