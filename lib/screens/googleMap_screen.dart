// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mapbox_gl/mapbox_gl.dart';

// class googleMapScreen extends StatefulWidget {
//   static const String screenRoute = 'googleMap_screen';
//   const googleMapScreen({super.key});

//   @override
//   _googleMapScreenState createState() => _googleMapScreenState();
// }

// class _googleMapScreenState extends State<googleMapScreen> {
//   final _auth = FirebaseAuth.instance;
//   late User signedInUser;

//   @override
//   void initState() {
//     super.initState();
//     getCurrentUser();
//   }

//   void getCurrentUser() {
//     try {
//       final user = _auth.currentUser;
//       if (user != null) {
//         signedInUser = user;
//         print(signedInUser.email);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   // onmapcreated
//   late MapboxMapController mapController;
//   void _onMapCreated(MapboxMapController controller) {
//     mapController = controller;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blueAccent,
//         title: const Text(
//           'GoogleMap',
//           style: TextStyle(color: Colors.white),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               try {
//                 await _auth.signOut();
//                 //Navigator.pushNamed(context,WelcomeScreen.screenRoute);
//                 Navigator.pop(context);
//               } catch (e) {
//                 print(e);
//               }
//             },
//             icon: Icon(
//               Icons.close,
//               color: Colors.white,
//               size: 38,
//             ),
//           ),
//         ],
//       ),
//       body: MapboxMap(
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.4219983, -122.084),
//           zoom: 14.0,
//         ),
//       ),
//     );
//   }
// }
// /*
// TileLayer(
//             urlTemplate: 'https://api.mapbox.com/styles/v1/omarchb/cluk43vtj00iu01nt4plyd4f5/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoib21hcmNoYiIsImEiOiJjbHVjODR1bDEwdWs4MnFwaWlueDUxYjAyIn0.3mGYXpkbGkPwmDkvanjLBQ/draft',
//             additionalOptions: {
//               'accessToken':'pk.eyJ1Ijoib21hcmNoYiIsImEiOiJjbHVjODR1bDEwdWs4MnFwaWlueDUxYjAyIn0.3mGYXpkbGkPwmDkvanjLBQ',
//               'id':'mapbox.mapbox-streets-v8'
//             }
//             */