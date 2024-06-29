// @dart=2.9
part of 'homepage_bloc.dart';

abstract class HomepageEvent extends Equatable {
  const HomepageEvent();
}

class Fetch extends HomepageEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
