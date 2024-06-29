// @dart=2.9
part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersListLoading extends OrdersState {
  final String loadingMessage;

  OrdersListLoading(this.loadingMessage);
  @override
  List<Object> get props => [loadingMessage];
}

class OrdersListError extends OrdersState {
  final String errorMessage;

  OrdersListError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class OrdersListLoaded extends OrdersState {
  final OrdersListResponse ordersListResponse;

  OrdersListLoaded(this.ordersListResponse);
  @override
  List<Object> get props => [ordersListResponse];
}
