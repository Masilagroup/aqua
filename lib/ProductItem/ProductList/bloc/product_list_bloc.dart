// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_lst_repository.dart';
import 'package:aqua/global.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
part 'product_list_event.dart';
part 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListRepository _productListRepository = ProductListRepository();

  @override
  ProductListState get initialState => ProductListInitial('Loading...');

  @override
  Stream<Transition<ProductListEvent, ProductListState>> transformEvents(
    Stream<ProductListEvent> events,
    TransitionFunction<ProductListEvent, ProductListState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ProductListState> mapEventToState(
    ProductListEvent event,
  ) async* {
    final currentState = state;
    var currentData = List<ProdItemData>();
    if (event is ProductsFetch) {
      if (event.isRemoveOldData) {
        yield ProductListLoading('Loading...');
      }
      try {
        Map<String, dynamic> parameters = event.parameters;
        var currency = prefs.getInt("currencyCode");
        if (Constants.isSignIN) {
          final UserRepository _userRepository = UserRepository();
          final userData = await _userRepository.getUserData();
          parameters['user_id'] = userData['data']['user_id'];
        }
        parameters['offset'] = event.offset;
        parameters['price_sort'] = Constants.sortString;
        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
        parameters['device_token'] = Constants.deviceUUID;
        if (event.filteredSize != "")
          parameters['filter_size'] = event.filteredSize;
        if (currency != null) {
          parameters['currency'] = currency;
        }

        var productsData =
            await _productListRepository.getProductsListData(parameters);
        if (productsData.message == 'success') {
          print('Inside ProdList PageLoaded');
          print(productsData.productItemData.length);
          if (currentState is ProductListLoaded) {
            if (productsData.productItemData.length > 0) {
              if (!event.isRemoveOldData) {
                currentData = currentState.productsList;
              } else {
                currentData = [];
              }
              yield ProductListLoaded(
                  productsList: event.isRemoveOldData
                      ? productsData.productItemData
                      : currentData + productsData.productItemData,
                  hasReachedMax: false,
                  filterSizes: productsData.filterSizes);
            } else {
              yield ProductListLoaded(
                  productsList: productsData.productItemData,
                  hasReachedMax: true,
                  filterSizes: productsData.filterSizes);
            }
          } else if (currentState is ProductListLoading) {
            if (productsData.productItemData.length > 0) {
              currentData = [];

              yield ProductListLoaded(
                  productsList: event.isRemoveOldData
                      ? productsData.productItemData
                      : currentData + productsData.productItemData,
                  hasReachedMax: false,
                  filterSizes: productsData.filterSizes);
            } else {
              yield ProductListLoaded(
                  productsList: productsData.productItemData,
                  hasReachedMax: true,
                  filterSizes: productsData.filterSizes);
            }
          } else {
            yield ProductListLoaded(
                productsList: productsData.productItemData,
                hasReachedMax: false,
                filterSizes: productsData.filterSizes);
          }
        } else {
          yield ProductListError(productsData.info);
        }
      } catch (e) {
        yield ProductListError(e.toString());
      }
    }
  }
}
