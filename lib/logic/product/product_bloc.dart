import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/product_model.dart';
import '../../data/repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;

  ProductBloc(this.repo) : super(const ProductState()) {
    on<LoadProductsEvent>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
    LoadProductsEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final products = await repo.fetchProducts();
      emit(state.copyWith(loading: false, products: products));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
