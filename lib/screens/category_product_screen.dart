import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messages_apk/screens/card/product_details.dart';
import 'package:messages_apk/shared/widgets/ProductCard.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class CategoryProductsScreen extends StatefulWidget {
  final String category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

// class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
//   String selectedSubcategory = 'ALL';
//   String searchQuery = '';

//   Map<String, List<String>> subcategoriesMap = {
//     'COFFEE': ['ALL', 'EN GRAIN', 'SACHET', 'CAPSUL'],
//     'TEA': ['ALL', 'EN GRAIN', 'SACHET', 'VERVEINE'],
//     'CHOCOLAT': ['ALL', 'MORCEAUX', 'SACHET', 'DIABETIQUE'],
//     'SUGAR': ['ALL', 'POUDRE', 'LIQUIDE', 'MATERIAL'],
//     'GOBELETS': ['ALL', 'PETITE', 'MOYENE', 'GRAND'],
//   };

//   Future<List<Map<String, dynamic>>> fetchProducts() async {
//     final collection = FirebaseFirestore.instance.collection('products');
//     Query query = collection.where('category', isEqualTo: widget.category);

//     if (selectedSubcategory != 'ALL') {
//       query = query.where('subcategory', isEqualTo: selectedSubcategory);
//     }

//     final snapshot = await query.get();
//     return snapshot.docs.map((doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       data['id'] = doc.id; // add Firestore document ID as product id
//       return data;
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final subcategories = subcategoriesMap[widget.category] ?? ['ALL'];

//     return Scaffold(
//       backgroundColor: kBg,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: kBg,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: TextField(
//           decoration: InputDecoration(
//             contentPadding: const EdgeInsets.symmetric(horizontal: 16),
//             hintText: 'search for product . . .',
//             prefixIcon: const Icon(Icons.search, color: Colors.black54),
//             fillColor: Colors.white,
//             filled: true,
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
//           ),
//           onChanged: (value) => setState(() => searchQuery = value),
//         ),
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 8),
//           // Chips for subcategories
//           SizedBox(
//             height: 40,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: subcategories.length,
//               itemBuilder: (context, index) {
//                 final sub = subcategories[index];
//                 final isSelected = sub == selectedSubcategory;

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child: ChoiceChip(
//                     label: Text(sub),
//                     labelStyle: TextStyle(
//                       color: isSelected ? Colors.white : Colors.black,
//                     ),
//                     selected: isSelected,
//                     selectedColor: Colors.black,
//                     backgroundColor: Colors.white,
//                     onSelected: (_) =>
//                         setState(() => selectedSubcategory = sub),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 10),
//           // Grid of product cards
//           Expanded(
//             child: FutureBuilder<List<Map<String, dynamic>>>(
//               future: fetchProducts(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return const Center(child: Text('Error loading products'));
//                 }

//                 final products = snapshot.data ?? [];
//                 final filtered = products.where((product) {
//                   return searchQuery.isEmpty ||
//                       product['name']
//                           .toString()
//                           .toLowerCase()
//                           .contains(searchQuery.toLowerCase());
//                 }).toList();

//                 if (filtered.isEmpty) {
//                   return const Center(child: Text('No products found.'));
//                 }

//                 return GridView.builder(
//                   padding: const EdgeInsets.only(
//                       top: 8, left: 8, right: 8), // removed bottom
//                   itemCount: filtered.length,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 12,
//                     crossAxisSpacing: 12,
//                     childAspectRatio: 0.75, // less tall = less white space
//                   ),
//                   itemBuilder: (context, index) {
//                     final product = filtered[index];
//                     return _buildProductCard(product);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildProductCard(Map<String, dynamic> product) {
//   //   return Container(
//   //     padding: const EdgeInsets.all(8),
//   //     decoration: BoxDecoration(
//   //       color: Colors.white,
//   //       borderRadius: BorderRadius.circular(18),
//   //       boxShadow: const [
//   //         BoxShadow(
//   //           color: Colors.black12,
//   //           blurRadius: 6,
//   //           offset: Offset(0, 4),
//   //         )
//   //       ],
//   //     ),
//   //     child: Column(
//   //       crossAxisAlignment: CrossAxisAlignment.start,
//   //       children: [
//   //         // 📸 Image Placeholder
//   //         Container(
//   //           height: 100,
//   //           width: double.infinity,
//   //           decoration: BoxDecoration(
//   //             color: Colors.grey[200],
//   //             borderRadius: BorderRadius.circular(12),
//   //             image: product['imageURL'] != null
//   //                 ? DecorationImage(
//   //                     image: NetworkImage(product['imageURL']),
//   //                     fit: BoxFit.cover,
//   //                   )
//   //                 : null,
//   //           ),
//   //         ),
//   //         const SizedBox(height: 8),
//   //         Text(
//   //           product['name'] ?? 'TITLE DE PRODUIT',
//   //           maxLines: 2,
//   //           overflow: TextOverflow.ellipsis,
//   //           style: const TextStyle(fontWeight: FontWeight.bold),
//   //         ),
//   //         const SizedBox(height: 4),
//   //         Row(
//   //           children: [
//   //             Text(
//   //               '${product['oldPrice']} DH',
//   //               style: const TextStyle(
//   //                 decoration: TextDecoration.lineThrough,
//   //                 color: Colors.red,
//   //                 fontSize: 12,
//   //               ),
//   //             ),
//   //             const SizedBox(width: 6),
//   //             Text(
//   //               '${product['price']} DH',
//   //               style: const TextStyle(
//   //                 color: Colors.black,
//   //                 fontSize: 13,
//   //                 fontWeight: FontWeight.w600,
//   //               ),
//   //             ),
//   //           ],
//   //         ),
//   //         const SizedBox(height: 4),
//   //         Row(
//   //           children: [
//   //             const Icon(Icons.star, color: Colors.orange, size: 16),
//   //             const SizedBox(width: 4),
//   //             Text(
//   //               '${product['rating']?.toStringAsFixed(1) ?? '0.0'}',
//   //               style: const TextStyle(fontSize: 12),
//   //             ),
//   //             const Spacer(),
//   //             CircleAvatar(
//   //               radius: 12,
//   //               backgroundColor: kAccent,
//   //               child: const Icon(Icons.add, size: 16, color: Colors.white),
//   //             ),
//   //           ],
//   //         ),
//   //       ],
//   //     ),
//   //   );
//   // }
//   Widget _buildProductCard(Map<String, dynamic> product) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => ProductDetailScreen(product: product),
//           ),
//         );
//       },
//       // child: ProductCard(
//       //   name: product['name'] ?? '',
//       //   price: '${product['price']} DH',
//       //   oldPrice: '${product['oldPrice']} DH',
//       //   imagePath: product['imageURL'] ?? '',
//       //   rating: product['rating']?.toDouble() ?? 0.0,
//       // ),
//       child: ProductCard(product: product),
//     );
//   }
// }

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String selectedSubcategory = 'ALL';
  String searchQuery = '';

  List<String> subcategories = ['ALL'];
  bool isLoadingSubcategories = true;
  String? subcategoriesError;

  List<Map<String, dynamic>> allCategoryProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProductsAndSubcategories();
  }

  Future<void> fetchProductsAndSubcategories() async {
    setState(() {
      isLoadingSubcategories = true;
      subcategoriesError = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: widget.category)
          .get();

      allCategoryProducts = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      // Extract unique subcategories from products dynamically
      final subsSet = <String>{};
      for (var product in allCategoryProducts) {
        if (product['subcategory'] != null) {
          subsSet.add(product['subcategory'].toString());
        }
      }

      setState(() {
        subcategories = ['ALL', ...subsSet.toList()];
        isLoadingSubcategories = false;

        // Reset selected subcategory if not in new list
        if (!subcategories.contains(selectedSubcategory)) {
          selectedSubcategory = 'ALL';
        }
      });
    } catch (e) {
      setState(() {
        subcategoriesError = 'Failed to load subcategories';
        isLoadingSubcategories = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchFilteredProducts() async {
    // If "ALL" is selected, return all loaded products from cache,
    // otherwise filter them locally (no new Firestore fetch needed)
    if (selectedSubcategory == 'ALL') {
      return allCategoryProducts;
    } else {
      return allCategoryProducts
          .where((prod) =>
              prod['subcategory'] != null &&
              prod['subcategory'] == selectedSubcategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            hintText: 'search for product . . .',
            prefixIcon: const Icon(Icons.search, color: Colors.black54),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          if (isLoadingSubcategories)
            const Center(child: CircularProgressIndicator())
          else if (subcategoriesError != null)
            Center(child: Text(subcategoriesError!))
          else
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subcategories.length,
                itemBuilder: (context, index) {
                  final sub = subcategories[index];
                  final isSelected = sub == selectedSubcategory;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: ChoiceChip(
                      label: Text(sub),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      selected: isSelected,
                      selectedColor: Colors.black,
                      backgroundColor: Colors.white,
                      onSelected: (_) => setState(() {
                        selectedSubcategory = sub;
                      }),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchFilteredProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading products'));
                }

                final products = snapshot.data ?? [];
                final filtered = products.where((product) {
                  final productName =
                      product['name']?.toString().toLowerCase() ?? '';
                  return searchQuery.isEmpty ||
                      productName.contains(searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: ProductCard(product: product),
    );
  }
}
