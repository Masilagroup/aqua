// @dart=2.9
part of 'currency_bloc.dart';

abstract class CurrencyEvent extends Equatable {
  const CurrencyEvent();
}

class CurrencyFetch extends CurrencyEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CurrencySelected extends CurrencyEvent {
  final int selectedIndex;

  CurrencySelected(this.selectedIndex);
  @override
  List<Object> get props => [selectedIndex];
}

// class CurrencySet extends CurrencyEvent {
//   final int selectedIndex;

//   CurrencySet(this.selectedIndex);
//   @override
//   List<Object> get props => [selectedIndex];
// }

class CurrencyRetrive extends CurrencyEvent {
  CurrencyRetrive();
  @override
  List<Object> get props => [];
}
