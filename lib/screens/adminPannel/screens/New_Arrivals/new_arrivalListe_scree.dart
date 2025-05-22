import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/New_Arrivals/add_new_arrivals.dart';
import 'package:messages_apk/screens/adminPannel/screens/widgets/edit_newArrivals_form.dart';

final Color kBg = const Color(0xFFF0DDC9);
final Color kText = const Color(0xFF333333);
final Color kAccent = const Color(0xFF71503C);

class NewArrivalsListScreen extends StatefulWidget {
  @override
  _NewArrivalsListScreenState createState() => _NewArrivalsListScreenState();
}

class _NewArrivalsListScreenState extends State<NewArrivalsListScreen> {
  Future<void> deleteProduct(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('new_arrivals')
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
        MaterialPageRoute(builder: (_) => EditNewForm(productId: doc.id)));
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
            MaterialPageRoute(builder: (_) => AddNewArrivals()),
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
        title: Text("New Arrivals", style: TextStyle(color: kText)),
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
              FirebaseFirestore.instance.collection('new_arrivals').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Center(child: Text('Error loading data'));
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty)
              return Center(child: Text('No new arrivals found'));

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
                        productName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: kText,
                        ),
                      ),
                      subtitle: (productPrice.isNotEmpty || oldPrice.isNotEmpty)
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
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => deleteProduct(doc.id),
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
