// @dart=2.9
part of 'related_products_bloc.dart';

abstract class RelatedProductsEvent extends Equatable {
  const RelatedProductsEvent();
}

class RelatedProductsFetch extends RelatedProductsEvent {
  final Map<String, dynamic> parameters;

  RelatedProductsFetch({@required this.parameters});

  @override
  List<Object> get props => [parameters];
}
