import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/card/card_screen.dart';
import 'package:messages_apk/screens/card/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Colors as constants
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
      final newFavorite = {
        'id': widget.product['id'],
        'name': widget.product['name'],
        'price': widget.product['price'],
        'imageURL': widget.product['imageURL'],
      };
      currentFavorites.add(newFavorite);
      await prefs.setString('favorites', jsonEncode(currentFavorites));

      setState(() {
        isFavorite = true;
      });
    } else {
      // Remove the product from favorites by id
      currentFavorites
          .removeWhere((item) => item['id'] == widget.product['id']);
      await prefs.setString('favorites', jsonEncode(currentFavorites));

      setState(() {
        isFavorite = false;
      });
    }
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Center(
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  image: product['imageURL'] != null
                      ? DecorationImage(
                          image: NetworkImage(product['imageURL']),
                          fit: BoxFit.contain,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              product['name'] ?? 'Titre de Produit',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kText,
              ),
            ),
            Text(
              '${product['price'] ?? '0.00'} Dh',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: kAccent,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${product['rating']?.toStringAsFixed(1) ?? "4.0"}',
                        style: const TextStyle(color: Colors.orange),
                      ),
                      const SizedBox(width: 4),
                      const Text("(200 avis)",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Vendeur : ${product['seller'] ?? 'Non défini'}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                )
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Description",
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            Text(
              product['description'] ??
                  "Ce produit est conçu pour hydrater, protéger et renforcer votre peau grâce à une formule riche et efficace.",
              style: const TextStyle(color: kText),
            ),
            const SizedBox(height: 32),
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
            // Quantity
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: kAccent),
                borderRadius: BorderRadius.circular(8),
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
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();

                  final String? cartString = prefs.getString('cart');
                  List<Map<String, dynamic>> cart = [];

                  if (cartString != null) {
                    final List<dynamic> decodedList = jsonDecode(cartString);
                    cart = decodedList
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

                  int existingIndex = cart
                      .indexWhere((item) => item['id'] == productToAdd['id']);
                  if (existingIndex >= 0) {
                    cart[existingIndex]['quantity'] += quantity;
                  } else {
                    cart.add(productToAdd);
                  }

                  await prefs.setString('cart', jsonEncode(cart));

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${product['name']} ajouté au panier')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Ajouter au Panier",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
