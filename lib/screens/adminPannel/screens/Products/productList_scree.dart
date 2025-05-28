import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/Products/add_product_form.dart';

import '../widgets/edit_product_form.dart';

final Color kBg = const Color(0xFFFAF3E0); // Soft cream background
final Color kText = const Color(0xFF1C1C1E); // Dark text
final Color kAccent = const Color(0xFFE86C4D); // Warm coral accent
final Color kSecondary = const Color(0xFFFAE3D9); // Light peach
final Color kCardBackground =
    const Color(0xFFF5F5F5).withOpacity(0.1); // Transparent glass

class ProductlistScree extends StatefulWidget {
  @override
  _ProductlistScreeState createState() => _ProductlistScreeState();
}

class _ProductlistScreeState extends State<ProductlistScree> {
  Future<void> deleteProduct(String docId) async {
    try {
      // FIXED typo here: products instead of prodcuts
      await FirebaseFirestore.instance
          .collection('products')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted'), backgroundColor: Colors.red),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error deleting product'),
            backgroundColor: Colors.red),
      );
    }
  }

  void editProduct(DocumentSnapshot doc) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => EditProductForm(productId: doc.id)));
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
            MaterialPageRoute(builder: (_) => AddProductForm()),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFFF5EDE4),
        elevation: 0,
        title: Text("Products", style: TextStyle(color: kText)),
        centerTitle: true,
        iconTheme: IconThemeData(color: kText),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error loading data'));
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty) return Center(child: Text('No Products found'));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;

                final imageUrl = data['imageURL'];
                final isValidUrl =
                    imageUrl != null && imageUrl.toString().startsWith('http');

                final productName = data['name'] ?? 'Unnamed Product';
                final productPrice =
                    data['price'] != null ? '\$${data['price']}' : '';
                final oldPrice =
                    data['oldPrice'] != null ? '\$${data['oldPrice']}' : '';

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFF5EDE4),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: GlassCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(12),
                        leading: isValidUrl
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.broken_image,
                                    color: kText.withOpacity(0.6),
                                    size: 40,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.image_not_supported,
                                color: kText.withOpacity(0.6),
                                size: 40,
                              ),
                        title: Text(
                          productName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kText,
                          ),
                        ),
                        subtitle: (productPrice.isNotEmpty ||
                                oldPrice.isNotEmpty)
                            ? Row(
                                children: [
                                  if (productPrice.isNotEmpty)
                                    Text(
                                      productPrice,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  SizedBox(width: 10),
                                  if (oldPrice.isNotEmpty)
                                    Text(
                                      oldPrice,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red,
                                        decoration: TextDecoration.lineThrough,
                                        decorationColor: Colors.red,
                                        decorationThickness: 2,
                                      ),
                                    ),
                                ],
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => editProduct(doc),
                              tooltip: 'Edit Product',
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteProduct(doc.id),
                              tooltip: 'Delete Product',
                            ),
                          ],
                        ),
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
            gradient: LinearGradient(
              colors: [Colors.white, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
