import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/Categories/categoriesList_screen.dart';
import 'package:messages_apk/screens/adminPannel/screens/New_Arrivals/new_arrivalListe_scree.dart';
import 'package:messages_apk/screens/adminPannel/screens/Orders/orderingList_screen.dart';

import 'Products/productList_scree.dart';
import 'SubCategories/all_Subcategories.dart';

class DashboardScreen extends StatefulWidget {
  static const screenRoute = '/admin/dashboard_screen';
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<_DashboardItem> items = [
    _DashboardItem(
      title: "Categories",
      icon: Icons.category,
      screen: CategoriesListScreen(),
      gradient:
          LinearGradient(colors: [Colors.orange, Colors.deepOrangeAccent]),
    ),
    _DashboardItem(
      title: "Products",
      icon: Icons.store,
      screen: ProductlistScree(),
      gradient: LinearGradient(colors: [Colors.teal, Colors.green]),
    ),
    _DashboardItem(
      title: "SubCategories",
      icon: Icons.store,
      screen: AllSubCategoriesScreen(),
      gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 0, 200, 255), Colors.blueGrey]),
    ),
    _DashboardItem(
      title: "NewArrivals",
      icon: Icons.store,
      screen: NewArrivalsListScreen(),
      gradient: LinearGradient(colors: [
        const Color.fromARGB(255, 206, 156, 228),
        Colors.deepPurple
      ]),
    ),
    _DashboardItem(
      title: "Orders",
      icon: Icons.store,
      screen: OrdersScreen(),
      gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 242, 107, 73), Colors.red]),
    ),
    // Add more items if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        elevation: 0,
        backgroundColor: Color(0xFFF5EDE4),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          return GridView.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildCard(context, item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildCard(BuildContext context, _DashboardItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => item.screen),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: item.gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: Colors.white, size: 50),
              SizedBox(height: 12),
              Text(
                item.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardItem {
  final String title;
  final IconData icon;
  final Widget screen;
  final LinearGradient gradient;

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.screen,
    required this.gradient,
  });
}
