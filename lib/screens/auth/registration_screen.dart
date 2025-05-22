// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:messages_apk/screens/auth/sign_in_screen.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class registrationScreen extends StatefulWidget {
//   static const String screenRoute = 'registration_screen';

//   const registrationScreen({Key? key}) : super(key: key);

//   @override
//   _registrationScreenState createState() => _registrationScreenState();
// }

// class _registrationScreenState extends State<registrationScreen> {
//   final _auth = FirebaseAuth.instance;
//   late String email, password;
//   bool showSpinner = false;

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
//                           "Sign Up",
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.brown,
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(
//                                 context, signInScreen.screenRoute);
//                           },
//                           child: Text(
//                             "Login",
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: Colors.grey,
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
//                       onChanged: (value) {
//                         email = value;
//                       },
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
//                       onChanged: (value) {
//                         password = value;
//                       },
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
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: () async {
//                         setState(() => showSpinner = true);
//                         try {
//                           final newUser =
//                               await _auth.createUserWithEmailAndPassword(
//                                   email: email, password: password);
//                           if (newUser != null) {
//                             Navigator.pushNamed(
//                                 context, signInScreen.screenRoute);
//                           }
//                           setState(() => showSpinner = false);
//                         } catch (e) {
//                           print(e);
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
//                         'Sign Up',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// // }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:messages_apk/screens/auth/sign_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class registrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  const registrationScreen({Key? key}) : super(key: key);

  @override
  _registrationScreenState createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  late String email, password;
  bool showSpinner = false;

  // Fonction pour s'inscrire avec email + mot de passe + envoi mail vérification
  Future<void> registerWithEmail() async {
    setState(() => showSpinner = true);
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (newUser.user != null) {
        // Envoi du mail de validation
        await newUser.user!.sendEmailVerification();

        // Optionnel : message de succès à afficher (dialog/snackbar)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Un email de vérification a été envoyé. Vérifiez votre boîte mail.',
          ),
        ));

        Navigator.pushNamed(context, signInScreen.screenRoute);
      }
    } catch (e) {
      print('Erreur inscription : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'inscription.'),
      ));
    }
    setState(() => showSpinner = false);
  }

  Future<void> supaRegisterWithEmail() async {
    setState(() => showSpinner = true);
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'http://localhost:55018/',
      );

      final user = response.user;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Un email de vérification a été envoyé. Vérifiez votre boîte mail.',
          ),
        ));

        Navigator.pushNamed(context, signInScreen.screenRoute);
      }
    } catch (e) {
      print('Erreur inscription : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'inscription.'),
      ));
    } finally {
      setState(() => showSpinner = false);
    }
  }

  // Fonction pour se connecter avec Google
  Future<void> signInWithGoogle() async {
    setState(() => showSpinner = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // L'utilisateur a annulé la connexion Google
        setState(() => showSpinner = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        // L'utilisateur est connecté via Google
        // Ici tu peux vérifier si l'utilisateur est nouveau, enregistrer dans Firestore, etc.

        Navigator.pushNamed(context, signInScreen.screenRoute);
      }
    } catch (e) {
      print('Erreur connexion Google : $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la connexion avec Google.'),
      ));
    }
    setState(() => showSpinner = false);
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
                    image: AssetImage('images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Image.asset(
                      'images/logo.png',
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
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, signInScreen.screenRoute);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'images/qahwaty.png',
                        height: 60,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                      },
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
                      onChanged: (value) {
                        password = value;
                      },
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
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: supaRegisterWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 177, 127, 52),
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),

                    SizedBox(height: 15),

                    // Bouton Google Sign In
                    ElevatedButton.icon(
                      icon: Image.asset(
                        'images/logo.png', // ajoute un logo Google dans assets
                        height: 24,
                        width: 24,
                      ),
                      label: Text(
                        'Sign Up with Google',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        minimumSize: Size(double.infinity, 50),
                        side: BorderSide(color: Colors.grey),
                      ),
                      onPressed: signInWithGoogle,
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
