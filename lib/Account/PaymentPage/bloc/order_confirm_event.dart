// @dart=2.9
part of 'order_confirm_bloc.dart';

abstract class OrderConfirmEvent extends Equatable {
  const OrderConfirmEvent();
}

class OrderConfirmFetch extends OrderConfirmEvent {
  final String paymentMethod;

  OrderConfirmFetch(this.paymentMethod);
  @override
  List<Object> get props => [];
}
