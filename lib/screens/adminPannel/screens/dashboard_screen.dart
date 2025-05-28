import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/Categories/categoriesList_screen.dart';
import 'package:messages_apk/screens/adminPannel/screens/New_Arrivals/new_arrivalListe_scree.dart';
import 'package:messages_apk/screens/adminPannel/screens/Orders/orderingList_screen.dart';
import 'package:messages_apk/screens/adminPannel/screens/Products/productList_scree.dart';
import 'package:messages_apk/screens/adminPannel/screens/SubCategories/all_Subcategories.dart';

final Color kBg = const Color(0xFFF0DDC9); // Light grey-blue background
final Color kText = const Color(0xFF1E1E2C); // Dark navy text
final Color kAccent = const Color(0xFF71503C); // Vivid soft blue
final Color kCardLight =
    const Color.fromARGB(255, 251, 241, 234); // Light card background

class DashboardScreen extends StatefulWidget {
  static const screenRoute = '/admin/dashboard_screen';
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

enum TimeRange { all, lastDay, last3days, last7Days, last30Days, thisMonth }

class _DashboardScreenState extends State<DashboardScreen> {
  // Counts could be fetched dynamically from your backend or Firestore
  String userName = "";
  int productsCount = 0;
  int ordersCount = 0;
  int usersCount = 0;
  int categoriesCount = 0;
  final List<_DashboardItem> items = [];
  TimeRange selectedRange = TimeRange.all;

  @override
  void initState() {
    super.initState();

    items.addAll([
      _DashboardItem(
        title: "Categories",
        icon: Icons.category,
        screen: CategoriesListScreen(),
      ),
      _DashboardItem(
        title: "Products",
        icon: Icons.store,
        screen: ProductlistScree(),
      ),
      _DashboardItem(
        title: "SubCategories",
        icon: Icons.list,
        screen: AllSubCategoriesScreen(),
      ),
      _DashboardItem(
        title: "New Arrivals",
        icon: Icons.new_releases,
        screen: NewArrivalsListScreen(),
      ),
      _DashboardItem(
        title: "Orders",
        icon: Icons.shopping_cart,
        screen: OrdersScreen(),
      ),
    ]);
    fetchDashboardData();
  }

  Timestamp? getTimestampForRange(TimeRange range) {
    final now = DateTime.now();

    switch (range) {
      case TimeRange.lastDay:
        return Timestamp.fromDate(now.subtract(Duration(days: 1)));
      case TimeRange.last3days:
        return Timestamp.fromDate(now.subtract(Duration(days: 3)));
      case TimeRange.last7Days:
        return Timestamp.fromDate(now.subtract(Duration(days: 7)));
      case TimeRange.last30Days:
        return Timestamp.fromDate(now.subtract(Duration(days: 30)));
      case TimeRange.thisMonth:
        final firstDayOfMonth = DateTime(now.year, now.month, 1);
        return Timestamp.fromDate(firstDayOfMonth);
      case TimeRange.all:
      default:
        return null; // No filter
    }
  }

  Future<void> fetchDashboardData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    if (userDoc.exists && userDoc.data()?['role'] == 'admin') {
      setState(() {
        userName = userDoc.data()?['email'] ?? 'Admin';
      });

      final timestampFilter = getTimestampForRange(selectedRange);

      Future<QuerySnapshot> getFilteredCollection(String collectionName) {
        final collectionRef =
            FirebaseFirestore.instance.collection(collectionName);
        if (timestampFilter != null) {
          return collectionRef
              .where('createdAt', isGreaterThanOrEqualTo: timestampFilter)
              .get();
        } else {
          return collectionRef.get();
        }
      }

      final productsSnapshot = await getFilteredCollection('products');
      final ordersSnapshot = await getFilteredCollection('orders');
      final usersSnapshot = await getFilteredCollection('users');
      final categoriesSnapshot = await getFilteredCollection('categories');

      setState(() {
        productsCount = productsSnapshot.size;
        ordersCount = ordersSnapshot.size;
        usersCount = usersSnapshot.size;
        categoriesCount = categoriesSnapshot.size;
      });
    } else {
      setState(() {
        userName = 'User';
      });
    }
  }

  // Call fetchDashboardData whenever time range changes
  void onTimeRangeChanged(TimeRange? newRange) {
    if (newRange != null && newRange != selectedRange) {
      setState(() {
        selectedRange = newRange;
      });
      fetchDashboardData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text("Admin Dashboard",
            style: TextStyle(fontFamily: 'Nunito', color: kText)),
        elevation: 0,
        backgroundColor: kBg,
        centerTitle: true,
        iconTheme: IconThemeData(color: kAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Row - dynamic userName
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WELCOME BACK',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 12,
                        letterSpacing: 1.5,
                        color: kText.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userName, // dynamic user name from Firestore
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: kText,
                      ),
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('images/logo.png'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Filter / time range dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kCardLight,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ],
              ),
              child: DropdownButton<TimeRange>(
                value: selectedRange,
                underline: SizedBox(),
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: kText),
                items: [
                  DropdownMenuItem(
                      value: TimeRange.lastDay, child: Text('Yesterday')),
                  DropdownMenuItem(
                      value: TimeRange.last3days, child: Text('Last 3 Days')),
                  DropdownMenuItem(
                      value: TimeRange.last7Days, child: Text('Last 7 Days')),
                  DropdownMenuItem(
                      value: TimeRange.last30Days, child: Text('Last 30 Days')),
                  DropdownMenuItem(
                      value: TimeRange.thisMonth, child: Text('This Month')),
                  DropdownMenuItem(
                      value: TimeRange.all, child: Text('All Time')),
                ],
                onChanged: onTimeRangeChanged,
                style: TextStyle(
                    fontFamily: 'Nunito', color: kText.withOpacity(0.8)),
              ),
            ),

            const SizedBox(height: 24),
            // Stats cards - dynamic counts
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildStatCard("Total Products", productsCount, Icons.inventory,
                    Colors.greenAccent.withOpacity(0.2)),
                _buildStatCard("Total Orders", ordersCount, Icons.shopping_bag,
                    Colors.blueAccent.withOpacity(0.2)),
                _buildStatCard("Total Users", usersCount, Icons.people,
                    Colors.amberAccent.withOpacity(0.2)),
                _buildStatCard("Categories", categoriesCount, Icons.category,
                    Colors.purpleAccent.withOpacity(0.2)),
              ],
            ),
            const SizedBox(height: 24),
            // Sections title
            Text(
              "Sections",
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kText),
            ),
            const SizedBox(height: 16),
            // Dynamic grid of dashboard sections
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) =>
                  _buildCard(context, items[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, int count, IconData icon, Color bgColor) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: kAccent),
          const SizedBox(height: 8),
          Text("$count",
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kText)),
          Text(title,
              style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 14,
                  color: kText.withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, _DashboardItem item) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => item.screen),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: kCardLight,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(item.icon, color: kAccent, size: 36),
              const SizedBox(height: 8),
              Text(item.title,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: kText)),
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

  _DashboardItem({
    required this.title,
    required this.icon,
    required this.screen,
  });
}
