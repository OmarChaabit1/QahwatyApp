// import 'package:flutter/material.dart';
// import 'package:midlv2/features/carrousel_wiget.dart';
// import 'package:midlv2/shared/navbar/simple_web_navbar_widget.dart'; // Import seulement le navbar pour le web

// bool isMobile(BuildContext context) {
//   return MediaQuery.of(context).size.width < 600; // Seuil pour mobile
// }

// class MainScreen extends StatefulWidget {
//   static const screenRoute = '/main_screen';

//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   Widget _currentPage = const CarrouselScreen(); // Page par défaut

//   void _onPageSelected(Widget page) {
//     setState(() {
//       _currentPage = page;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isMobileLayout = isMobile(context);

//     return Scaffold(
//       appBar: isMobileLayout
//           ? null
//           : PreferredSize(
//               preferredSize: const Size.fromHeight(100),
//               child: SimpleWebNavbarWidget(
//                 currentPage: _currentPage,
//                 onPageSelected: _onPageSelected,
//               ),
//             ), // AppBar pour le web
//       body: _currentPage, // Afficher la page actuelle
//       // bottomNavigationBar: plus de MobileNavWidget ici
//     );
//   }
// }
