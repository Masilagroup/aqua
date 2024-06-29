// @dart=2.9
part of 'country_bloc.dart';

abstract class CountryState extends Equatable {
  const CountryState();
}

class CountryInitial extends CountryState {
  final String loadMessage;

  CountryInitial(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class CountryError extends CountryState {
  final String errorMessage;

  CountryError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class CountryLoaded extends CountryState {
  final ListCountries listCountries;

  CountryLoaded({@required this.listCountries});

  @override
  List<Object> get props => [listCountries];
}
