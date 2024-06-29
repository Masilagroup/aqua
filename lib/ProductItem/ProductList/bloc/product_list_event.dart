// @dart=2.9
part of 'product_list_bloc.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();
}

class ProductsFetch extends ProductListEvent {
  final Map<String, dynamic> parameters;
  final int offset;
  var filteredSize;
  bool isRemoveOldData;
  ProductsFetch(
      {@required this.parameters,
      @required this.offset,
      this.filteredSize,
      this.isRemoveOldData = false});

  @override
  List<Object> get props => [parameters, offset];
}
