// @dart=2.9
part of 'payment_check_bloc.dart';

abstract class PaymentCheckEvent extends Equatable {
  const PaymentCheckEvent();
}

class PaymentCheckFetch extends PaymentCheckEvent {
  @override
  List<Object> get props => [];
}

class OrderPlaceFetch extends PaymentCheckEvent {
  final String paymentId;

  OrderPlaceFetch(this.paymentId);
  @override
  List<Object> get props => [paymentId];
}
