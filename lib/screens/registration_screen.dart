import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messages_apk/screens/sign_in_screen.dart';
import 'package:messages_apk/widgets/my_buttons.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class registrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  const registrationScreen({Key? key}) : super(key: key);

  @override
  _registrationScreenState createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email, password, fullName;
  bool showSpinner = false;

  String? userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  children: [
                    Container(
                      child: Image.asset(
                        'images/logo.png',
                        width: 250,
                        height: 250,
                      ),
                    ),
                    SizedBox(height: 25),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return "Password cannot be empty";
                        }
                        if (!regex.hasMatch(value)) {
                          return ("please enter valid password min. 6 character");
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your email',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 113, 8, 134),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 113, 8, 134),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        fullName = value;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter your fullName',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 113, 8, 134),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                MyButton(
                  color: Colors.blueGrey[900]!,
                  title: 'Register',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );

                      userId = _generateRandomUserId();
                      await newUser.user!.updateDisplayName(fullName);

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(newUser.user!.uid)
                          .set({
                        'email': email,
                        'userId': userId,
                        'fullName': fullName,
                        // 'role': role,
                      });

                      Navigator.pushReplacementNamed(
                          context, signInScreen.screenRoute);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _generateRandomUserId() {
    final Random random = Random();
    String result = '';
    for (int i = 0; i < 6; i++) {
      result += random.nextInt(10).toString();
    }
    return result;
  }
}
