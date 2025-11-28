// lib/ui/live/widgets/product_highlight_panel.dart
import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';

class ProductHighlightPanel extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;

  const ProductHighlightPanel({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          // product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.image.isNotEmpty
                ? Image.network(
              product.image,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            )
                : Container(
              width: 72,
              height: 72,
              color: Colors.white10,
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white70,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${product.price.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Add to cart
          ElevatedButton(
            onPressed: onAddToCart,
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
