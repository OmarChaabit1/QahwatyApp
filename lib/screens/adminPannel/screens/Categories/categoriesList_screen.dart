import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/Categories/add_category_form.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class CategoriesListScreen extends StatefulWidget {
  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  Future<void> deleteCategory(String docId) async {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted'), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category'), backgroundColor: Colors.red),
      );
    }
  }

  void editCategory(DocumentSnapshot doc) {
    // You can navigate to AddCategoryForm with existing doc data for editing
    // Example:
    // Navigator.push(context, MaterialPageRoute(builder: (_) => EditCategoryForm(doc: doc)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        onPressed: () {
          // Navigate to AddCategoryForm to add a new category
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddCategoryForm()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Categories", style: TextStyle(color: kText)),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('Error loading data'));
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return Center(child: Text('No categories found'));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final subcategories = List<String>.from(data['subcategories'] ?? []);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: GlassCard(
                    child: ListTile(
                      title: Text(
                        data['name'] ?? 'No name',
                        style: TextStyle(color: kText, fontWeight: FontWeight.bold),
                      ),
                      subtitle: subcategories.isEmpty
                          ? Text('No subcategories', style: TextStyle(color: kText.withOpacity(0.7)))
                          : Wrap(
                              spacing: 6,
                              children: subcategories
                                  .map((sub) => Chip(
                                        label: Text(sub, style: TextStyle(color: Colors.white)),
                                        backgroundColor: kAccent,
                                      ))
                                  .toList(),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editCategory(doc),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteCategory(doc.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
          padding: const EdgeInsets.all(10),
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
