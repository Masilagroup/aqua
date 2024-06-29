// @dart=2.9
part of 'cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class CartAddEvent extends CartEvent {
  final int productId;
  final String sizeId;
  final String colorId;
  final int quantity;

  CartAddEvent(this.productId, this.sizeId, this.colorId, this.quantity);
  @override
  List<Object> get props => [productId, sizeId, colorId, quantity];
}

class CartDeleteEvent extends CartEvent {
  final int cartId;

  CartDeleteEvent(this.cartId);
  @override
  List<Object> get props => [cartId];
}

class CartListFetch extends CartEvent {
  CartListFetch();
  @override
  List<Object> get props => [];
}
