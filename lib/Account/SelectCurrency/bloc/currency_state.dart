// @dart=2.9
part of 'currency_bloc.dart';

abstract class CurrencyState extends Equatable {
  const CurrencyState();
}

class CurrencyInitial extends CurrencyState {
  final String loadMessage;

  CurrencyInitial(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class CurrencyError extends CurrencyState {
  final String errorMessage;

  CurrencyError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class CurrencyLoaded extends CurrencyState {
  final CurrencyList currencyList;
  final selectedIndex;

  CurrencyLoaded(this.selectedIndex, {@required this.currencyList});

  @override
  List<Object> get props => [currencyList, selectedIndex];
}

class CurrencySelState extends CurrencyState {
  final int selectedIndex;

  CurrencySelState(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

class CurrencyRetriveState extends CurrencyState {
  final CurrencyData currencyData;

  CurrencyRetriveState(this.currencyData);
  @override
  List<Object> get props => [currencyData];
}
