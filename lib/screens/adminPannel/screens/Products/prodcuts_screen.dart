// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:messages_apk/screens/adminPannel/screens/Products/add_product_form.dart';

// final Color kBg = const Color(0xFFF0DDC9);
// final Color kText = const Color(0xFF333333);
// final Color kAccent = const Color(0xFF71503C);

// class ProductsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text("Add Product", style: TextStyle(color: kText)),
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFFF0DDC9), Color(0xFFE6D2BC)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: GlassCard(child: AddProductForm()),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GlassCard extends StatelessWidget {
//   final Widget child;
//   const GlassCard({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(30),
//       child: BackdropFilter(
//         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           width: MediaQuery.of(context).size.width * 0.85,
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.05),
//             borderRadius: BorderRadius.circular(30),
//             border: Border.all(color: Colors.white.withOpacity(0.2)),
//           ),
//           child: child,
//         ),
//       ),
//     );
//   }
// }
