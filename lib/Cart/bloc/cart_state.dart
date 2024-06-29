// @dart=2.9
part of 'cart_bloc.dart';

abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartAddLoading extends CartState {
  final String loadMessage;

  CartAddLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class CartAddError extends CartState {
  final String errorMessage;

  CartAddError(
    this.errorMessage,
  );
  @override
  List<Object> get props => [errorMessage];
}

class CartAddErrorRetainState extends CartState {
  final CartListResponse cartListResponse;

  CartAddErrorRetainState(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}

class CartAddLoaded extends CartState {
  final CartListResponse cartListResponse;

  CartAddLoaded(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}

class CartDeleteLoading extends CartState {
  final String loadMessage;

  CartDeleteLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class CartDeleteError extends CartState {
  final String errorMessage;

  CartDeleteError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class CartDeleteLoaded extends CartState {
  final CartListResponse cartListResponse;

  CartDeleteLoaded(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}

class CartDeleteErrorRetainState extends CartState {
  final CartListResponse cartListResponse;

  CartDeleteErrorRetainState(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}

class CartListLoading extends CartState {
  final String loadMessage;

  CartListLoading(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class CartListError extends CartState {
  final String errorMessage;

  CartListError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class CartListErrorRetainState extends CartState {
  final CartListResponse cartListResponse;

  CartListErrorRetainState(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}

class CartListLoaded extends CartState {
  final CartListResponse cartListResponse;

  CartListLoaded(this.cartListResponse);
  @override
  List<Object> get props => [cartListResponse];
}
