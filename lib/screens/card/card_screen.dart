import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messages_apk/screens/card/user_info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kText = Color(0xFF333333);
const Color kAccent = Color(0xFF71503C);

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString('cart');
    if (cartString != null) {
      final List<dynamic> decodedList = jsonDecode(cartString);
      setState(() {
        cartItems =
            decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      final price = _toDouble(item['price']);
      final quantity = _toDouble(item['quantity']);
      total += price * quantity;
    }
    return total;
  }

  double _toDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
        backgroundColor: Color(0xFFF0DDC9),
        centerTitle: true,
        title: Text(
          'Votre Panier',
          style: GoogleFonts.playfairDisplay(
            // ✨ Elegant serif font
            color: kText,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Image(
              image: AssetImage('images/empty/emptyCart.png'),
              width: 200,
            ))
          : Container(
              color: const Color(0xFFFDF7F1),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final price = _toDouble(item['price']);
                        final quantity = _toDouble(item['quantity']);

                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item['imageURL'] != null)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(item['imageURL'],
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover),
                                  ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(item['name'] ?? 'Produit',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: kText,
                                          )),
                                      const SizedBox(height: 4),
                                      Text('${price.toStringAsFixed(2)} Dh',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          )),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              if (quantity > 1) {
                                                setState(() =>
                                                    item['quantity'] =
                                                        quantity - 1);
                                                _saveCart();
                                              }
                                            },
                                          ),
                                          Text(
                                            quantity.toInt().toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline),
                                            onPressed: () {
                                              setState(() => item['quantity'] =
                                                  quantity + 1);
                                              _saveCart();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () {
                                    setState(() => cartItems.removeAt(index));
                                    _saveCart();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(14),
                  //       border: Border.all(color: Colors.grey.shade200),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 12, vertical: 10),
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: TextField(
                  //             decoration: InputDecoration(
                  //               hintText: "Enter Discount Code",
                  //               hintStyle: TextStyle(color: Colors.grey[600]),
                  //               border: InputBorder.none,
                  //             ),
                  //           ),
                  //         ),
                  //         TextButton(
                  //           onPressed: () {},
                  //           child: const Text("Apply",
                  //               style: TextStyle(
                  //                 color: kAccent,
                  //                 fontWeight: FontWeight.bold,
                  //               )),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("SubTotal",
                                  style: TextStyle(fontSize: 16)),
                              Text('${totalPrice.toStringAsFixed(2)} Dh',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text('${totalPrice.toStringAsFixed(2)} Dh',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoScreen(
                                cartItems: cartItems, totalPrice: totalPrice),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        minimumSize: const Size.fromHeight(56),
                      ),
                      child: const Text(
                        'Proceed to Checkout',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cart', jsonEncode(cartItems));
  }
}
