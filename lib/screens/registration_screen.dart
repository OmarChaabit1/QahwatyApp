import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class registrationScreen extends StatefulWidget {
  static const String screenRoute = 'registration_screen';

  @override
  _registrationScreenState createState() => _registrationScreenState();
}

class _registrationScreenState extends State<registrationScreen> {
  final _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  late String email, password, fullName;
  bool showSpinner = false;
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No image selected.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to pick image: $e")),
      );
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    if (_imageFile == null) return null;

    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('profile_images/$userId.jpg');
      await storageRef.putFile(_imageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to upload image: $e")),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!)
                      : AssetImage('images/messageMe.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) => email = value,
                decoration: InputDecoration(hintText: "Enter your email"),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => password = value,
                obscureText: true,
                decoration: InputDecoration(hintText: "Enter your password"),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => fullName = value,
                decoration: InputDecoration(hintText: "Enter your full name"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (email.isEmpty ||
                      password.isEmpty ||
                      fullName.isEmpty ||
                      _imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please complete all fields.")),
                    );
                    return;
                  }

                  setState(() => showSpinner = true);

                  try {
                    final userCredential =
                        await _auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    final imageUrl =
                        await _uploadProfileImage(userCredential.user!.uid);

                    if (imageUrl != null) {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userCredential.user!.uid)
                          .set({
                        'email': email,
                        'fullName': fullName,
                        'profileImageUrl': imageUrl,
                      });
                      Navigator.pushReplacementNamed(
                          context, 'signInScreen'); // Replace with your route
                    } else {
                      throw "Image upload failed.";
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Registration failed: $e")),
                    );
                  } finally {
                    setState(() => showSpinner = false);
                  }
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
