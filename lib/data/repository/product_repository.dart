import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Product(
          id: doc.id,
          name: data['name'] ?? '',
          image: data['image'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
        );
      }).toList();
    } catch (e) {
      // In a real app, you\'d want to handle this error more gracefully
      print('Error fetching products: $e');
      rethrow;
    }
  }
}
