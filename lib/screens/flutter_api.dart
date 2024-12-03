// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class flutterApi extends StatefulWidget {
//   static const String screenRoute = 'flutter_api_screen';
//   const flutterApi({super.key});

//   @override
//   _flutterApiState createState() => _flutterApiState();
// }

// class _flutterApiState extends State<flutterApi> {
//   final _auth = FirebaseAuth.instance;
//   late User signedInUser;
//   final Completer<GoogleMapController> _controller = Completer();
//   static const LatLng sourceLocation = LatLng(37.4219983, -122.084);
//   static const LatLng destination = LatLng(37.4219983, -122.086);

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
//       body: GoogleMap(
//         initialCameraPosition:
//             CameraPosition(target: sourceLocation, zoom: 14.5),
//         markers: {
//           Marker(
//             markerId: MarkerId("source"),
//             position: sourceLocation,
//           ),
//           Marker(
//             markerId: MarkerId("destination"),
//             position: destination,
//           ),
//         },
//       ),
//     );
//   }
// }
