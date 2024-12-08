import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:messages_apk/screens/profile/update_profile_screen.dart';
import 'package:messages_apk/screens/Welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const String screenRoute = 'profile_screen';
  final User currentUser;

  ProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late User currentUser;
  bool showAppBar = false; // Default to no AppBar

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  Future<String?> fetchProfileImage() async {
    try {
      final ref = FirebaseStorage.instance.ref(
          'profile_images/${currentUser.uid}.jpg'); // Update the path as per your storage structure
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error fetching profile image: $e');
      return null; // Return null if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the argument to decide if AppBar should be shown
    final bool? shouldShowAppBar =
        ModalRoute.of(context)?.settings.arguments as bool?;

    showAppBar = shouldShowAppBar ?? false;

    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var iconColor = isDark ? Colors.black : Colors.white;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(LineAwesomeIcons.angle_left_solid),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                      isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
                ),
              ],
            )
          : null, // Show AppBar only if showAppBar is true
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  child: ClipOval(
                    child: FutureBuilder<String?>(
                      future: fetchProfileImage(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Show loading indicator
                        } else if (snapshot.hasData && snapshot.data != null) {
                          return Image.network(
                            snapshot.data!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Image.asset(
                            'images/download.png', // Default image if no image is found
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                currentUser.displayName ?? 'N/A',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${currentUser.email ?? 'N/A'}',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, UpdateProfileScreen.screenRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 113, 8,
                        134), // Utilisation de la couleur principale du thème
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary, // Couleur du texte sur le bouton
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Divider(color: Color.fromARGB(255, 113, 8, 134).withOpacity(0.2)),
              SizedBox(height: 20),
              profileMenuWidget(
                  title: 'Settings',
                  icon: LineAwesomeIcons.cog_solid,
                  onPress: () {}),
              profileMenuWidget(
                  title: 'Billing Details',
                  icon: LineAwesomeIcons.wallet_solid,
                  onPress: () {}),
              profileMenuWidget(
                  title: 'User Management',
                  icon: LineAwesomeIcons.user_check_solid,
                  onPress: () {}),
              Divider(color: Color.fromARGB(255, 113, 8, 134).withOpacity(0.1)),
              const SizedBox(height: 10),
              profileMenuWidget(
                  title: 'Information',
                  icon: LineAwesomeIcons.info_solid,
                  onPress: () {}),
              profileMenuWidget(
                  title: 'Log-Out',
                  icon: LineAwesomeIcons.sign_out_alt_solid,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(
                        context, WelcomeScreen.screenRoute);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class profileMenuWidget extends StatelessWidget {
  const profileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });
  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color.fromARGB(255, 113, 8, 134).withOpacity(
              0.1), // Utilisation de la couleur principale du thème avec opacité
        ),
        child: Icon(
          icon,
          color: Theme.of(context)
              .primaryColor, // Utilisation de la couleur principale du thème
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.apply(
            color: textColor ?? Theme.of(context).colorScheme.onBackground),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: const Icon(LineAwesomeIcons.angle_right_solid,
                  size: 18, color: Colors.grey))
          : null,
    );
  }
}
