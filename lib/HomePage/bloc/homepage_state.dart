// @dart=2.9
part of 'homepage_bloc.dart';

abstract class HomepageState extends Equatable {
  const HomepageState();
}

class HomepageInitial extends HomepageState {
  final String loadMessage;

  HomepageInitial(this.loadMessage);
  @override
  List<Object> get props => [loadMessage];
}

class HomepageError extends HomepageState {
  final String errorMessage;

  HomepageError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class HomepageLoaded extends HomepageState {
  final HomePageData homepageData;

  HomepageLoaded({@required this.homepageData});

  @override
  List<Object> get props => [homepageData];
}
