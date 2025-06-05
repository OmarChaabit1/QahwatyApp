import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:messages_apk/screens/Home_screen.dart';
import 'package:messages_apk/screens/adminPannel/screens/dashboard_screen.dart';
import 'package:messages_apk/screens/card/card_screen.dart';
import 'package:messages_apk/screens/card/favorites_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/widgets copy/app_drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For badge counts

class TabsScreen extends StatefulWidget {
  static const String screenRoute = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;
  List<Map<String, dynamic>> _screens = [];
  bool isAdmin = false;
  bool isLoading = true;

  int _cartCount = 0;
  int _favoritesCount = 0;

  Timer? _badgeUpdateTimer;

  @override
  void initState() {
    super.initState();
    initializeTabs();
    _loadCounts();

    // Start periodic timer to refresh badge counts every 2 seconds
    _badgeUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _loadCounts();
    });
  }

  @override
  void dispose() {
    _badgeUpdateTimer?.cancel();
    super.dispose();
  }

  Future<void> initializeTabs() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == 'admin@gmail.com') {
      isAdmin = true;
    }

    if (user != null) {
      _screens = [
        {'Screen': HomeScreen(), 'Title': 'Home'},
        {'Screen': Placeholder(), 'Title': 'WhatsApp'},
        {'Screen': ProfileScreen(currentUser: user), 'Title': 'Profile'},
      ];

      if (!isAdmin) {
        _screens.insert(1, {'Screen': FavoritesScreen(), 'Title': 'Favorites'});
        _screens.insert(2, {'Screen': CartScreen(), 'Title': 'Shop'});
      } else {
        _screens.add({'Screen': DashboardScreen(), 'Title': 'Dashboard'});
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadCounts() async {
    final prefs = await SharedPreferences.getInstance();

    int newCartCount = 0;
    int newFavoritesCount = 0;

    // Load cart items count
    final cartString = prefs.getString('cart');
    if (cartString != null && cartString.isNotEmpty) {
      try {
        final List<dynamic> cartList = jsonDecode(cartString);
        for (var item in cartList) {
          newCartCount += (item['quantity'] ?? 0) as int;
        }
      } catch (e) {
        // ignore JSON parse errors
      }
    }

    // Load favorites count
    final favString = prefs.getString('favorites');
    if (favString != null && favString.isNotEmpty) {
      try {
        final List<dynamic> favList = jsonDecode(favString);
        newFavoritesCount = favList.length;
      } catch (e) {
        // ignore JSON parse errors
      }
    }

    if (mounted) {
      if (newCartCount != _cartCount || newFavoritesCount != _favoritesCount) {
        setState(() {
          _cartCount = newCartCount;
          _favoritesCount = newFavoritesCount;
        });
      }
    }
  }

  void _selectScreen(int index) {
    if (index < _screens.length) {
      setState(() {
        _selectedScreenIndex = index;
      });
    }
  }

  Widget _buildIconWithBadge(Icon icon, int count) {
    if (count == 0) return icon;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        icon,
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              count > 99 ? '99+' : '$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      drawer: AppDrawer(),
      body: _screens[_selectedScreenIndex]['Screen'] as Widget,
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFFF5EDE4),
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: _buildIconWithBadge(
                  const Icon(Icons.home, size: 28),
                  0,
                ),
                color: _selectedScreenIndex == 0 ? Colors.black : Colors.grey,
                onPressed: () => _selectScreen(0),
              ),
              if (!isAdmin) ...[
                IconButton(
                  icon: _buildIconWithBadge(
                    const Icon(Icons.favorite_border, size: 28),
                    _favoritesCount,
                  ),
                  color: _selectedScreenIndex == 1 ? Colors.black : Colors.grey,
                  onPressed: () => _selectScreen(1),
                ),
                // WhatsApp icon centered
                _buildWhatsAppButton(),
                IconButton(
                  icon: _buildIconWithBadge(
                    const Icon(Icons.shopping_cart_outlined, size: 28),
                    _cartCount,
                  ),
                  color: _selectedScreenIndex == 2 ? Colors.black : Colors.grey,
                  onPressed: () => _selectScreen(2),
                ),
                IconButton(
                  icon: const Icon(Icons.person, size: 28),
                  color: _selectedScreenIndex == 4 ? Colors.black : Colors.grey,
                  onPressed: () => _selectScreen(4),
                ),
              ] else ...[
                const SizedBox(width: 20),
                _buildWhatsAppButton(),
                IconButton(
                  icon: const Icon(Icons.person, size: 28),
                  color: _selectedScreenIndex == 2 ? Colors.black : Colors.grey,
                  onPressed: () => _selectScreen(2),
                ),
                IconButton(
                  icon: const Icon(Icons.dashboard, size: 28),
                  color: _selectedScreenIndex == 3 ? Colors.black : Colors.grey,
                  onPressed: () => _selectScreen(3),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhatsAppButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: IconButton(
        icon: const FaIcon(FontAwesomeIcons.whatsapp,
            color: Colors.white, size: 38),
        onPressed: () async {
          final Uri whatsappUrl = Uri.parse("https://wa.me/0646355386");
          if (await canLaunchUrl(whatsappUrl)) {
            await launchUrl(whatsappUrl);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Could not launch WhatsApp")),
            );
          }
        },
      ),
    );
  }
}
