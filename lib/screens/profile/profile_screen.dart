import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import 'package:messages_apk/screens/profile/profile_details/Privacy_screen.dart';
import 'package:messages_apk/screens/profile/profile_details/about_screen.dart';
import 'package:messages_apk/screens/profile/profile_details/rate_app_screen.dart.dart';
import 'package:messages_apk/screens/profile/profile_details/terms_conditions_screen.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/auth/Welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';
  final fb_auth.User currentUser;

  const ProfileScreen({super.key, required this.currentUser});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late fb_auth.User currentUser;

  // Colors used in the UI
  final Color kBg = const Color(0xFFF0DDC9); // beige background
  final Color kIcon = const Color(0xFF333333); // dark icons
  final Color kText = const Color(0xFF1F1F1F); // dark text

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final bool showAppBar =
        (ModalRoute.of(context)?.settings.arguments as bool?) ?? false;

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
              const SizedBox(height: 12),

              // Profile image using StreamBuilder from Firestore 'users' collection
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(currentUser.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.error, size: 60),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    // Show a loading indicator while waiting for data
                    return const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  final photoUrl = userData?['photoUrl'] as String?;
                  final isValidUrl =
                      photoUrl != null && photoUrl.startsWith('http');

                  return Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: isValidUrl
                              ? Image.network(
                                  photoUrl!,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
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
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, UpdateProfileScreen.screenRoute);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // Display user name or fallback
              Text(
                currentUser.displayName ?? 'User',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),

              const SizedBox(height: 25),

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
                  onTap: () {
                    Navigator.pushNamed(context, AboutScreen.screenRoute);
                  }),

              _ProfileRow(
                  title: 'Terms & Conditions',
                  icon: Icons.info,
                  iconColor: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(
                        context, TermsConditionsScreen.screenRoute);
                  }),

              _ProfileRow(
                  title: 'Privacy Policy',
                  icon: Icons.lock_outline,
                  iconColor: Colors.red,
                  onTap: () {
                    Navigator.pushNamed(
                        context, PrivacyPolicyScreen.screenRoute);
                  }),

              _ProfileRow(
                  title: 'Rate This App',
                  icon: Icons.star_border,
                  iconColor: Colors.deepPurple,
                  onTap: () {
                    Navigator.pushNamed(context, RateAppScreen.screenRoute);
                  }),

              _ProfileRow(
                title: 'Share This App',
                icon: Icons.share_outlined,
                iconColor: Colors.pink,
                onTap: () async {
                  const shareText =
                      'Check out this amazing app! Download it here: https://yourapp.link';
                  await Share.share(shareText);

                  toastification.show(
                    context: context,
                    type: ToastificationType.success,
                    title: const Text('Thanks for sharing!'),
                    description: const Text('You’re helping us grow.'),
                    alignment: Alignment.bottomRight,
                    autoCloseDuration: const Duration(seconds: 3),
                  );
                },
              ),

              const SizedBox(height: 12),

              _ProfileRow(
                title: 'Log-out',
                icon: Icons.logout,
                iconColor: Colors.red,
                onTap: () {
                  fb_auth.FirebaseAuth.instance.signOut();
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
