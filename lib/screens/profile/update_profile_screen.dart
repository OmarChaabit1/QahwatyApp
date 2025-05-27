// ----------------  update_profile_screen.dart  ----------------
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String screenRoute = 'update_profile_screen';
  final User currentUser;
  const UpdateProfileScreen({super.key, required this.currentUser});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late User currentUser;
  String newName = '';
  String newEmail = '';
  String newPassword = '';

  // colors reused from profile screen
  final Color kBg = const Color(0xFFF0DDC9);
  final Color kHdr = const Color(0xFF333333);
  final Color kPrim = const Color(0xFF71503C); // brown-ish accent

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
  }

  Future<void> _updateProfile() async {
    try {
      if (newName.isNotEmpty) {
        await currentUser.updateDisplayName(newName.trim());
      }
      // if (newEmail.isNotEmpty) {
      //   await currentUser.updateEmail(newEmail.trim());
      // }
      if (newPassword.isNotEmpty) {
        await currentUser.updatePassword(newPassword.trim());
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Edit Profile', style: TextStyle(color: Colors.black87)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // avatar --------------------------------------------------
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    'images/download.png',
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // text fields ---------------------------------------------
              _Field(
                hint: 'Full name',
                icon: Icons.person,
                onChanged: (v) => newName = v,
                initialText: currentUser.displayName ?? '',
              ),
              _Field(
                hint: 'Email',
                icon: Icons.email_outlined,
                onChanged: (v) => newEmail = v,
                keyboardType: TextInputType.emailAddress,
                initialText: currentUser.email ?? '',
              ),
              _Field(
                hint: 'Password',
                icon: Icons.lock_outline,
                onChanged: (v) => newPassword = v,
                obscure: true,
              ),
              const SizedBox(height: 30),

              // update button -------------------------------------------
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrim,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: _updateProfile,
                  child: const Text('Update Profile',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- helper styled text-field widget ----------------
class _Field extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String) onChanged;
  final bool obscure;
  final TextInputType? keyboardType;
  final String? initialText;

  const _Field({
    required this.hint,
    required this.icon,
    required this.onChanged,
    this.obscure = false,
    this.keyboardType,
    this.initialText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        initialValue: initialText,
        onChanged: onChanged,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(icon, color: Colors.grey.shade700),
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
