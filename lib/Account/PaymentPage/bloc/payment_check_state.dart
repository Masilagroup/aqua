// @dart=2.9
part of 'payment_check_bloc.dart';

abstract class PaymentCheckState extends Equatable {
  const PaymentCheckState();
}

class PaymentCheckInitial extends PaymentCheckState {
  @override
  List<Object> get props => [];
}

class PaymentCheckLoading extends PaymentCheckState {
  final String loadingMessage;

  PaymentCheckLoading(this.loadingMessage);
  @override
  List<Object> get props => [loadingMessage];
}

class PaymentCheckError extends PaymentCheckState {
  final String errorMessage;

  PaymentCheckError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class PaymentCheckLoaded extends PaymentCheckState {
  final PaymentCheckStatusResponse paymentCheckStatusResponse;
  final Map<String, dynamic> userData;
  PaymentCheckLoaded(this.paymentCheckStatusResponse, this.userData);
  @override
  List<Object> get props => [paymentCheckStatusResponse, userData];
}

class OrderPlaceLoading extends PaymentCheckState {
  final String loadingMessage;

  OrderPlaceLoading(this.loadingMessage);
  @override
  List<Object> get props => [loadingMessage];
}

class OrderPlaceError extends PaymentCheckState {
  final String errorMessage;

  OrderPlaceError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class OrderPlaceLoaded extends PaymentCheckState {
  final OrderPlacedResponse orderPlacedResponse;
  OrderPlaceLoaded(this.orderPlacedResponse);
  @override
  List<Object> get props => [orderPlacedResponse];
}
