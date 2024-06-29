// @dart=2.9
import 'dart:async';

import 'package:aqua/Api_Manager/api_repository.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'country_repository.dart';

part 'country_event.dart';
part 'country_state.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryRepository _countryRepository = CountryRepository();
  @override
  CountryState get initialState => CountryInitial('Loading...');

  @override
  Stream<CountryState> mapEventToState(
    CountryEvent event,
  ) async* {
    if (event is CountryFetch) {
      yield CountryInitial('Loading..');
      try {
        final countryData = await _countryRepository.getCountriesData();

        if (countryData.message == 'success') {
          print('Inside Country Loaded');
          yield CountryLoaded(listCountries: countryData);
        } else {
          yield CountryError(countryData.info);
        }
      } catch (e) {
        yield CountryError(e.toString());
      }
    }
  }
}
