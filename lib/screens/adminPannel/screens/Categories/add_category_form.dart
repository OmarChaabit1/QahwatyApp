import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';

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

  void showToast(BuildContext context, String title, String description,
      ToastificationType type) {
    Color primaryColor;
    Color backgroundColor;
    IconData icon;

    switch (type) {
      case ToastificationType.success:
        primaryColor = const Color(0xFF4CAF50);
        backgroundColor = Colors.white;
        icon = Icons.check_circle;
        break;
      case ToastificationType.info:
        primaryColor = Colors.purple;
        backgroundColor = Colors.white;
        icon = Icons.info_outline;
        break;
      case ToastificationType.warning:
        primaryColor = const Color(0xFFFFC107);
        backgroundColor = Colors.white;
        icon = Icons.warning_amber;
        break;
      default:
        primaryColor = const Color(0xFFF44336);
        backgroundColor = Colors.white;
        icon = Icons.error;
    }

    toastification.show(
      context: context,
      type: type,
      style: ToastificationStyle.flatColored,
      autoCloseDuration: const Duration(seconds: 4),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      description: Text(
        description,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      alignment: Alignment.bottomRight,
      animationDuration: const Duration(milliseconds: 300),
      icon: Icon(icon),
      showIcon: true,
      primaryColor: primaryColor,
      backgroundColor: backgroundColor,
      // foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 12,
          offset: const Offset(0, 8),
        ),
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.onHover,
      closeOnClick: false,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  Future<void> addCategory() async {
    final name = nameController.text.trim();

    final supabase = Supabase.instance.client;

    if (selectedImageBytes == null || selectedImageBytes!.isEmpty) {
      showToast(context, 'Image Missing', 'Please select a valid image.',
          ToastificationType.error);
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

      showToast(context, 'Success', 'Category added successfully!',
          ToastificationType.success);
    } catch (e) {
      showToast(context, 'Error', 'Failed to add category: $e',
          ToastificationType.error);
    }
  }

  void showError(String msg) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      // style: ToastificationStyle.fill, // or ToastificationStyle.flat
      title: Text(msg),
      alignment: Alignment.topRight,
      autoCloseDuration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 300),
    );
  }

  void showSuccess(String msg) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      // style: ToastificationStyle.fill,
      title: Text(msg),
      alignment: Alignment.topRight,
      autoCloseDuration: Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 300),
    );
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
        title: Text(
          "Add Category",
          style: GoogleFonts.playfairDisplay(
            // ✨ Elegant serif font
            color: kText,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
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
                                    showToast(
                                        context,
                                        'Success',
                                        'Subcategory removed successfully!',
                                        ToastificationType.success);
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
