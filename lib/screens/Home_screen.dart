import 'package:flutter/material.dart';
import 'package:messages_apk/shared/widgets/CategoryCard.dart';
import 'package:messages_apk/shared/widgets/ProductCard.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            const Text('Welcome back,',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
            const Text('Robert J. Cartwright',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'search for product...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('CATEGORIES',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CategoryCard(
                    title: 'COFFEE', imagePath: 'images/categories/coffee.png'),
                CategoryCard(
                    title: 'TEA', imagePath: 'images/categories/tea.png'),
                CategoryCard(
                    title: 'CHOCOLAT',
                    imagePath: 'images/categories/chocolate.png'),
                CategoryCard(
                    title: 'SUGAR', imagePath: 'images/categories/sugar.png'),
                CategoryCard(
                    title: 'GOBELETS',
                    imagePath: 'images/categories/goblets.png'),
                CategoryCard(
                    title: 'NETTOYAGE',
                    imagePath: 'images/categories/nettoyage.png'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('NEWEST PRODUCTS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  ProductCard(
                    name: "JACQUES VABRE COFFEE",
                    price: "99.00 DH",
                    oldPrice: "115.00 DH",
                    rating: 9.8,
                    imagePath: 'images/categories/chocolate.png',
                  ),
                  ProductCard(
                      name: "GOLDEN VABRE COFFEE",
                      price: "99.00 DH",
                      oldPrice: "115.00 DH",
                      imagePath: 'images/categories/chocolate.png',
                      rating: 9.8),
                  ProductCard(
                      name: "GOLDEN VABRE COFFEE",
                      price: "99.00 DH",
                      oldPrice: "115.00 DH",
                      imagePath: 'images/categories/chocolate.png',
                      rating: 9.8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
