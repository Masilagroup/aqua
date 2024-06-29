// @dart=2.9
part of 'product_list_bloc.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();
}

class ProductListInitial extends ProductListState {
  final String loadMessage;

  ProductListInitial(this.loadMessage);

  @override
  List<Object> get props => [loadMessage];
}

class ProductListLoading extends ProductListState {
  final String loadMessage;

  ProductListLoading(this.loadMessage);

  @override
  List<Object> get props => [loadMessage];
}

class ProductListError extends ProductListState {
  final String errorMessage;

  ProductListError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class ProductListLoaded extends ProductListState {
  final List<ProdItemData> productsList;
  final bool hasReachedMax;
  final List<FilterSize> filterSizes;

  ProductListLoaded(
      {@required this.productsList, this.hasReachedMax, this.filterSizes});

  @override
  List<Object> get props => [productsList, hasReachedMax];
}
