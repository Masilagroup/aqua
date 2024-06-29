// @dart=2.9
part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class OrdersListFetch extends OrdersEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
