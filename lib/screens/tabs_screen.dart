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

class TabsScreen extends StatefulWidget {
  static const String screenRoute = 'tabs_screen';

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedScreenIndex = 0;
  List<Map<String, Object>> _screens = [];
  bool isAdmin = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    checkIfAdmin();
  }

  Future<void> checkIfAdmin() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && user.email == 'admin@gmail.com') {
      isAdmin = true;
    }

    _screens = [
      {'Screen': HomeScreen(), 'Title': 'Home'},
      {'Screen': FavoritesScreen(), 'Title': 'Favorites'},
      {'Screen': CartScreen(), 'Title': 'Shop'},
      {'Screen': Placeholder(), 'Title': 'WhatsApp'},
      {'Screen': ProfileScreen(currentUser: user!), 'Title': 'Profile'},
    ];

    if (isAdmin) {
      _screens.add({'Screen': DashboardScreen(), 'Title': 'Dashboard'});
    }

    setState(() {
      isLoading = false;
    });
  }

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      drawer: AppDrawer(),
      body: _screens[_selectedScreenIndex]['Screen'] as Widget,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('WhatsApp button pressed');
        },
        backgroundColor: Colors.green,
        child: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.whatsapp,
            size: 32,
            color: Colors.white,
          ),
          onPressed: () async {
            final Uri whatsappUrl =
                Uri.parse("https://wa.me/0646355386"); // your number
            if (await canLaunchUrl(whatsappUrl)) {
              await launchUrl(whatsappUrl);
            } else {
              print("Could not launch $whatsappUrl");
            }
          },
        ),
        elevation: 5,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  Icons.favorite_border,
                  size: 32,
                  color: _selectedScreenIndex == 1 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(1),
              ),
              const SizedBox(width: 40), // space for FAB
              IconButton(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  size: 32,
                  color: _selectedScreenIndex == 2 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(2),
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  size: 32,
                  color: _selectedScreenIndex == 4 ? Colors.black : Colors.grey,
                ),
                onPressed: () => _selectScreen(4),
              ),
              if (isAdmin)
                IconButton(
                  icon: Icon(
                    Icons.dashboard,
                    size: 32,
                    color:
                        _selectedScreenIndex == 5 ? Colors.black : Colors.grey,
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
