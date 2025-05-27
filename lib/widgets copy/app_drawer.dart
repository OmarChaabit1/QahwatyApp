import 'package:messages_apk/screens/auth/Welcome_screen.dart';
import 'package:messages_apk/screens/notification_screen.dart';
import 'package:messages_apk/screens/profile/help_screen.dart';
import 'package:messages_apk/screens/profile/profile_screen.dart';
import 'package:messages_apk/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({Key? key}) : super(key: key);

  final User? currentUser = FirebaseAuth.instance.currentUser;

  Widget buildListTile(BuildContext context, String title, IconData icon,
      VoidCallback onTapLink) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
        color: Color.fromARGB(
            255, 177, 127, 52), // Utilisation de la couleur principale du thème
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'ElMessiri',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context)
              .colorScheme
              .onBackground,
        ),
      ),
      onTap: onTapLink,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Ajout du UserAccountsDrawerHeader ici
          UserAccountsDrawerHeader(
            accountName: Text(
              currentUser?.displayName ?? 'Full Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'ElMessiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .onPrimary, // Texte en blanc pour cohérence
              ),
            ),
            accountEmail: Text(
              currentUser?.email ?? 'Email',
              style: TextStyle(
                fontFamily: 'ElMessiri',
                fontSize: 18,
                color:
                    Theme.of(context).colorScheme.onPrimary, // Texte en blanc
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
            decoration: BoxDecoration(
              color: Color.fromARGB(
                  255, 177, 127, 52), // Couleur principale du thème
            ),
          ),
          SizedBox(height: 20),
          buildListTile(
            context, // Ajout du context ici
            'Home',
            Icons.home,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute);
            },
          ),
          buildListTile(
            context, // Ajout du context ici
            'Dashboard',
            Icons.dashboard,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(TabsScreen.screenRoute);
            },
          ),
          buildListTile(
            context, // Ajout du context ici
            'Notifications',
            Icons.home,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(NotificationScreen.screenRoute);
            },
          ),
          buildListTile(
            context,
            'Profile',
            Icons.person,
            () {
              Navigator.pushNamed(
                context,
                ProfileScreen.screenRoute,
                arguments: true, // This will signal to show the AppBar
              );
            },
          ),
          buildListTile(
            context, // Ajout du context ici
            'Help',
            Icons.help,
            () {
              Navigator.of(context)
                  .pushReplacementNamed(HelpScreen.screenRoute);
            },
          ),
          buildListTile(
            context, // Ajout du context ici
            'Log out',
            Icons.exit_to_app,
            () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushReplacementNamed(WelcomeScreen.screenRoute);
            },
          ),
        ],
      ),
    );
  }
}
