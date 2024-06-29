// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aqua/global.dart';
import 'package:aqua/Cart/bloc/cart_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository cartRepository = CartRepository();
  var currency = prefs.getInt("currencyCode");
  @override
  CartState get initialState => CartInitial();

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    CartListResponse cartListResponse = CartListResponse();
    final currentState = state;

    if (event is CartAddEvent) {
      if (currentState is CartListLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartAddLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartAddErrorRetainState) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartDeleteLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartDeleteErrorRetainState) {
        cartListResponse = currentState.cartListResponse;
      }

      try {
        //    yield CartAddLoading('Loading..');
        Map<String, dynamic> parameters = Map<String, dynamic>();

        parameters['product_id'] = event.productId;
        parameters['size_id'] = event.sizeId;
        parameters['color_id'] = event.colorId;
        parameters['quantity'] = event.quantity;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        parameters['device_token'] = Constants.deviceUUID;
        parameters['device_type'] = Platform.isAndroid ? "android" : "ios";
        parameters['lang'] = Constants.selectedLang;
        parameters['session_id'] = Constants.deviceUUID;
        if (currency != null) {
          parameters['currency'] = currency;
        }
        CartListResponse pcartListResponse =
            await cartRepository.addtoCart(parameters);
        if (pcartListResponse.message == 'success') {
          prefs.setString(
              Constants.sessionId, pcartListResponse.data.sessionId);
          yield CartAddLoaded(pcartListResponse);
        } else {
          print('I am out of qty');
          yield CartAddError(pcartListResponse.info);
          yield CartAddErrorRetainState(cartListResponse);
        }
      } catch (e) {
        yield CartAddError('Error in connecting Server');
      }
    }
    if (event is CartDeleteEvent) {
      CartListResponse cartListResponse = CartListResponse();
      final currentState = state;

      if (currentState is CartListLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartAddLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartAddErrorRetainState) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartDeleteLoaded) {
        cartListResponse = currentState.cartListResponse;
      }
      if (currentState is CartDeleteErrorRetainState) {
        cartListResponse = currentState.cartListResponse;
      }
      try {
        //     yield CartDeleteLoading('Loading..');
        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String seesionId = prefs.getString(Constants.sessionId);
        parameters['session_id'] = seesionId;
        parameters['item_id'] = event.cartId;

        parameters['device_token'] = Constants.deviceUUID;
        parameters['device_type'] = Platform.isAndroid ? "android" : "ios";
        parameters['lang'] = Constants.selectedLang;
        if (currency != null) {
          parameters['currency'] = currency;
        }

        CartListResponse pcartListResponse =
            await cartRepository.delteFromCart(parameters);
        if (pcartListResponse.message == 'success') {
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // prefs.setString(Constants.sessionId, cartListResponse.data.sessionId);
          yield CartDeleteLoaded(pcartListResponse);
        } else {
          yield CartDeleteError(pcartListResponse.info);
          //     yield CartListErrorRetainState(cartListResponse);
          yield CartDeleteErrorRetainState(cartListResponse);
        }
      } catch (e) {
        yield CartDeleteError('Error in connecting Server');
      }
    }

    if (event is CartListFetch) {
      try {
        yield CartListLoading('Loading..');
        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //      String sesionId = prefs.getString(Constants.sessionId);
        parameters['session_id'] = Constants.deviceUUID;

        parameters['device_token'] = Constants.deviceUUID;
        parameters['device_type'] = Platform.isAndroid ? "android" : "ios";
        parameters['lang'] = Constants.selectedLang;
        if (currency != null) {
          parameters['currency'] = currency;
        }
        CartListResponse cartListResponse =
            await cartRepository.getCartList(parameters);
        if (cartListResponse.message == 'success') {
          yield CartListLoaded(cartListResponse);
        } else {
          yield CartListError(cartListResponse.info);
        }
      } catch (e) {
        yield CartListError('Error in connecting Server');
      }
    }
  }
}
