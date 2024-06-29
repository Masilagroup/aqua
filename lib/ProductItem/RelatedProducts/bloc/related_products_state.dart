// @dart=2.9
part of 'related_products_bloc.dart';

abstract class RelatedProductsState extends Equatable {
  const RelatedProductsState();
}

class RelatedProductsInitial extends RelatedProductsState {
  final String infoMessage;

  RelatedProductsInitial(this.infoMessage);

  @override
  List<Object> get props => [];
}

class RelatedProductsError extends RelatedProductsState {
  final String errorMessage;

  RelatedProductsError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class RelatedProductsLoaded extends RelatedProductsState {
  final ProductItemResponse productItemResponse;

  RelatedProductsLoaded({@required this.productItemResponse});

  @override
  List<Object> get props => [productItemResponse];
}
