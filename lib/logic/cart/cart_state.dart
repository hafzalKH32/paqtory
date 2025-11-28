import 'package:meta/meta.dart';
import '../../data/models/cart_item_model.dart';

@immutable
class CartState {
  final List<CartItem> items;
  final bool orderPlaced;
  final String? orderId;
  final double? amount;

  const CartState({
    this.items = const [],
    this.orderPlaced = false,
    this.orderId,
    this.amount,
  });

  CartState copyWith({
    List<CartItem>? items,
    bool? orderPlaced,
    String? orderId,
    double? amount,
  }) {
    return CartState(
      items: items ?? this.items,
      orderPlaced: orderPlaced ?? this.orderPlaced,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
    );
  }
}
