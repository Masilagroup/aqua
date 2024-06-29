// @dart=2.9
part of 'country_bloc.dart';

abstract class CountryEvent extends Equatable {
  const CountryEvent();
}

class CountryFetch extends CountryEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
