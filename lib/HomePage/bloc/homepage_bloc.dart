// @dart=2.9
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'homepage_repository.dart';
import 'homepage_response.dart';

part 'homepage_event.dart';
part 'homepage_state.dart';

class HomepageBloc extends Bloc<HomepageEvent, HomepageState> {
  HomePageRepository _homePageRepository = HomePageRepository();
  @override
  HomepageState get initialState => HomepageInitial('Loading...');

  @override
  Stream<HomepageState> mapEventToState(
    HomepageEvent event,
  ) async* {
    if (event is Fetch) {
      yield HomepageInitial('Loading..');
      try {
        final homepageData = await _homePageRepository.getHomePageData();

        if (homepageData.message == 'success') {
          print('Inside Home PageLoaded');
          yield HomepageLoaded(homepageData: homepageData);
        } else {
          yield HomepageError(homepageData.info);
        }
      } catch (e) {
        yield HomepageError(e.toString());
      }
    }
  }
}
