import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:messages_apk/screens/adminPannel/screens/SubCategories/manage_subCategories.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class AllSubCategoriesScreen extends StatefulWidget {
  @override
  _AllSubCategoriesScreenState createState() => _AllSubCategoriesScreenState();
}

class _AllSubCategoriesScreenState extends State<AllSubCategoriesScreen> {
  List<_SubcategoryWithCategory> allSubs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAllSubcategories();
  }

  Future<void> loadAllSubcategories() async {
    setState(() => loading = true);

    final snapshot =
        await FirebaseFirestore.instance.collection('categories').get();

    List<_SubcategoryWithCategory> tempList = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final catName = data['name'] ?? 'Unknown Category';
      final subs = List<String>.from(data['subcategories'] ?? []);
      for (var sub in subs) {
        tempList.add(_SubcategoryWithCategory(
          categoryId: doc.id,
          categoryName: catName,
          subcategory: sub,
        ));
      }
    }

    setState(() {
      allSubs = tempList;
      loading = false;
    });
  }

  Future<void> deleteSubcategory(_SubcategoryWithCategory item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Delete Subcategory'),
        content: Text(
            'Are you sure you want to delete "${item.subcategory}" from "${item.categoryName}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;

    // Remove from Firestore array
    final catDocRef = FirebaseFirestore.instance
        .collection('categories')
        .doc(item.categoryId);
    await catDocRef.update({
      'subcategories': FieldValue.arrayRemove([item.subcategory])
    });

    // Remove locally
    setState(() {
      allSubs.remove(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Subcategory deleted'), backgroundColor: Colors.red),
    );
  }

  Future<void> editSubcategory(_SubcategoryWithCategory item) async {
    final controller = TextEditingController(text: item.subcategory);
    final edited = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Subcategory'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          TextButton(
              onPressed: () {
                final val = controller.text.trim();
                if (val.isEmpty) return;
                Navigator.pop(context, val);
              },
              child: Text('Save')),
        ],
      ),
    );

    if (edited != null && edited.isNotEmpty && edited != item.subcategory) {
      // Check if new subcategory already exists in the same category
      bool alreadyExists = allSubs.any((e) =>
          e.categoryId == item.categoryId &&
          e.subcategory.toLowerCase() == edited.toLowerCase());

      if (alreadyExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Subcategory already exists in this category'),
              backgroundColor: Colors.red),
        );
        return;
      }

      final catDocRef = FirebaseFirestore.instance
          .collection('categories')
          .doc(item.categoryId);

      // Remove old subcategory and add new subcategory atomically:
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(catDocRef);
        if (!snapshot.exists) return;

        List<dynamic> subs = snapshot['subcategories'] ?? [];
        subs = subs.map((e) => e.toString()).toList();

        // Replace old with new
        final idx = subs.indexOf(item.subcategory);
        if (idx != -1) {
          subs[idx] = edited;
        }

        tx.update(catDocRef, {'subcategories': subs});
      });

      // Update local state
      setState(() {
        final idx = allSubs.indexOf(item);
        if (idx != -1) {
          allSubs[idx] = item.copyWith(subcategory: edited);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Subcategory updated'),
            backgroundColor: Colors.green),
      );
    }
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
            MaterialPageRoute(builder: (_) => ManageSubCategories()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'All Subcategories',
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
        child: loading
            ? Center(child: CircularProgressIndicator())
            : allSubs.isEmpty
                ? Center(
                    child: Text('No subcategories found',
                        style: TextStyle(color: kText)))
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 100, bottom: 80),
                    itemCount: allSubs.length,
                    itemBuilder: (context, index) {
                      final item = allSubs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 6),
                        child: GlassCard(
                          child: ListTile(
                            title: Text(
                              item.subcategory,
                              style: TextStyle(
                                  color: kText, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Category: ${item.categoryName}',
                              style: TextStyle(color: kText.withOpacity(0.7)),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.edit, color: Colors.blue),
                                //   onPressed: () => editSubcategory(item),
                                // ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => editSubcategory(item)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF71503C),
                                      ),
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.edit,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        size: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                // IconButton(
                                //   icon: Icon(Icons.delete, color: Colors.red),
                                //   onPressed: () => deleteSubcategory(item),
                                // ),
                                MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => deleteSubcategory(item)),
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
                  ),
      ),
    );
  }
}

class _SubcategoryWithCategory {
  final String categoryId;
  final String categoryName;
  final String subcategory;

  _SubcategoryWithCategory({
    required this.categoryId,
    required this.categoryName,
    required this.subcategory,
  });

  _SubcategoryWithCategory copyWith({String? subcategory}) {
    return _SubcategoryWithCategory(
      categoryId: categoryId,
      categoryName: categoryName,
      subcategory: subcategory ?? this.subcategory,
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
