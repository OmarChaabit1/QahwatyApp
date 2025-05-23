import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final Color kBg = Color(0xFFF0DDC9);
final Color kText = Color(0xFF333333);
final Color kAccent = Color(0xFF71503C);

class OrdersScreen extends StatefulWidget {
  static const screenRoute = '/adminPannel/orderingList_screen';
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFFF5EDE4),
        elevation: 0,
        title: Text("Orders", style: TextStyle(color: kText)),
        centerTitle: true,
        iconTheme: IconThemeData(color: kText),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('orders').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return const Center(child: Text('Error loading data'));
            if (!snapshot.hasData)
              return const Center(child: CircularProgressIndicator());

            final docs = snapshot.data!.docs;
            if (docs.isEmpty)
              return const Center(child: Text('No orders found'));

            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final products =
                    List<Map<String, dynamic>>.from(data['products'] ?? []);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 14),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🧍 Client info
                          Text(
                            data['name'] ?? 'Unnamed',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(data['email'] ?? '',
                              style: TextStyle(color: kText.withOpacity(0.7))),
                          Text(data['phone'] ?? '',
                              style: TextStyle(color: kText.withOpacity(0.7))),
                          Text(data['address'] ?? '',
                              maxLines: 2, overflow: TextOverflow.ellipsis),

                          const SizedBox(height: 8),
                          Divider(color: Colors.grey.shade300),

                          // 🕓 Order info
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Order Date:",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: kText.withOpacity(0.7)),
                              ),
                              Text(
                                data['orderDate']
                                        ?.toString()
                                        .split('T')
                                        .first ??
                                    'Unknown',
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // 📦 Products section
                          Text("Products:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 6),

                          Column(
                            children: products.map((product) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        product['imageURL'] ?? '',
                                        width: 45,
                                        height: 45,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(product['name'] ?? 'Product',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500)),
                                          Text(
                                              "Qty: ${product['quantity'] ?? 1}",
                                              style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "\$${product['price']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: kAccent),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 10),
                          Divider(color: Colors.grey.shade300),

                          // 💰 Total price
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Total: \$${data['totalPrice']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.green.shade700,
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
