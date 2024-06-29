// @dart=2.9
import 'dart:async';

import 'package:aqua/HomePage/bloc/homepage_response.dart';
import 'package:aqua/Search/bloc/search_page_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'search_page_event.dart';
part 'search_page_state.dart';

class SearchPageBloc extends Bloc<SearchPageEvent, SearchPageState> {
  final SearchPageRepository _searchPageRepository = SearchPageRepository();
  @override
  SearchPageState get initialState => SearchPageInitial('Loading...');

  @override
  Stream<SearchPageState> mapEventToState(
    SearchPageEvent event,
  ) async* {
    if (event is SearchPageFetch) {
      yield SearchPageInitial('Loading..');
      try {
        final homepageData = await _searchPageRepository.getHomePageData();

        if (homepageData.message == 'success') {
          print('Inside SearchPage Loaded');
          yield SearchPageLoaded(homepageData: homepageData);
        } else {
          yield SearchPageError(homepageData.info);
        }
      } catch (e) {
        yield SearchPageError(e.toString());
      }
    }
  }
}
