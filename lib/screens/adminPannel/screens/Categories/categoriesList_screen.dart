import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messages_apk/screens/adminPannel/screens/Categories/add_category_form.dart';
import 'package:messages_apk/screens/adminPannel/screens/widgets/edit_category_form.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);
final Color kCardLight =
    const Color.fromARGB(255, 251, 241, 234); // Light card background

class CategoriesListScreen extends StatefulWidget {
  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> {
  Future<void> deleteCategory(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Category deleted'), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error deleting category'),
            backgroundColor: Colors.red),
      );
    }
  }

  void editCategory(DocumentSnapshot doc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditCategoryForm(doc: doc)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        backgroundColor: kAccent,
        onPressed: () {
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
        title: Text("Categories", style: GoogleFonts.playfairDisplay(
            // ✨ Elegant serif font
            color: kText,
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),),
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
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error loading data'));
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return Center(child: Text('No categories found'));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                final subcategories =
                    List<String>.from(data['subcategories'] ?? []);

                final imageUrl = data['imageUrl'];
                final isValidUrl =
                    imageUrl != null && imageUrl.toString().startsWith('http');

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: GlassCard(
                    child: ListTile(
                      leading: isValidUrl
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.broken_image,
                                  color: kText.withOpacity(0.6),
                                ),
                              ),
                            )
                          : Icon(Icons.image_not_supported,
                              color: kText.withOpacity(0.6)),
                      title: Text(
                        data['name'] ?? 'No name',
                        style: TextStyle(
                            color: kText, fontWeight: FontWeight.bold),
                      ),
                      subtitle: subcategories.isEmpty
                          ? Text('No subcategories',
                              style: TextStyle(color: kText.withOpacity(0.7)))
                          : Wrap(
                              spacing: 6,
                              children: subcategories
                                  .map((sub) => Chip(
                                        label: Text(sub,
                                            style:
                                                TextStyle(color: Colors.white)),
                                        backgroundColor: kAccent,
                                      ))
                                  .toList(),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // IconButton(
                          //   icon: Icon(Icons.edit, color: Colors.blue),
                          //   onPressed: () => editCategory(doc),
                          // ),
                          // IconButton(
                          //   icon: Icon(Icons.delete, color: Colors.red),
                          //   onPressed: () => deleteCategory(doc.id),
                          // ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => setState(() => editCategory(doc)),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF71503C),
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.edit,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),

                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => deleteCategory(doc.id)),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                padding: EdgeInsets.all(6),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
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
            color: kCardLight,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black12, blurRadius: 6, offset: Offset(2, 2)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
