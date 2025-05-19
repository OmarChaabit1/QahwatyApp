import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messages_apk/screens/adminPannel/screens/New_Arrivals/add_new_arrivals.dart';

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
    // Placeholder for edit logic
    // You can navigate to NewArrivalsScreen with doc data
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

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: GlassCard(
                    child: ListTile(
                      leading:
                          Image.asset('images/logo.png', width: 50, height: 50),
                      title: Text(data['name'] ?? 'No name',
                          style: TextStyle(
                              color: kText, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        "Price: ${data['price']} DH\nRating: ${data['rating']}",
                        style: TextStyle(color: kText.withOpacity(0.7)),
                      ),
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
