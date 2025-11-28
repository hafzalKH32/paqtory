part of 'product_bloc.dart';

@immutable
class ProductState {
  final bool loading;
  final List<Product> products;
  final String? error;

  const ProductState({
    this.loading = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? loading,
    List<Product>? products,
    String? error,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
    );
  }
}
