// @dart=2.9
import 'dart:async';

import 'package:aqua/Account/Countries/bloc/country_repository.dart';
import 'package:aqua/Account/SelectCurrency/bloc/currency_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import 'currency_repository.dart';

part 'currency_event.dart';
part 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyRepository _currencyRepository = CurrencyRepository();

  @override
  CurrencyState get initialState => CurrencyInitial('Loading...');

  @override
  Stream<CurrencyState> mapEventToState(
    CurrencyEvent event,
  ) async* {
    final currentState = state;

    if (event is CurrencyFetch) {
      yield CurrencyInitial('Loading..');
      try {
        final currencyData = await _currencyRepository.getCurrenciesData();

        if (currencyData.message == 'success') {
          print('Inside Currency Loaded');
          yield CurrencyLoaded(
            -1,
            currencyList: currencyData,
          );
        } else {
          yield CurrencyError(currencyData.info);
        }
      } catch (e) {
        yield CurrencyError(e.toString());
      }
    }
    if (event is CurrencySelected) {
      if (currentState is CurrencyLoaded) {
        print('inside CurrencySelected');
        _currencyRepository.setCurrency(
            currentState.currencyList.currencyData[event.selectedIndex]);
        yield CurrencyLoaded(
          event.selectedIndex,
          currencyList: currentState.currencyList,
        );
      }
    }
    if (event is CurrencyRetrive) {
      CurrencyData currencyData = await _currencyRepository.retriveCurrency();
      yield CurrencyRetriveState(currencyData);
    }
  }
}
