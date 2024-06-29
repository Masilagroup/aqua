// @dart=2.9
part of 'wish_list_bloc.dart';

abstract class WishListState extends Equatable {
  const WishListState();
}

class WishListInitial extends WishListState {
  final String loadMessage;

  WishListInitial(this.loadMessage);

  @override
  List<Object> get props => [loadMessage];
}

class WishListError extends WishListState {
  final String errorMessage;

  WishListError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class WishListLoaded extends WishListState {
  final WishListResponse wishListResponse;

  WishListLoaded({@required this.wishListResponse});

  @override
  List<Object> get props => [wishListResponse];
}

class WishListDeleteState extends WishListState {
  final WishListAddDelete wishListAddDelete;
  final WishListResponse wishListResponse;
  final bool wishDelte;

  WishListDeleteState({
    @required this.wishListResponse,
    @required this.wishListAddDelete,
    @required this.wishDelte,
  });

  @override
  List<Object> get props => [wishListAddDelete];
}

class WishListAddDeleteState extends WishListState {
  final String infoMessage;
  final bool addDelStatus;

  WishListAddDeleteState(this.infoMessage, this.addDelStatus);

  @override
  List<Object> get props => [infoMessage, addDelStatus];
}
