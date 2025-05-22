import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class EditProductForm extends StatefulWidget {
  final String productId; // Firestore document ID to edit

  const EditProductForm({Key? key, required this.productId}) : super(key: key);

  @override
  State<EditProductForm> createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final ratingController = TextEditingController();

  String? selectedCategory;
  String? selectedSubcategory;

  List<String> categories = [];
  List<String> subcategories = [];

  bool loadingCategories = true;
  bool loadingSubcategories = false;
  bool loadingProduct = true;

  Uint8List? selectedImageBytes;
  String? currentImageUrl;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProduct();
  }

  Future<void> fetchProduct() async {
    setState(() {
      loadingProduct = true;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        nameController.text = data['name'] ?? '';
        priceController.text = data['price'] ?? '';
        oldPriceController.text = data['oldPrice'] ?? '';
        ratingController.text = (data['rating'] ?? '').toString();
        selectedCategory = data['category'];
        selectedSubcategory = data['subcategory'];
        currentImageUrl = data['imageURL'];

        if (selectedCategory != null) {
          await fetchSubcategories(selectedCategory!);
        }
      } else {
        showError("Product not found.");
        Navigator.pop(context);
      }
    } catch (e) {
      showError('Failed to load product.');
      Navigator.pop(context);
    }
    setState(() {
      loadingProduct = false;
    });
  }

  Future<void> fetchCategories() async {
    setState(() => loadingCategories = true);
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
        loadingCategories = false;
      });
    } catch (e) {
      setState(() => loadingCategories = false);
      showError('Failed to load categories');
    }
  }

  Future<void> fetchSubcategories(String categoryName) async {
    setState(() {
      loadingSubcategories = true;
      subcategories = [];
      selectedSubcategory = null;
    });
    try {
      final catQuery = await FirebaseFirestore.instance
          .collection('categories')
          .where('name', isEqualTo: categoryName)
          .limit(1)
          .get();

      if (catQuery.docs.isNotEmpty) {
        final catDoc = catQuery.docs.first;
        final List<dynamic>? subsFromDoc = catDoc['subcategories'];
        setState(() {
          subcategories = subsFromDoc?.map((e) => e.toString()).toList() ?? [];
          // If editing and current subcategory is in the list, keep it selected
          if (selectedSubcategory != null &&
              !subcategories.contains(selectedSubcategory)) {
            selectedSubcategory = null;
          }
        });
      } else {
        setState(() {
          subcategories = [];
        });
      }
    } catch (e) {
      showError('Failed to load subcategories');
    }
    setState(() => loadingSubcategories = false);
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        selectedImageBytes = result.files.single.bytes;
        currentImageUrl = null; // Clear current URL preview when user picks new
      });
    }
  }

  Future<void> updateProduct() async {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final oldPrice = oldPriceController.text.trim();
    final rating = double.tryParse(ratingController.text.trim()) ?? 0;

    if (name.isEmpty) {
      showError('Please enter product name.');
      return;
    }
    if (price.isEmpty) {
      showError('Please enter product price.');
      return;
    }
    if (selectedCategory == null) {
      showError('Please select a category.');
      return;
    }
    if (selectedSubcategory == null) {
      showError('Please select a subcategory.');
      return;
    }

    final supabase = Supabase.instance.client;

    String? imageUrlToSave = currentImageUrl;

    // Upload new image only if a new image is selected
    if (selectedImageBytes != null && selectedImageBytes!.isNotEmpty) {
      try {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
        final filePath = 'product_images/$fileName';

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

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.productId)
          .update({
        'name': name,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'category': selectedCategory,
        'subcategory': selectedSubcategory,
        'imageURL': imageUrlToSave ?? '',
      });

      showSuccess('Product updated!');
      Navigator.pop(context); // Close form after update
    } catch (e) {
      showError('Failed to update product.');
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Edit Product", style: TextStyle(color: kText)),
        centerTitle: true,
        iconTheme: IconThemeData(color: kText),
      ),
      body: loadingProduct
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFF0DDC9), Color(0xFFE6D2BC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: SingleChildScrollView(
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 40),
                            TextField(
                              controller: nameController,
                              style: TextStyle(color: kText),
                              decoration: buildInputDecoration("Product Name"),
                            ),
                            const SizedBox(height: 20),
                            selectedImageBytes != null
                                ? Image.memory(
                                    selectedImageBytes!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : currentImageUrl != null
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
                              label: Text("Change Image",
                                  style: TextStyle(color: kAccent)),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: priceController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(color: kText),
                              decoration: buildInputDecoration("Price"),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: oldPriceController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(color: kText),
                              decoration: buildInputDecoration("Old Price"),
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: ratingController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              style: TextStyle(color: kText),
                              decoration: buildInputDecoration("Rating"),
                            ),
                            const SizedBox(height: 20),
                            loadingCategories
                                ? CircularProgressIndicator()
                                : DropdownButtonFormField<String>(
                                    value: selectedCategory,
                                    decoration:
                                        buildInputDecoration("Select Category"),
                                    dropdownColor: kBg,
                                    style: TextStyle(color: kText),
                                    items: categories
                                        .map((cat) => DropdownMenuItem(
                                              value: cat,
                                              child: Text(cat),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != selectedCategory) {
                                        setState(() {
                                          selectedCategory = val;
                                          selectedSubcategory = null;
                                        });
                                        if (val != null)
                                          fetchSubcategories(val);
                                      }
                                    },
                                  ),
                            const SizedBox(height: 16),
                            loadingSubcategories
                                ? CircularProgressIndicator()
                                : DropdownButtonFormField<String>(
                                    value: selectedSubcategory,
                                    decoration: buildInputDecoration(
                                        "Select Subcategory"),
                                    dropdownColor: kBg,
                                    style: TextStyle(color: kText),
                                    items: subcategories
                                        .map((sub) => DropdownMenuItem(
                                              value: sub,
                                              child: Text(sub),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      setState(() {
                                        selectedSubcategory = val;
                                      });
                                    },
                                  ),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kAccent,
                                iconColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: updateProduct,
                              child: Text("Update Product",
                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.white)),
                            ),
                          ],
                        ),
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

  const GlassCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: 380,
          decoration: BoxDecoration(
            color: const Color(0xFFE6D2BC).withOpacity(0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
