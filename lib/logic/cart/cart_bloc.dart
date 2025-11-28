import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/product_model.dart';
import '../../data/repository/cart_repository.dart';
import 'cart_state.dart';

part 'cart_event.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repo;

  CartBloc({CartRepository? repository})
      : repo = repository ?? CartRepository(),
        super(const CartState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAdd);
    on<RemoveFromCartEvent>(_onRemove);
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<ClearCartEvent>(_onClear);

    add(LoadCartEvent());
  }

  Future<void> _onLoadCart(LoadCartEvent event, Emitter<CartState> emit) async {
    final items = await repo.getCartItems();
    emit(state.copyWith(items: items));
  }

  void _onAdd(AddToCartEvent event, Emitter<CartState> emit) {
    repo.add(event.product);
    emit(state.copyWith(
      items: repo.items,
      orderPlaced: false,
      orderId: null,
      amount: null,
    ));
  }

  void _onRemove(RemoveFromCartEvent event, Emitter<CartState> emit) {
    repo.removeOne(event.product);
    emit(state.copyWith(items: repo.items));
  }

  Future<void> _onPlaceOrder(
    PlaceOrderEvent event,
    Emitter<CartState> emit,
  ) async {
    final res = await repo.placeOrder();
    emit(state.copyWith(
      items: const [],
      orderPlaced: true,
      orderId: res['orderId'] as String?,
      amount: res['amount'] as double?,
    ));
  }

  void _onClear(ClearCartEvent event, Emitter<CartState> emit) {
    repo.clear();
    emit(const CartState());
  }
}
