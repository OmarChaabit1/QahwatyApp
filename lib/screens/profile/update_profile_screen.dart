import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String screenRoute = 'update_profile_screen';
  final User currentUser;

  UpdateProfileScreen({Key? key, required this.currentUser}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late User currentUser;
  late String newName = '';
  late String newEmail = '';
  late String newPassword = '';

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  Future<void> updateProfile() async {
    try {
      // Update user's display name
      if (newName.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
      }

      // Update user's email
      if (newEmail.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
      }

      // Update user's password
      if (newPassword.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updatePassword(newPassword);
      }

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
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
            icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10),
              SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset(
                      'images/download.png', // Vérifiez le chemin exact
                      width: 90,
                      height: 90,
                      fit: BoxFit
                          .cover, // Ajustez l'image dans l'espace disponible
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    newName = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(LineAwesomeIcons.user),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 113, 8, 134),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    newEmail = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(LineAwesomeIcons.envelope),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 113, 8, 134),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    newPassword = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(LineAwesomeIcons.fingerprint_solid),
                ),
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 113, 8, 134),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    updateProfile();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 113, 8, 134),
                    side: BorderSide.none,
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    'Update Profile',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
