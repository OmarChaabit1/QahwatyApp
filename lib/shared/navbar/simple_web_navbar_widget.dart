// import 'package:flutter/material.dart';
// import 'package:midlv2/features/Dashbord_widget.dart';
// import 'package:midlv2/features/carrousel_wiget.dart';
// import 'package:midlv2/features/messagerie_widget.dart';
// import 'package:midlv2/features/my_profil/profile_settings_layout.dart';
// import 'package:midlv2/features/profile_widget.dart';

// class SimpleWebNavbarWidget extends StatefulWidget {
//   const SimpleWebNavbarWidget({
//     super.key,
//     required this.onPageSelected,
//     this.currentPage,
//   });

//   final Widget? currentPage; // Make it nullable to handle no page being passed
//   final void Function(Widget) onPageSelected;

//   @override
//   State<SimpleWebNavbarWidget> createState() => _SimpleWebNavbarWidgetState();
// }

// class _SimpleWebNavbarWidgetState extends State<SimpleWebNavbarWidget> {
//   late Widget _currentPage;

//   @override
//   void initState() {
//     super.initState();
//     _currentPage = widget.currentPage ?? CarrouselScreen();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 1.0,
//       height: 100.0,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: const [
//           BoxShadow(
//             blurRadius: 4.0,
//             color: Color(0x33000000),
//             offset: Offset(0.0, 2.0),
//             spreadRadius: 2.0,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
//         children: [
//           // Logo Section
//           Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
//             child: InkWell(
//               onTap: () async {
//                 await launchURL('https://www.midljob.com/');
//               },
//               child: Container(
//                 width: 150.0,
//                 height: 80.0,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8.0),
//                   child: Image.asset(
//                     'assets/images/LOGO_MIDLJJOB.png',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Navbar Items
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end, // Align to the start
//                 children: [
//                   // Navbar Item: Carousel
//                   _buildNavItem(
//                     onTap: () {
//                       widget.onPageSelected(CarrouselScreen());
//                     },
//                     image: 'assets/images/logo.png',
//                     label: 'Carrousel',
//                   ),
//                   SizedBox(width: 5),
//                   // Navbar Item: Dashboard
//                   _buildNavItem(
//                     onTap: () {
//                       widget.onPageSelected(DashboardScreen());
//                     },
//                     icon: Icons.dashboard,
//                     label: 'Tableau de bord',
//                   ),
//                   SizedBox(width: 5),
//                   // Navbar Item: Chat
//                   _buildNavItem(
//                     onTap: () {
//                       widget.onPageSelected(MessagerieScreen());
//                     },
//                     icon: Icons.chat,
//                     label: 'Messagerie',
//                   ),
//                   SizedBox(width: 5),
//                   // Navbar Item: Profile
//                   _buildNavItem(
//                     onTap: () {
//                       widget.onPageSelected(MyProfilLayout());
//                     },
//                     icon: Icons.person,
//                     label: 'Profil',
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(
//       {VoidCallback? onTap,
//       String? image,
//       IconData? icon,
//       required String label}) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 55.0,
//             height: 55.0,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   blurRadius: 4.0,
//                   color: Color(0x3E000000),
//                   offset: Offset(0.0, 0.0),
//                   spreadRadius: 2.0,
//                 ),
//               ],
//               shape: BoxShape.circle,
//             ),
//             child: icon != null
//                 ? Icon(icon, color: Colors.black, size: 35.0)
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(8.0),
//                     child: Image.asset(image!, fit: BoxFit.cover),
//                   ),
//           ),
//           const SizedBox(height: 4.0), // Spacer
//           Text(label),
//         ],
//       ),
//     );
//   }
// }

// Future<void> launchURL(String url) async {
//   print("Launching URL: $url");
// }
