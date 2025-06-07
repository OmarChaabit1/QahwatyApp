import 'package:cloud_firestore/cloud_firestore.dart';
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

  Widget _buildSectionTitle(String title, BuildContext context) {
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

  Widget _buildListTile({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
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

  Widget _buildUserHeader(BuildContext context) {
    if (currentUser == null) return const SizedBox.shrink();

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        String? photoUrl;
        bool isValidUrl = false;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>?;
          photoUrl = data?['photoUrl'] as String?;
          isValidUrl = photoUrl != null && photoUrl.startsWith('http');
        }

        return UserAccountsDrawerHeader(
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
            radius: 60,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: isValidUrl
                  ? Image.network(
                      photoUrl!,
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.broken_image,
                        color: Colors.grey.withOpacity(0.6),
                        size: 60,
                      ),
                    )
                  : Image.asset(
                      'images/download.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          decoration: const BoxDecoration(color: Color(0xFFF0DDC9)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            _buildUserHeader(context),
            _buildSectionTitle('Navigation', context),
            _buildListTile(
              context: context,
              title: 'Home',
              icon: Icons.home,
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute),
            ),
            _buildListTile(
              context: context,
              title: 'Dashboard',
              icon: Icons.dashboard,
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute),
            ),
            _buildListTile(
              context: context,
              title: 'Notifications',
              icon: Icons.notifications,
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(NotificationScreen.screenRoute),
            ),
            const Divider(),
            _buildSectionTitle('Account', context),
            _buildListTile(
              context: context,
              title: 'Profile',
              icon: Icons.person,
              onTap: () => Navigator.pushNamed(
                context,
                ProfileScreen.screenRoute,
                arguments: true,
              ),
            ),
            _buildListTile(
              context: context,
              title: 'Help',
              icon: Icons.help_outline,
              onTap: () => Navigator.of(context)
                  .pushReplacementNamed(HelpScreen.screenRoute),
            ),
            _buildListTile(
              context: context,
              title: 'Log out',
              icon: Icons.exit_to_app,
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushReplacementNamed(WelcomeScreen.screenRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
