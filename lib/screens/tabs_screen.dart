import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/Home_screen.dart';
import 'package:messages_apk/screens/admin/admin_panel_screen.dart';
import 'package:messages_apk/screens/adminPannel/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/notification_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/thank_you_screen.dart';
import 'package:messages_apk/widgets copy/app_drawer.dart';

class TabsScreen extends StatefulWidget {
  static const String screenRoute = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;

  late List<Map<String, Object>> _screens;

  @override
  void initState() {
    _screens = [
      {
        'Screen': HomeScreen(),
        'Title': 'Home',
      },
      {
        'Screen': NotificationScreen(),
        'Title': 'Notifications',
      },
      // {
      //   'Screen': const dashboardScreen(),
      //   'Title': 'Dashboard',
      // },
      {
        'Screen': ThankYouScreen(),
        'Title': 'Thank You',
      },
      {
        'Screen': Placeholder(), // WhatsApp button placeholder
        'Title': 'WhatsApp',
      },
      {
        'Screen':
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        'Title': 'Profile',
      },
      {
        'Screen': DashboardScreen(),
        'Title': 'Dashboard',
      },
    ];
    super.initState();
  }

  void _selectScreen(int index) {
    if (index == 3) {
      // Open WhatsApp or handle action
      // For now, just skip updating the screen
      print('WhatsApp button pressed');
    } else {
      setState(() {
        _selectedScreenIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      // appBar: AppBar(
      //   title: Text(_screens[_selectedScreenIndex]['Title'] as String),
      // ),
      body: _screens[_selectedScreenIndex]['Screen'] as Widget,

      // Floating WhatsApp Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _selectScreen(3);
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.whatshot_sharp, size: 30),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Curved Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: const Color(0xFFF5EDE4),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.home,
                  size: 32,
                  color: _selectedScreenIndex == 0 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(0),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 32,
                  color: _selectedScreenIndex == 1 ? Colors.black : Colors.grey,
                ),
                onPressed: () {
                  _selectScreen(1);
                },
              ),
              const SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 32,
                  color: _selectedScreenIndex == 2 ? Colors.black : Colors.grey,
                ),
                iconSize: 32,
                onPressed: () {
                  _selectScreen(2);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 32,
                  color: _selectedScreenIndex == 4 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(4),
              ),
              IconButton(
                icon: Icon(
                  Icons.dashboard,
                  size: 32,
                  color: _selectedScreenIndex == 5 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
