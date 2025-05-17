import 'package:flutter/material.dart';
import 'package:messages_apk/shared/widgets/ProductCard.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String category;
  const CategoryProductsScreen({super.key, required this.category});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  String selectedSubcategory = 'ALL';
  String searchQuery = '';

  // ------------ demo data ------------
  Map<String, List<String>> subcategoriesMap = {
    'COFFEE': ['ALL', 'EN GRAIN', 'SACHET', 'CAPSUL'],
    'TEA': ['ALL', 'EN GRAIN', 'SACHET', 'VERVEINE'],
    'CHOCOLAT': ['ALL', 'MORCEAUX', 'SACHET', 'DIABETIQUE'],
    'SUGAR': ['ALL', 'POUDRE', 'LIQUIDE', 'MATERIAL'],
    'GOBELETS': ['ALL', 'PETITE', 'MOYENE', 'GRAND'],
  };

  List<Map<String, dynamic>> _getProducts(String category) {
    switch (category) {
      // ------------------------------------------------ COFFEE
      case 'COFFEE':
        return [
          {
            'name': 'Jacques Vabre Classic',
            'price': '99.00 DH',
            'oldPrice': '115.00 DH',
            'rating': 9.2,
            'subcategory': 'SACHET',
            'image': 'images/categories/coffee.png',
          },
          {
            'name': 'Golden Vabre Arabica',
            'price': '89.00 DH',
            'oldPrice': '105.00 DH',
            'rating': 9.0,
            'subcategory': 'EN GRAIN',
            'image': 'images/categories/coffee.png',
          },
          {
            'name': 'Espresso Caps Intenso',
            'price': '69.00 DH',
            'oldPrice': '80.00 DH',
            'rating': 8.8,
            'subcategory': 'CAPSUL',
            'image': 'images/categories/coffee.png',
          },
          {
            'name': 'Café Mokka Moulu',
            'price': '79.00 DH',
            'oldPrice': '92.00 DH',
            'rating': 9.1,
            'subcategory': 'SACHET',
            'image': 'images/categories/coffee.png',
          },
        ];

      // ------------------------------------------------ TEA
      case 'TEA':
        return [
          {
            'name': 'Green Tea Verveine',
            'price': '45.00 DH',
            'oldPrice': '55.00 DH',
            'rating': 8.6,
            'subcategory': 'VERVEINE',
            'image': 'images/categories/tea.png',
          },
          {
            'name': 'Black Tea Classic',
            'price': '38.00 DH',
            'oldPrice': '45.00 DH',
            'rating': 8.4,
            'subcategory': 'SACHET',
            'image': 'images/categories/tea.png',
          },
          {
            'name': 'Premium Tea Leaves',
            'price': '52.00 DH',
            'oldPrice': '60.00 DH',
            'rating': 8.9,
            'subcategory': 'EN GRAIN',
            'image': 'images/categories/tea.png',
          },
        ];

      // ------------------------------------------------ CHOCOLAT
      case 'CHOCOLAT':
        return [
          {
            'name': 'Choco Mix Morceaux',
            'price': '59.00 DH',
            'oldPrice': '70.00 DH',
            'rating': 9.0,
            'subcategory': 'MORCEAUX',
            'image': 'images/categories/chocolate.png',
          },
          {
            'name': 'Instant Choco Sachet',
            'price': '48.00 DH',
            'oldPrice': '56.00 DH',
            'rating': 8.7,
            'subcategory': 'SACHET',
            'image': 'images/categories/chocolate.png',
          },
          {
            'name': 'Choco Slim Diabétique',
            'price': '62.00 DH',
            'oldPrice': '75.00 DH',
            'rating': 8.9,
            'subcategory': 'DIABETIQUE',
            'image': 'images/categories/chocolate.png',
          },
        ];

      // ------------------------------------------------ SUGAR
      case 'SUGAR':
        return [
          {
            'name': 'Sucre Poudre 1 kg',
            'price': '19.00 DH',
            'oldPrice': '24.00 DH',
            'rating': 9.1,
            'subcategory': 'POUDRE',
            'image': 'images/categories/sugar.png',
          },
          {
            'name': 'Sucre Liquide 500 ml',
            'price': '22.00 DH',
            'oldPrice': '27.00 DH',
            'rating': 8.5,
            'subcategory': 'LIQUIDE',
            'image': 'images/categories/sugar.png',
          },
          {
            'name': 'Sugar Sticks 100 pcs',
            'price': '30.00 DH',
            'oldPrice': '35.00 DH',
            'rating': 8.8,
            'subcategory': 'MATERIAL',
            'image': 'images/categories/sugar.png',
          },
        ];

      // ------------------------------------------------ GOBELETS
      case 'GOBELETS':
        return [
          {
            'name': 'Gobelets Petit (100 pcs)',
            'price': '25.00 DH',
            'oldPrice': '30.00 DH',
            'rating': 8.3,
            'subcategory': 'PETITE',
            'image': 'images/categories/goblets.png',
          },
          {
            'name': 'Gobelets Moyen (100 pcs)',
            'price': '32.00 DH',
            'oldPrice': '38.00 DH',
            'rating': 8.6,
            'subcategory': 'MOYENE',
            'image': 'images/categories/goblets.png',
          },
          {
            'name': 'Gobelets Grand (100 pcs)',
            'price': '39.00 DH',
            'oldPrice': '46.00 DH',
            'rating': 8.9,
            'subcategory': 'GRAND',
            'image': 'images/categories/goblets.png',
          },
        ];

      // ------------------------------------------------ default
      default:
        return [];
    }
  }

  // -----------------------------------

  @override
  Widget build(BuildContext context) {
    final categoryKey = widget.category.toUpperCase();
    final allProducts = _getProducts(categoryKey);
    final subcats = subcategoriesMap[categoryKey] ?? ['ALL'];

    // filter by sub-category and search text
    final products = allProducts.where((p) {
      final subcatOK = selectedSubcategory == 'ALL' ||
          p['subcategory'] == selectedSubcategory;
      final searchOK = p['name']
          .toString()
          .toLowerCase()
          .contains(searchQuery.toLowerCase());
      return subcatOK && searchOK;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          // ---------- Header (back + search) ----------
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFEF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (txt) {
                          setState(() => searchQuery = txt);
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          hintText: 'search for product…',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {}, // optional action
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ---------- Sub-category chips ----------
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: subcats.map((sub) {
                final sel = sub == selectedSubcategory;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                  child: ChoiceChip(
                    label: Text(sub),
                    selected: sel,
                    selectedColor: Colors.brown[300],
                    onSelected: (_) =>
                        setState(() => selectedSubcategory = sub),
                  ),
                );
              }).toList(),
            ),
          ),
          // ---------- Products grid ----------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: products.isEmpty
                  ? const Center(child: Text('No products found.'))
                  : GridView.builder(
                      itemCount: products.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (_, i) {
                        final p = products[i];
                        return ProductCard(
                          name: p['name'],
                          price: p['price'],
                          oldPrice: p['oldPrice'],
                          rating: p['rating'],
                          imagePath: p['image'],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
