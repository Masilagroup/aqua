// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/WishList/bloc/wish_list_repository.dart';
import 'package:aqua/WishList/bloc/wish_list_response.dart';
import 'package:aqua/global.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'wish_list_event.dart';
part 'wish_list_state.dart';

class WishListBloc extends Bloc<WishListEvent, WishListState> {
  final WishListRepository _wishListRepository = WishListRepository();
  final UserRepository _userRepository = UserRepository();

  @override
  WishListState get initialState => WishListInitial('Loading...');

  @override
  Stream<WishListState> mapEventToState(
    WishListEvent event,
  ) async* {
    final currentState = state;

    if (event is WishProductsFetch) {
      yield WishListInitial('Loading...');
      try {
        final userData = await _userRepository.getUserData();
        print(userData);
        if (userData != null) {
          Map<String, dynamic> parameters = Map<String, dynamic>();
          var currency = prefs.getInt("currencyCode");
          parameters['access_token'] =
              userData['data']['user_api_access_token'];
          parameters['user_id'] = userData['data']['user_id'];
          parameters['lang'] = Constants.selectedLang;
          parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
          parameters['device_token'] = Constants.deviceUUID;
          if (currency != null) {
            parameters['currency'] = currency;
          }
          final productsData =
              await _wishListRepository.getUserWishListData(parameters);

          if (productsData.message == 'success') {
            print('Inside WishList PageLoaded');
            yield WishListLoaded(wishListResponse: productsData);
          } else {
            yield WishListError(productsData.info);
          }
        } else {
          yield WishListError('Please Log In');
        }
      } catch (e) {
        yield WishListError(e.toString());
      }
    }
    if (event is WishListDelete) {
      WishListResponse _wishListResponse;
      if (currentState is WishListLoaded) {
        _wishListResponse = currentState.wishListResponse;
      }
      if (currentState is WishListDeleteState) {
        _wishListResponse = currentState.wishListResponse;
      }
      print('inside Wishlistloaded and delete');
      try {
        final userData = await _userRepository.getUserData();
        print(userData);
        if (userData != null) {
          Map<String, dynamic> parameters = Map<String, dynamic>();
          parameters['access_token'] =
              userData['data']['user_api_access_token'];
          parameters['user_id'] = userData['data']['user_id'];
          parameters['product_id'] = event.productId;

          parameters['lang'] = Constants.selectedLang;
          parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
          parameters['device_token'] = Constants.deviceUUID;

          final wishListAddInfo =
              await _wishListRepository.addDeleteToWishList(parameters);

          if (wishListAddInfo.message == 'success') {
            List<ProdItemData> _itemData = _wishListResponse.data;
            _itemData
                .removeWhere((element) => element.productId == event.productId);
            _wishListResponse.data = _itemData;
            print('Inside WishList add delete');
            //    yield WishListLoaded(wishListResponse: _wishListResponse);
            yield WishListDeleteState(
              wishListAddDelete: wishListAddInfo,
              wishListResponse: _wishListResponse,
              wishDelte: true,
            );
          } else {
            yield WishListError(wishListAddInfo.info);
          }
        } else {
          yield WishListError('Please Log In');
        }
      } catch (e) {
        yield WishListError(e.toString());
      }
    }

    if (event is WishListAddDelEvent) {
      yield WishListInitial('Changing Wish list Status');
      try {
        final userData = await _userRepository.getUserData();
        print(userData);
        if (userData != null) {
          Map<String, dynamic> parameters = Map<String, dynamic>();
          parameters['access_token'] =
              userData['data']['user_api_access_token'];
          parameters['user_id'] = userData['data']['user_id'];
          parameters['product_id'] = event.productId;

          final wishListAddInfo =
              await _wishListRepository.addDeleteToWishList(parameters);
          if (wishListAddInfo.message == 'success') {
            if (wishListAddInfo.wishListData.wishStatus == 0) {
              yield WishListAddDeleteState(
                  'Item Removed from Your WishList', false);
            } else {
              yield WishListAddDeleteState('Item Added To Your WishList', true);
            }
          } else {
            yield WishListError(wishListAddInfo.info);
          }
        } else {
          yield WishListError('Please Log In');
        }
      } catch (e) {
        yield WishListError(e.toString());
      }
    }
  }
}
