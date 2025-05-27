import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/tabs_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kText = Color(0xFF333333);
const Color kAccent = Color(0xFF71503C);

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      final List<dynamic> decodedList = jsonDecode(favoritesString);
      setState(() {
        favorites =
            decodedList.map((item) => Map<String, dynamic>.from(item)).toList();
      });
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favorites', jsonEncode(favorites));
  }

  void removeFromFavorites(int index) {
    setState(() {
      favorites.removeAt(index);
    });
    _saveFavorites();
  }

  Widget buildRatingStars(double rating) {
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.orange, size: 16);
        } else if (index == fullStars && hasHalfStar) {
          return const Icon(Icons.star_half, color: Colors.orange, size: 16);
        } else {
          return const Icon(Icons.star_border, color: Colors.orange, size: 16);
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            TabsScreen.screenRoute,
            (route) => false,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Image(
              image: AssetImage('images/empty/noFav.png'),
              width: 200,
            ))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                double rating =
                    (item['rating'] != null) ? item['rating'] * 1.0 : 4.0;

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: item['imageURL'] != null
                                ? Image.network(
                                    item['imageURL'],
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image_not_supported,
                                        size: 40),
                                  ),
                          ),
                          const SizedBox(width: 16),

                          // Product details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] ?? 'Produit',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: kText,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Rating stars + reviews count (optional)
                                Row(
                                  children: [
                                    buildRatingStars(rating),
                                    const SizedBox(width: 8),
                                    const Text(
                                      "(200 avis)",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.black54),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  '${item['price']} Dh',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: kAccent,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                // Optional description snippet if exists
                                if (item['description'] != null)
                                  Text(
                                    item['description'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                              ],
                            ),
                          ),

                          // Delete button
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () => removeFromFavorites(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
