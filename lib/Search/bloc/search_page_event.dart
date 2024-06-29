// @dart=2.9
part of 'search_page_bloc.dart';

abstract class SearchPageEvent extends Equatable {
  const SearchPageEvent();
}

class SearchPageFetch extends SearchPageEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
