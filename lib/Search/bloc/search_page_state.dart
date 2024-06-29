// @dart=2.9
part of 'search_page_bloc.dart';

abstract class SearchPageState extends Equatable {
  const SearchPageState();
}

class SearchPageInitial extends SearchPageState {
  final String loadMessage;

  SearchPageInitial(this.loadMessage);

  @override
  List<Object> get props => [loadMessage];
}

class SearchPageError extends SearchPageState {
  final String errorMessage;

  SearchPageError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class SearchPageLoaded extends SearchPageState {
  final HomePageData homepageData;

  SearchPageLoaded({@required this.homepageData});

  @override
  List<Object> get props => [homepageData];
}
