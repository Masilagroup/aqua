// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:aqua/Account/SelectCurrency/bloc/currency_repository.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/ProductItem/RelatedProducts/bloc/relate_products_repository.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'related_products_event.dart';
part 'related_products_state.dart';

class RelatedProductsBloc
    extends Bloc<RelatedProductsEvent, RelatedProductsState> {
  final RelateProductsRepository _relateProductsRepository =
      RelateProductsRepository();
  @override
  RelatedProductsState get initialState => RelatedProductsInitial('Loading...');

  @override
  Stream<RelatedProductsState> mapEventToState(
    RelatedProductsEvent event,
  ) async* {
    if (event is RelatedProductsFetch) {
      yield RelatedProductsInitial('Loading...');
      try {
        Map<String, dynamic> parameters = event.parameters;
        final CurrencyRepository currencyRepository = CurrencyRepository();
        final userData = await currencyRepository.retriveCurrency();
        parameters['currency'] = userData.currencyCode;

        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
        parameters['device_token'] = Constants.deviceUUID;

        final productsData =
            await _relateProductsRepository.getRelatedProductsData(parameters);
        if (productsData.message == 'success') {
          print('Inside Related Products');
          yield RelatedProductsLoaded(productItemResponse: productsData);
        } else {
          yield RelatedProductsError(productsData.info);
        }
      } catch (e) {
        yield RelatedProductsError(e.toString());
      }
    }
  }
}
