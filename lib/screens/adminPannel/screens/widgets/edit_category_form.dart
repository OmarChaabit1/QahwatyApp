import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart'; // If you use Firebase Storage as backup
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditCategoryForm extends StatefulWidget {
  final DocumentSnapshot doc;
  const EditCategoryForm({super.key, required this.doc});

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class _EditCategoryFormState extends State<EditCategoryForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _subController;
  List<String> subcategories = [];

  Uint8List? selectedImageBytes;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    final data = widget.doc.data()! as Map<String, dynamic>;
    _nameController = TextEditingController(text: data['name'] ?? '');

    // Initialize subcategories list and controller
    final subs = (data['subcategories'] as List<dynamic>? ?? []).cast<String>();
    subcategories = List<String>.from(subs);
    _subController = TextEditingController();

    currentImageUrl = data['imageUrl'];
  }

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

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final supabase = Supabase.instance.client;
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = 'images/$fileName';

      final uploadResult = await supabase.storage.from('qahwaty').uploadBinary(
            filePath,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/png',
              upsert: true,
            ),
          );

      if (uploadResult.isEmpty) {
        throw Exception('Upload failed or returned an empty result.');
      }

      return supabase.storage.from('qahwaty').getPublicUrl(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Image upload failed: $e'),
            backgroundColor: Colors.red),
      );
      return null;
    }
  }

  Future<void> updateCategory() async {
    if (_formKey.currentState!.validate()) {
      // Upload image if new one selected, else keep current url
      String? imageUrl = currentImageUrl;
      if (selectedImageBytes != null) {
        final uploadedUrl = await uploadImage(selectedImageBytes!);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        } else {
          // If upload fails, stop update
          return;
        }
      }

      try {
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.doc.id)
            .update({
          'name': _nameController.text.trim(),
          'imageUrl': imageUrl,
          'subcategories': subcategories,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Category updated successfully'),
              backgroundColor: Colors.green),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to update category: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        title: Text('Edit Category', style: TextStyle(color: kText)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: kText),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: GlassCard(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration('Category Name'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter a category name'
                              : null,
                    ),
                    const SizedBox(height: 20),

                    // Image preview
                    selectedImageBytes != null
                        ? Image.memory(
                            selectedImageBytes!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        : (currentImageUrl != null &&
                                currentImageUrl!.isNotEmpty)
                            ? Image.network(
                                currentImageUrl!,
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

                    // Subcategory input
                    TextField(
                      controller: _subController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration('Add Subcategory'),
                      onSubmitted: (val) {
                        final text = val.trim();
                        if (text.isNotEmpty && !subcategories.contains(text)) {
                          setState(() {
                            subcategories.add(text);
                            _subController.clear();
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
                            .map(
                              (sub) => Chip(
                                label: Text(sub,
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: kAccent,
                                deleteIcon:
                                    Icon(Icons.close, color: Colors.white),
                                onDeleted: () {
                                  setState(() => subcategories.remove(sub));
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    ElevatedButton.icon(
                      onPressed: updateCategory,
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text(
                        'Save Changes',
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
