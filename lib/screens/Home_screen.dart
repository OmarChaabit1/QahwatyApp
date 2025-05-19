import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messages_apk/shared/widgets/CategoryCard.dart';
import 'package:messages_apk/shared/widgets/ProductCard.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchNewArrivals() async {
    QuerySnapshot snapshot = await _firestore.collection('new_arrivals').get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

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

            /// 🆕 Fetching and displaying from Firestore
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchNewArrivals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Error loading products');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No new arrivals');
                }

                final products = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: products.map((product) {
                      return ProductCard(
                        name: product['name'] ?? '',
                        price: '${product['price']} DH',
                        oldPrice: '${product['oldPrice']} DH',
                        imagePath: product['imagePath'] ??
                            'images/categories/sugar.png',
                        rating: product['rating']?.toDouble() ?? 0.0,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
