import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String price;
  final String oldPrice;
  final double rating;
  final String imagePath;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 160,

      padding: const EdgeInsets.all(10),
      // REMOVE margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          imagePath.startsWith('http')
              ? Image.network(
                  imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image),
                )
              : Image.asset(
                  imagePath,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

// Replace with Image.network(...)
          const SizedBox(height: 5),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(oldPrice,
                  style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey)),
              const SizedBox(width: 5),
              Text(price, style: const TextStyle(color: Colors.red)),
            ],
          ),
          Row(children: [
            const Icon(Icons.star, size: 16, color: Colors.orange),
            Text(rating.toString()),
          ]),
        ],
      ),
    );
  }
}
