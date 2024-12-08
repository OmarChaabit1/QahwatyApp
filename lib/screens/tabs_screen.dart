import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/chat_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
import 'package:messages_apk/widgets%20copy/app_drawer.dart';

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
        'Screen': const dashboardScreen(),
        'Title': 'Home',
      },
      {
        'Screen': const chatScreen(chatPartnerEmail: ''),
        'Title': 'Messages',
      },
      {
        'Screen':
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        'Title': 'Profile',
      },
    ];
    super.initState();
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]['Title'] as String),
      ),
      body: _screens[_selectedScreenIndex]['Screen'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectScreen,
        backgroundColor: const Color.fromARGB(255, 113, 8, 134),
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Saved Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
