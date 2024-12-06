import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/chat_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/dashboard_screen.dart';
import 'package:messages_apk/widgets%20copy/app_drawer.dart';

// import 'dart:core';
class TabsScreen extends StatefulWidget {
  // const TabsScreen({super.key});
  static const String screenRoute = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  int _selectedScreenIndex = 0;

  late List<Map<String, Object>> _screens;

  @override
  void initState() {
    _screens = [
      {
        'Screen': dashboardScreen(),
        'Title': 'Home',
      },
      {
        'Screen': chatScreen(),
        'Title': 'Messsages',
      },
      {
        'Screen':
            ProfileScreen(currentUser: FirebaseAuth.instance.currentUser!),
        'Title': 'Profile',
      },
    ];
    super.initState();
  }
  // final List<Map<String, Object>> _screens = [
  //   {
  //     'Screen': CategoriesScreen(),
  //     'Title': 'Workout Categories',
  //   },
  //   {
  //     'Screen': FavoritesScreen(widget.favoriteWorkouts),
  //     'Title': 'Favorite Workouts',
  //   },
  // ];

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white,
        currentIndex: _selectedScreenIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
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
