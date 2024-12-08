import 'package:messages_apk/screens/sign_in_screen.dart';
import 'package:messages_apk/screens/registration_screen.dart';
import 'package:messages_apk/widgets/my_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = 'Welcome_screen';
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  child: Image.asset('images/logo.png'),
                ),
                Text(
                  'MessageMe',
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 113, 8, 134)),
                )
              ],
            ),
            SizedBox(height: 30),
            MyButton(
              color: Color.fromARGB(255, 113, 8, 134)!,
              title: 'Sign in',
              onPressed: () {
                Navigator.pushNamed(context, signInScreen.screenRoute);
              },
            ),
            MyButton(
              color: Colors.blueGrey[800]!,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, registrationScreen.screenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
