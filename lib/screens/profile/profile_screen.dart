// -------------  profile_screen.dart -------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/auth/Welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';
  final User currentUser;
  const ProfileScreen({super.key, required this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  Future<String?> fetchProfileImage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref('profile_images/${currentUser.uid}.jpg');
      return await ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  // ---------- COLORS used in the mock-up ----------
  final Color kBg = const Color(0xFFF0DDC9); // beige background
  final Color kIcon = const Color(0xFF333333); // dark icons
  final Color kText = const Color(0xFF1F1F1F); // dark text
  // ------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // allow optional AppBar only when pushed from another screen
    showAppBar = (ModalRoute.of(context)?.settings.arguments as bool?) ?? false;

    return Scaffold(
      backgroundColor: kBg,
      appBar: showAppBar
          ? AppBar(
              backgroundColor: kBg,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                color: kIcon,
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.black87),
                  onPressed: () {},
                ),
              ],
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // -------- avatar ----------
              const SizedBox(height: 12),
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: FutureBuilder<String?>(
                    future: fetchProfileImage(),
                    builder: (_, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      final img = snap.data;
                      return Image(
                        image: img != null
                            ? NetworkImage(img)
                            : const AssetImage('images/download.png')
                                as ImageProvider,
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // -------- name ----------
              Text(
                currentUser.displayName ?? 'User',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 25),

              // -------- Edit profile row ----------
              _ProfileRow(
                title: 'Edit profile',
                icon: Icons.edit,
                iconColor: Colors.green,
                onTap: () => Navigator.pushNamed(
                    context, UpdateProfileScreen.screenRoute),
              ),

              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('General Settings',
                    style: TextStyle(
                        color: kText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16)),
              ),
              const SizedBox(height: 6),

              _ProfileRow(
                  title: 'Language',
                  icon: Icons.language,
                  iconColor: Colors.orange,
                  onTap: () {}),
              _ProfileRow(
                  title: 'About',
                  icon: Icons.help_outline,
                  iconColor: Colors.purple.shade300,
                  onTap: () {}),
              _ProfileRow(
                  title: 'Terms & Conditions',
                  icon: Icons.info,
                  iconColor: Colors.blue,
                  onTap: () {}),
              _ProfileRow(
                  title: 'Privacy Policy',
                  icon: Icons.lock_outline,
                  iconColor: Colors.red,
                  onTap: () {}),
              _ProfileRow(
                  title: 'Rate This App',
                  icon: Icons.star_border,
                  iconColor: Colors.deepPurple,
                  onTap: () {}),
              _ProfileRow(
                  title: 'Share This App',
                  icon: Icons.share_outlined,
                  iconColor: Colors.pink,
                  onTap: () {}),

              const SizedBox(height: 12),
              // -------- Logout -----------
              _ProfileRow(
                title: 'Log-out',
                icon: Icons.logout,
                iconColor: Colors.red,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(
                      context, WelcomeScreen.screenRoute);
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// =============== reusable row widget ===============
class _ProfileRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ProfileRow(
      {required this.title,
      required this.icon,
      required this.iconColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(.15),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
