// @dart=2.9
part of 'wish_list_bloc.dart';

abstract class WishListEvent extends Equatable {
  const WishListEvent();
}

class WishProductsFetch extends WishListEvent {
  @override
  List<Object> get props => [];
}

class WishListDelete extends WishListEvent {
  final int productId;

  WishListDelete(this.productId);
  @override
  List<Object> get props => [productId];
}

class WishListAddDelEvent extends WishListEvent {
  final int productId;

  WishListAddDelEvent({@required this.productId});
  @override
  List<Object> get props => [productId];
}
