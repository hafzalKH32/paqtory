import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartRepository {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  Future<List<CartItem>> getCartItems() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final cartRef = FirebaseFirestore.instance.collection('carts').doc(user.uid);
    final snapshot = await cartRef.collection('items').get();

    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      final product = Product(
        id: doc.id,
        name: data['name'] ?? '',
        image: data['image'] ?? '',
        price: (data['price'] ?? 0).toDouble(),
      );

      // Safely parse quantity, defaulting to 0 if it's not a number
      final quantity = data['quantity'] is int ? data['quantity'] : 0;

      return CartItem(product: product, quantity: quantity);
    }).toList();

    _items.clear();
    _items.addAll(items);

    return items;
  }

  void add(Product product) {
    final index = _items.indexWhere((e) => e.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product: product, quantity: 1));
    } else {
      final existing = _items[index];
      _items[index] = existing.copyWith(quantity: existing.quantity + 1);
    }
  }

  void removeOne(Product product) {
    final index = _items.indexWhere((e) => e.product.id == product.id);
    if (index == -1) return;

    final existing = _items[index];
    if (existing.quantity > 1) {
      _items[index] = existing.copyWith(quantity: existing.quantity - 1);
    } else {
      _items.removeAt(index);
    }
  }

  void clear() => _items.clear();

  Future<Map<String, dynamic>> placeOrder() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final cartRef = FirebaseFirestore.instance.collection('carts').doc(user.uid);
    final total = _items.fold<double>(0, (sum, item) => sum + item.subtotal);

    final batch = FirebaseFirestore.instance.batch();

    for (final item in _items) {
      final productRef = cartRef.collection('items').doc(item.product.id);
      batch.set(productRef, {
        'name': item.product.name,
        'price': item.product.price,
        'image': item.product.image,
        'quantity': item.quantity,
      });
    }

    await batch.commit();

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    clear();

    return {
      'orderId': id,
      'amount': total,
      'status': 'PAID',
    };
  }
}
