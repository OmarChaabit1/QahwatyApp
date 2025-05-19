import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class AddNewArrivals extends StatefulWidget {
  @override
  State<AddNewArrivals> createState() => _AddNewArrivalsState();
}

class _AddNewArrivalsState extends State<AddNewArrivals> {
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

  @override
  void initState() {
    super.initState();
    fetchCategories();
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
        });
      }
    } catch (e) {
      showError('Failed to load subcategories');
    }
    setState(() => loadingSubcategories = false);
  }

  Future<void> saveNewArrival() async {
    final name = nameController.text.trim();
    final price = priceController.text.trim();
    final oldPrice = oldPriceController.text.trim();
    final rating = double.tryParse(ratingController.text.trim()) ?? 0;

    if (name.isEmpty || price.isEmpty) {
      showError('Please fill in all required fields.');
      return;
    }
    if (selectedCategory == null || selectedSubcategory == null) {
      showError('Please select category and subcategory.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('new_arrivals').add({
        'name': name,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'category': selectedCategory,
        'subcategory': selectedSubcategory,
        'imageURL': 'logo.png', // Placeholder
      });

      clearForm();
      showSuccess('New Arrival saved!');
    } catch (e) {
      showError('Failed to save new arrival.');
    }
  }

  void clearForm() {
    nameController.clear();
    priceController.clear();
    oldPriceController.clear();
    ratingController.clear();
    setState(() {
      selectedCategory = null;
      selectedSubcategory = null;
      subcategories = [];
    });
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
    ));
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.red,
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
        title: Text("Add New Arrival", style: TextStyle(color: kText)),
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
                      decoration: buildInputDecoration("Product Name"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: priceController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration("Price"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: oldPriceController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration("Old Price"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: ratingController,
                      style: TextStyle(color: kText),
                      decoration: buildInputDecoration("Rating"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    loadingCategories
                        ? CircularProgressIndicator()
                        : DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: buildInputDecoration("Select Category"),
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
                                if (val != null) fetchSubcategories(val);
                              }
                            },
                          ),
                    const SizedBox(height: 16),

                    // Subcategory Dropdown
                    loadingSubcategories
                        ? CircularProgressIndicator()
                        : DropdownButtonFormField<String>(
                            value: selectedSubcategory,
                            decoration:
                                buildInputDecoration("Select Subcategory"),
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
                    ElevatedButton.icon(
                      onPressed: saveNewArrival,
                      icon: Icon(Icons.add, color: Colors.white),
                      label: Text("Save Product",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
