import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messages_apk/screens/card/product_details.dart';
import 'package:messages_apk/shared/widgets/CategoryCard.dart';
import 'package:messages_apk/shared/widgets/ProductCard.dart';

class HomeScreen extends StatefulWidget {
  static const screenRoute = '/home';
  final VoidCallback? onCartUpdated; // <-- add this

  HomeScreen({Key? key, this.onCartUpdated}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String searchQuery = '';

  // bach ndiro display for the  username
  String userName = "";
  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch username when the widget initializes
  }

  Future<void> fetchUserName() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc =
        await _firestore.collection('users').doc(currentUser.uid).get();

    if (userDoc.exists) {
      setState(() {
        userName = userDoc.data()?['name'] ??
            'User'; // Use data()? and null-aware operator
      });
    } else {
      setState(() {
        userName = 'User';
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchNewArrivals() async {
    QuerySnapshot snapshot = await _firestore.collection('new_arrivals').get();

    final allProducts =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    // 🔍 Filter based on search query
    if (searchQuery.isNotEmpty) {
      return allProducts.where((product) {
        final name = product['name']?.toString().toLowerCase() ?? '';
        return name.contains(searchQuery.toLowerCase());
      }).toList();
    }

    return allProducts;
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    QuerySnapshot snapshot = await _firestore.collection('categories').get();
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
            // const Text('Robert J. Cartwright',
            //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(
              'Mr.$userName', // dynamic user name from Firestore
              style: GoogleFonts.playfairDisplay(
                color: kText,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),

            const SizedBox(height: 10),

            // 🔍 Search Field
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for product...',
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Error loading categories');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No categories found');
                }

                final categories = snapshot.data!;

                return GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: categories.map((category) {
                    return CategoryCard(
                      title: category['name'] ?? '',
                      imageUrl: category['imageUrl'] ?? 'images/logo.png',
                    );
                  }).toList(),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text('NEWEST PRODUCTS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            /// 🆕 Filtered Results
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchNewArrivals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text('Error loading products');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No products found');
                }

                final products = snapshot.data!;

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: products.map((product) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductDetailScreen(product: product),
                            ),
                          );
                        },
                        // child: ProductCard(
                        //   name: product['name'] ?? '',
                        //   price: '${product['price']} DH',
                        //   oldPrice: '${product['oldPrice']} DH',
                        //   imagePath: product['imageURL'] ?? '',
                        //   rating: product['rating']?.toDouble() ?? 0.0,
                        // ),
                        child: ProductCard(
                          product: product,
                        ),
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
