part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  AddToCartEvent(this.product);
}

class RemoveFromCartEvent extends CartEvent {
  final Product product;
  RemoveFromCartEvent(this.product);
}

class PlaceOrderEvent extends CartEvent {}

class ClearCartEvent extends CartEvent {}
