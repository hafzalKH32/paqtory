import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/cart/cart_bloc.dart';
import '../../logic/cart/cart_state.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  /// Local favourite state (UI only)
  final Set<String> _favIds = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final items = state.items;

          if (items.isEmpty) {
            return _buildEmptyState(context);
          }

          // Compute total on UI side
          final total = items.fold<double>(
            0,
                (sum, item) => sum + (item.product.price * item.quantity),
          );

          return Column(
            children: [
              // List of cart items
              Expanded(
                child: ListView.separated(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final CartItem item = items[index];
                    final Product p = item.product;
                    final bool isFav = _favIds.contains(p.id);

                    return _CartItemCard(
                      item: item,
                      isFav: isFav,
                      onToggleFav: () {
                        setState(() {
                          if (isFav) {
                            _favIds.remove(p.id);
                          } else {
                            _favIds.add(p.id);
                          }
                        });
                      },
                      onIncrement: () {
                        context.read<CartBloc>().add(AddToCartEvent(p));
                      },
                      onDecrement: () {
                        context.read<CartBloc>().add(RemoveFromCartEvent(p));
                      },
                    );
                  },
                ),
              ),

              // Bottom total + button
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.white24, width: 0.5),
                  ),
                  color: Color(0xFF050505),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${total.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // 1️⃣ Fire place-order event in bloc
                          context.read<CartBloc>().add(PlaceOrderEvent());

                          // 2️⃣ Navigate to success screen
                          Navigator.pushNamed(context, '/success');
                        },
                        child: const Text('Place Order'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_bag_outlined,
              size: 72,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add some products from the live session or product list to see them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to Live'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Single cart item tile
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isFav;
  final VoidCallback onToggleFav;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.item,
    required this.isFav,
    required this.onToggleFav,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final subtotal = p.price * item.quantity;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            child: p.image.isNotEmpty
                ? Image.network(
              p.image,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            )
                : Container(
              width: 90,
              height: 90,
              color: Colors.white10,
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: Colors.white70,
              ),
            ),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + fav
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          p.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: onToggleFav,
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFav ? Colors.redAccent : Colors.white54,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Price + rating
                  Row(
                    children: [
                      Text(
                        '₹${p.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Row(
                        children: const [
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Icon(Icons.star, size: 14, color: Colors.amber),
                          Icon(Icons.star_half, size: 14, color: Colors.amber),
                          Icon(Icons.star_border,
                              size: 14, color: Colors.amber),
                        ],
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Quantity & subtotal
                  Row(
                    children: [
                      // Qty controls
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white30, width: 1),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: onDecrement,
                            ),
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: onIncrement,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Subtotal',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white60,
                            ),
                          ),
                          Text(
                            '₹${subtotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
