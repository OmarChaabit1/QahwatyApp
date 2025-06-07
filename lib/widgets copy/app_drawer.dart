import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messages_apk/screens/auth/Welcome_screen.dart';
import 'package:messages_apk/screens/notification_screen.dart';
import 'package:messages_apk/screens/profile/profile_details/help_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/tabs_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Widget buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildListTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
      child: ListTile(
        leading: Icon(icon, size: 26, color: const Color(0xFFF0DDC9)),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'ElMessiri',
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                currentUser?.displayName ?? 'Full Name',
                style: const TextStyle(
                  fontFamily: 'ElMessiri',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF71503C),
                ),
              ),
              accountEmail: Text(
                currentUser?.email ?? 'Email',
                style: const TextStyle(
                  fontFamily: 'ElMessiri',
                  color: Color(0xFF333333),
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    'images/download.png',
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFFF0DDC9),
              ),
            ),
            buildSectionTitle('Navigation', context),
            buildListTile(context, 'Home', Icons.home, () {
              Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute);
            }),
            buildListTile(context, 'Dashboard', Icons.dashboard, () {
              Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute);
            }),
            buildListTile(context, 'Notifications', Icons.notifications, () {
              Navigator.of(context)
                  .pushReplacementNamed(NotificationScreen.screenRoute);
            }),
            const Divider(),
            buildSectionTitle('Account', context),
            buildListTile(context, 'Profile', Icons.person, () {
              Navigator.pushNamed(
                context,
                ProfileScreen.screenRoute,
                arguments: true,
              );
            }),
            buildListTile(context, 'Help', Icons.help_outline, () {
              Navigator.of(context)
                  .pushReplacementNamed(HelpScreen.screenRoute);
            }),
            buildListTile(context, 'Log out', Icons.exit_to_app, () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushReplacementNamed(WelcomeScreen.screenRoute);
            }),
          ],
        ),
      ),
    );
  }
}
