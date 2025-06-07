import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String screenRoute = 'update_profile_screen';
  final fb_auth.User currentUser;
  const UpdateProfileScreen({super.key, required this.currentUser});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  late fb_auth.User currentUser;
  String newName = '';
  String newEmail = '';
  String newPassword = '';
  String? photoUrl;

  File? _pickedImage;
  Uint8List? selectedImageBytes;
  String? currentImageUrl;

  // Colors reused from profile screen
  final Color kBg = const Color(0xFFF0DDC9);
  final Color kHdr = const Color(0xFF333333);
  final Color kPrim = const Color(0xFF71503C);

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    currentUser = widget.currentUser;
    newName = currentUser.displayName ?? '';
    newEmail = currentUser.email ?? '';
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    if (doc.exists) {
      final data = doc.data()!;
      setState(() {
        photoUrl = data['photoUrl'] as String?;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (picked != null) {
      final bytes = await picked.readAsBytes(); // ⬅️ Convert to Uint8List
      setState(() {
        _pickedImage = File(picked.path);
        selectedImageBytes = bytes;
      });
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
    ));
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ));
  }

  Future<void> _updateProfile() async {
    setState(() {
      _loading = true;
    });

    final supabase = Supabase.instance.client;

    String? imageUrlToSave = currentImageUrl;

    // Upload new image only if a new image is selected
    if (selectedImageBytes != null && selectedImageBytes!.isNotEmpty) {
      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final filePath = 'profile_images/$fileName';

        final uploadResult =
            await supabase.storage.from('qahwaty').uploadBinary(
                  filePath,
                  selectedImageBytes!,
                  fileOptions: const FileOptions(
                    contentType: 'image/png',
                    upsert: true,
                  ),
                );

        if (uploadResult.isEmpty) {
          throw Exception('Upload failed or returned an empty result.');
        }

        imageUrlToSave =
            supabase.storage.from('qahwaty').getPublicUrl(filePath);
      } catch (e) {
        showError('Image upload failed.');
        return;
      }
    }

    // Update FirebaseAuth profile
    if (newName.isNotEmpty && newName != currentUser.displayName) {
      await currentUser.updateDisplayName(newName.trim());
    }
    if (newEmail.isNotEmpty && newEmail != currentUser.email) {
      await currentUser.updateEmail(newEmail.trim());
    }
    if (newPassword.isNotEmpty) {
      await currentUser.updatePassword(newPassword.trim());
    }
    try {
      // Update Firestore user document
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'displayName': newName.trim(),
        'email': newEmail.trim(),
        'photoUrl': imageUrlToSave ?? '',
      });
      showSuccess('Product updated!');
      Navigator.pop(context); // Close form after update
    } catch (e) {
      showError('Failed to update product.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayImage = _pickedImage != null
        ? Image.file(_pickedImage!, fit: BoxFit.cover)
        : (photoUrl != null && photoUrl!.startsWith('http')
            ? Image.network(photoUrl!, fit: BoxFit.cover)
            : Image.asset('images/download.png', fit: BoxFit.cover));

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // avatar --------------------------------------------------
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: SizedBox(
                                width: 110, height: 110, child: displayImage),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(Icons.camera_alt,
                                  size: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // text fields ---------------------------------------------
                    _Field(
                      hint: 'Full name',
                      icon: Icons.person,
                      onChanged: (v) => newName = v,
                      initialText: newName,
                    ),
                    _Field(
                      hint: 'Email',
                      icon: Icons.email_outlined,
                      onChanged: (v) => newEmail = v,
                      keyboardType: TextInputType.emailAddress,
                      initialText: newEmail,
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
