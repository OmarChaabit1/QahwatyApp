import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/card/card_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBg = Color(0xFFF0DDC9);
const Color kText = Color(0xFF333333);
const Color kAccent = Color(0xFF71503C);

class ProductDetailScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');
    List<dynamic> currentFavorites =
        favoritesString != null ? jsonDecode(favoritesString) : [];

    setState(() {
      isFavorite =
          currentFavorites.any((item) => item['id'] == widget.product['id']);
    });
  }

  Future<void> addToFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');
    List<dynamic> currentFavorites =
        favoritesString != null ? jsonDecode(favoritesString) : [];

    if (!isFavorite) {
      currentFavorites.add({
        'id': widget.product['id'],
        'name': widget.product['name'],
        'price': widget.product['price'],
        'imageURL': widget.product['imageURL'],
      });
      await prefs.setString('favorites', jsonEncode(currentFavorites));
    } else {
      currentFavorites
          .removeWhere((item) => item['id'] == widget.product['id']);
      await prefs.setString('favorites', jsonEncode(currentFavorites));
    }

    setState(() => isFavorite = !isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: kText),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : kText,
            ),
            onPressed: addToFavorites,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              icon: const Icon(Icons.shopping_basket, color: kText),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                image: product['imageURL'] != null
                    ? DecorationImage(
                        image: NetworkImage(product['imageURL']),
                        fit: BoxFit.contain,
                      )
                    : null,
              ),
            ),

            // Title and Price
            Text(
              product['name'] ?? 'Produit',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${product['price'] ?? '0.00'} Dh',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: kAccent,
              ),
            ),
            const SizedBox(height: 10),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${product['rating']?.toStringAsFixed(1) ?? "4.0"}',
                  style: const TextStyle(color: Colors.orange),
                ),
                const SizedBox(width: 6),
                const Text("(200 avis)",
                    style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 20),

            // Description Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kText,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Description Content
            Text(
              product['description'] ??
                  "Ce produit est conçu pour hydrater, protéger et renforcer votre peau grâce à une formule riche et efficace.",
              style: const TextStyle(fontSize: 14, color: kText),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            // Quantity Selector
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: kAccent),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  Text('$quantity',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add, color: kAccent),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Add to Cart Button
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final String? cartString = prefs.getString('cart');
                  List<Map<String, dynamic>> cart = [];

                  if (cartString != null) {
                    final List<dynamic> decoded = jsonDecode(cartString);
                    cart = decoded
                        .map((item) => Map<String, dynamic>.from(item))
                        .toList();
                  }

                  Map<String, dynamic> productToAdd = {
                    'id': product['id'],
                    'name': product['name'],
                    'price': product['price'],
                    'imageURL': product['imageURL'],
                    'quantity': quantity,
                  };

                  int index = cart
                      .indexWhere((item) => item['id'] == productToAdd['id']);

                  if (index >= 0) {
                    cart[index]['quantity'] += quantity;
                  } else {
                    cart.add(productToAdd);
                  }

                  await prefs.setString('cart', jsonEncode(cart));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${product['name']} ajouté au panier'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Ajouter au Panier",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
