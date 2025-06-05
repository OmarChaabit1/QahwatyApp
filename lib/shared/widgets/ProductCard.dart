import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});
  void showToast(BuildContext context, String title, String description,
      ToastificationType type) {
    Color primaryColor;
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case ToastificationType.success:
        primaryColor = const Color(0xFF4CAF50);
        backgroundColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case ToastificationType.info:
        primaryColor = Colors.purple;
        backgroundColor = Colors.white;
        icon = Icons.info_outline;
        break;
      case ToastificationType.warning:
        primaryColor = const Color(0xFFFFC107);
        backgroundColor = Colors.white;
        icon = Icons.warning_amber;
        break;
      default:
        primaryColor = const Color(0xFFF44336);
        backgroundColor = Colors.white;
        icon = Icons.error;
    }

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(icon),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      // foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 8),
        ),
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String name = product['name'];
    final String price = product['price'].toString();
    final String oldPrice = product['oldPrice'].toString();
    final double rating = (product['rating'] ?? 4.0).toDouble();
    final String imagePath = product['imageURL'] ?? '';

    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4), // less vertical space
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // only as big as needed vertically
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: imagePath.startsWith('http')
                ? Image.network(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  )
                : Image.asset(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding:
                const EdgeInsets.fromLTRB(10, 10, 10, 4), // less bottom padding
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toString().toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4), // less vertical space
                Row(
                  children: [
                    Text(
                      '$oldPrice DH',
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        decorationStyle: TextDecorationStyle.solid,
                        fontSize: 12,
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(">", style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 6),
                    Text(
                      '$price DH',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6), // less vertical space
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Spacer(),
                    // CircleAvatar(
                    //   radius: 12,
                    //   backgroundColor: const Color(0xFF71503C),
                    //   child:
                    //       const Icon(Icons.add, size: 16, color: Colors.white),
                    // ),
                    GestureDetector(
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String? cartString = prefs.getString('cart');
                        List<Map<String, dynamic>> cart = [];

                        if (cartString != null) {
                          final List<dynamic> decodedList =
                              jsonDecode(cartString);
                          cart = decodedList
                              .map((item) => Map<String, dynamic>.from(item))
                              .toList();
                        }

                        Map<String, dynamic> productToAdd = {
                          'id': product['id'],
                          'name': product['name'],
                          'price': product['price'],
                          'imageURL': product['imageURL'],
                          'quantity': 1,
                        };

                        int existingIndex = cart.indexWhere(
                            (item) => item['id'] == productToAdd['id']);
                        if (existingIndex >= 0) {
                          cart[existingIndex]['quantity'] += 1;
                        } else {
                          cart.add(productToAdd);
                        }

                        await prefs.setString('cart', jsonEncode(cart));

                        // ✅ Show styled toast
                        showToast(
                          context,
                          'Produit ajouté',
                          '${product['name']} a été ajouté au panier',
                          ToastificationType.success,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 12,
                        backgroundColor: Color(0xFF71503C),
                        child: Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
