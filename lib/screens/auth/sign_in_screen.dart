import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:messages_apk/screens/auth/registration_screen.dart';
import 'package:messages_apk/screens/passwordProcess/Forgot_password.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:messages_apk/screens/tabs_screen.dart';

class signInScreen extends StatefulWidget {
  static const String screenRoute = 'sign_in_screen';

  const signInScreen({super.key});

  @override
  State<signInScreen> createState() => _signInScreenState();
}

class _signInScreenState extends State<signInScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google sign-in cancelled by user')),
        );
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Google Sign-In failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo.png'), // Pattern image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Image.asset(
                      'images/logo.png', // Logo with coffee cup
                      height: 120,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(width: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, registrationScreen.screenRoute);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'images/qahwaty.png', // Logo with coffee cup
                        height: 60,
                      ),
                    ),
                    // Text(
                    //   'Qahwty',
                    //   style: TextStyle(
                    //     fontFamily: 'Pacifico',
                    //     fontSize: 32,
                    //     color: Colors.black87,
                    //   ),
                    // ),
                    SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) => email = value,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 177, 127, 52),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) => password = value,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 177, 127, 52),
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, ForgotPasswordScreen.screenRoute);
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     setState(() => showSpinner = true);
                    //     try {
                    //       final user = await _auth.signInWithEmailAndPassword(
                    //           email: email, password: password);
                    //       if (user != null) {
                    //         Navigator.pushNamed(
                    //             context, TabsScreen.screenRoute);
                    //       }
                    //       setState(() => showSpinner = false);
                    //     } catch (e) {
                    //       print(e);
                    //       setState(() => showSpinner = false);
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Color.fromARGB(255, 177, 127, 52),
                    //     padding: EdgeInsets.symmetric(vertical: 14),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(25),
                    //     ),
                    //     minimumSize: Size(double.infinity, 50),
                    //   ),
                    //   child: Text(
                    //     'Login',
                    //     style: TextStyle(fontSize: 18, color: Colors.white),
                    //   ),
                    // ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() => showSpinner = true);

                        // ✅ Vérifie si c'est l'admin
                        const String adminEmail =
                            'admin@gmail.com'; // <-- Remplace par ton email admin réel

                        if (email.trim().toLowerCase() != adminEmail) {
                          setState(() => showSpinner = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Only admin can log in with email and password')),
                          );
                          return;
                        }

                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);
                          if (user != null) {
                            Navigator.pushNamed(
                                context, TabsScreen.screenRoute);
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to log in: $e')),
                          );
                        } finally {
                          setState(() => showSpinner = false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 177, 127, 52),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'images/logo.png', // Add your Google logo asset or use an Icon widget
                        height: 24,
                      ),
                      label: Text(
                        'Sign in with Google',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      onPressed: () async {
                        setState(() => showSpinner = true);
                        UserCredential? userCredential =
                            await signInWithGoogle();
                        setState(() => showSpinner = false);

                        if (userCredential != null) {
                          Navigator.pushNamed(context, TabsScreen.screenRoute);
                        } else {
                          // Optional: Show error or user cancelled message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Google sign-in failed or cancelled')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4285F4), // Google blue color
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:messages_apk/screens/auth/registration_screen.dart';
// import 'package:messages_apk/screens/passwordProcess/Forgot_password.dart';
// import 'package:messages_apk/screens/tabs_screen.dart';

// class signInScreen extends StatefulWidget {
//   static const String screenRoute = 'sign_in_screen';

//   const signInScreen({super.key});

//   @override
//   State<signInScreen> createState() => _signInScreenState();
// }

// class _signInScreenState extends State<signInScreen> {
//   final _auth = FirebaseAuth.instance;
//   late String email;
//   late String password;
//   bool showSpinner = false;

//   Future<void> signInWithGoogle() async {
//     setState(() => showSpinner = true);
//     try {
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       if (googleUser == null) {
//         setState(() => showSpinner = false);
//         return; // user cancelled
//       }

//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       if (userCredential.user != null) {
//         Navigator.pushNamed(context, TabsScreen.screenRoute);
//       }
//     } catch (e) {
//       print('Google Sign-In Error: $e');
//     } finally {
//       setState(() => showSpinner = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: ModalProgressHUD(
//         inAsyncCall: showSpinner,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage('images/logo.png'),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 40),
//                     Image.asset(
//                       'images/logo.png',
//                       height: 120,
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                 padding: EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black26,
//                       blurRadius: 10,
//                       offset: Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Login",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.brown,
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               Navigator.pushNamed(
//                                   context, registrationScreen.screenRoute);
//                             },
//                             child: Text(
//                               'Sign Up',
//                               style: TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 20),
//                     Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Image.asset(
//                         'images/qahwaty.png',
//                         height: 60,
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     TextField(
//                       keyboardType: TextInputType.emailAddress,
//                       textAlign: TextAlign.center,
//                       onChanged: (value) => email = value,
//                       decoration: InputDecoration(
//                         hintText: 'Email',
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide(
//                             color: Color.fromARGB(255, 177, 127, 52),
//                             width: 2,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     TextField(
//                       obscureText: true,
//                       textAlign: TextAlign.center,
//                       onChanged: (value) => password = value,
//                       decoration: InputDecoration(
//                         hintText: 'Password',
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide(
//                             color: Color.fromARGB(255, 177, 127, 52),
//                             width: 2,
//                           ),
//                         ),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         contentPadding:
//                             EdgeInsets.symmetric(vertical: 16, horizontal: 20),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(
//                               context, ForgotPasswordScreen.screenRoute);
//                         },
//                         child: Text(
//                           'Forgot Password',
//                           style: TextStyle(color: Colors.black54),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () async {
//                         setState(() => showSpinner = true);
//                         try {
//                           final user = await _auth.signInWithEmailAndPassword(
//                               email: email, password: password);
//                           if (user != null) {
//                             Navigator.pushNamed(
//                                 context, TabsScreen.screenRoute);
//                           }
//                         } catch (e) {
//                           print(e);
//                         } finally {
//                           setState(() => showSpinner = false);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color.fromARGB(255, 177, 127, 52),
//                         padding: EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         minimumSize: Size(double.infinity, 50),
//                       ),
//                       child: Text(
//                         'Login',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                     SizedBox(height: 20),

//                     // Google Sign-In Button
//                     GestureDetector(
//                       onTap: signInWithGoogle,
//                       child: Container(
//                         height: 50,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(color: Colors.grey.shade300),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 5,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Image.asset(
//                               'images/logo.png', // You need to add this asset
//                               height: 24,
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               'Sign in with Google',
//                               style: TextStyle(
//                                   fontSize: 16, color: Colors.black87),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
