import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageSubCategories extends StatefulWidget {
  @override
  State<ManageSubCategories> createState() => _ManageSubCategoriesState();
}

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class _ManageSubCategoriesState extends State<ManageSubCategories> {
  String? selectedCategory;
  final subController = TextEditingController();
  List<String> subcategories = [];
  List<String> allCategories = [];

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    final names = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    setState(() {
      allCategories = names;
    });
  }

  void fetchSubcategories(String category) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: category)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final List<dynamic> subs = data['subcategories'] ?? [];
      setState(() {
        subcategories = subs.map((e) => e.toString()).toList();
      });
    }
  }

  void addSubcategory() async {
    final sub = subController.text.trim();
    if (sub.isEmpty || selectedCategory == null) return;

    if (subcategories.contains(sub)) {
      showError("Subcategory already exists.");
      return;
    }

    setState(() {
      subcategories.add(sub);
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: selectedCategory)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update({'subcategories': subcategories});
      subController.clear();
      showSuccess("Subcategory added!");
    }
  }

  void removeSubcategory(String sub) async {
    if (selectedCategory == null) return;

    setState(() {
      subcategories.remove(sub);
    });

    final snapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where('name', isEqualTo: selectedCategory)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .update({'subcategories': subcategories});
    }
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.green));
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
        title: Text("Manage Subcategories", style: TextStyle(color: kText)),
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
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      items: allCategories
                          .map((cat) => DropdownMenuItem(
                                child: Text(cat),
                                value: cat,
                              ))
                          .toList(),
                      decoration: buildInputDecoration("Select Category"),
                      onChanged: (val) {
                        setState(() {
                          selectedCategory = val!;
                          fetchSubcategories(val);
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: subController,
                      decoration: buildInputDecoration("New Subcategory"),
                      onSubmitted: (_) => addSubcategory(),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: subcategories
                          .map((sub) => Chip(
                                label: Text(sub,
                                    style: TextStyle(color: Colors.white)),
                                backgroundColor: kAccent,
                                deleteIcon:
                                    Icon(Icons.close, color: Colors.white),
                                onDeleted: () => removeSubcategory(sub),
                              ))
                          .toList(),
                    ),
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
