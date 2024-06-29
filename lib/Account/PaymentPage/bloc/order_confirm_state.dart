// @dart=2.9
part of 'order_confirm_bloc.dart';

abstract class OrderConfirmState extends Equatable {
  const OrderConfirmState();
}

class OrderConfirmInitial extends OrderConfirmState {
  @override
  List<Object> get props => [];
}

class OrderConfirmLoading extends OrderConfirmState {
  final String loadingMessage;

  OrderConfirmLoading(this.loadingMessage);
  @override
  List<Object> get props => [loadingMessage];
}

class OrderConfirmError extends OrderConfirmState {
  final String errorMessage;

  OrderConfirmError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class OrderConfirmLoaded extends OrderConfirmState {
  final OrderConfirmResponse orderConfirmResponse;
  OrderConfirmLoaded(this.orderConfirmResponse);
  @override
  List<Object> get props => [orderConfirmResponse];
}

class OrderPlacedForCOD extends OrderConfirmState {
  final OrderConfirmResponse orderConfirmResponse;
  OrderPlacedForCOD(this.orderConfirmResponse);
  @override
  List<Object> get props => [orderConfirmResponse];
}
