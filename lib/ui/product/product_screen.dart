import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/product_model.dart';
import '../../logic/cart/cart_bloc.dart';
import '../../logic/cart/cart_state.dart';
import '../../logic/product/product_bloc.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
        ],
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(child: Text(state.error!));
          }

          if (state.products.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final List<Product> products = state.products;

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final p = products[index];

              return _ProductCard(product: p);
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        // Find current quantity from cart
        final matchingItems = cartState.items
            .where((item) => item.product.id == product.id)
            .toList();
        final int quantity =
        matchingItems.isNotEmpty ? matchingItems.first.quantity : 0;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white24, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.45),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: product.image.isNotEmpty
                    ? Image.network(
                  product.image,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: double.infinity,
                  height: 180,
                  color: Colors.white10,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    size: 40,
                    color: Colors.white54,
                  ),
                ),
              ),

              // INFO TILE
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // TITLE + HEART
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite_border,
                            color: Colors.white54,
                          ),
                          onPressed: () {
                            // you can wire this to a wishlist later
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // PRICE + RATING
                    Row(
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: const [
                            Icon(Icons.star, size: 15, color: Colors.amber),
                            Icon(Icons.star, size: 15, color: Colors.amber),
                            Icon(Icons.star, size: 15, color: Colors.amber),
                            Icon(Icons.star_half,
                                size: 15, color: Colors.amber),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ADD / QUANTITY CONTROLS
                    if (quantity == 0)
                    // 🔹 Show "Add to Cart" when not in cart
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<CartBloc>()
                                .add(AddToCartEvent(product));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${product.name} added to cart'),
                              ),
                            );
                          },
                          child: const Text("Add to Cart"),
                        ),
                      )
                    else
                    // 🔹 Show - qty + when already in cart
                      Row(
                        children: [
                          // decrement
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: Colors.white30,
                                width: 1,
                              ),
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
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                      RemoveFromCartEvent(product),
                                    );
                                  },
                                ),
                                Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    fontSize: 14,
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
                                  onPressed: () {
                                    context.read<CartBloc>().add(
                                      AddToCartEvent(product),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'In cart',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.greenAccent.shade200,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
