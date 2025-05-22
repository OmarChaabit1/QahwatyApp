import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddCategoryForm extends StatefulWidget {
  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class _AddCategoryFormState extends State<AddCategoryForm> {
  final nameController = TextEditingController();
  final subController = TextEditingController();
  List<String> subcategories = [];

  // hady for the image categoryy
  Uint8List? selectedImageBytes;
  String? imageUrl;
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes;
      });
    }
  }

  // void addCategory() async {
  //   final name = nameController.text.trim();
  //   if (name.isEmpty) {
  //     showError('Please enter a category name.');
  //     return;
  //   }

  //   await FirebaseFirestore.instance.collection('categories').add({
  //     'name': name,
  //     'subcategories': subcategories,
  //   });

  //   nameController.clear();
  //   subController.clear();
  //   setState(() => subcategories.clear());
  //   showSuccess('Category added!');
  // }

  Future<void> addCategory() async {
    final name = nameController.text.trim();

    final supabase = Supabase.instance.client;

    if (selectedImageBytes == null || selectedImageBytes!.isEmpty) {
      showError('Please select a valid image.');
      return;
    }

    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = 'images/$fileName';

      // ✅ Upload to Supabase Storage
      final uploadResult = await supabase.storage.from('qahwaty').uploadBinary(
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

      // ✅ Get public URL
      final publicUrl = supabase.storage.from('qahwaty').getPublicUrl(filePath);

      // ✅ Insert into Firebase Firestore
      await FirebaseFirestore.instance.collection('categories').add({
        'name': name,
        'subcategories': subcategories,
        'imageUrl': publicUrl,
        'createdAt': FieldValue.serverTimestamp(), // optional
      });

      // ✅ Reset UI
      nameController.clear();
      subController.clear();
      setState(() {
        subcategories.clear();
        selectedImageBytes = null;
      });

      showSuccess('Category added successfully!');
    } catch (e) {
      showError('Failed to add category: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Add Category", style: TextStyle(color: kText)),
        centerTitle: true,
        iconTheme: IconThemeData(color: kText),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF0DDC9), Color(0xFFE6D2BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: GlassCard(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration("Category Name"),
                    ),
                    const SizedBox(height: 20),
                    selectedImageBytes != null
                        ? Image.memory(
                            selectedImageBytes!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : Text("No image selected",
                            style: TextStyle(color: kText)),
                    TextButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.image, color: kAccent),
                      label:
                          Text("Pick Image", style: TextStyle(color: kAccent)),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: subController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration("Add Subcategory"),
                      onSubmitted: (val) {
                        final text = val.trim();
                        if (text.isNotEmpty && !subcategories.contains(text)) {
                          setState(() {
                            subcategories.add(text);
                            subController.clear();
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: subcategories
                            .map((sub) => Chip(
                                  label: Text(sub,
                                      style: TextStyle(color: Colors.white)),
                                  backgroundColor: kAccent,
                                  deleteIcon:
                                      Icon(Icons.close, color: Colors.white),
                                  onDeleted: () {
                                    setState(() => subcategories.remove(sub));
                                  },
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: addCategory,
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Save Category",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 10,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: kText.withOpacity(0.7)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kAccent.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: kAccent),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.85,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
