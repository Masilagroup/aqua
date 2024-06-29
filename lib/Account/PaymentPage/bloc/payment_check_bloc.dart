// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aqua/Account/PaymentPage/bloc/payment_page_response.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aqua/global.dart';
part 'payment_check_event.dart';
part 'payment_check_state.dart';

class PaymentCheckBloc extends Bloc<PaymentCheckEvent, PaymentCheckState> {
  final PaymentRepository _paymentRepository = PaymentRepository();
  @override
  Stream<PaymentCheckState> mapEventToState(
    PaymentCheckEvent event,
  ) async* {
    if (event is PaymentCheckFetch) {
      yield PaymentCheckLoading('Loading..');
      try {
        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var currency = prefs.getInt("currencyCode");
        var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
            Map<String, dynamic>();

        //     String sesionId = prefs.getString(Constants.sessionId);
        print('PaymentCheckFetch:${Constants.deviceUUID}');
        parameters['session_id'] = Constants.deviceUUID;
        String couponString = prefs.getString(Constants.aquaCouponData);
        if (couponString != '') {
          var couponResponse = CouponResponse.fromRawJson(
              prefs.getString(Constants.aquaCouponData) ?? {});

          if (couponResponse != null) {
            parameters['coupon_code'] = couponResponse.data.cartCouponCode;
          }
        } else {
          //    parameters['coupon_code'] = 'AQUA7';
        }

        if (Constants.isSignIN) {
          parameters['user_id'] = userData['data']['user_id'];
        }
        parameters['name'] = userData['data']['user_name'];
        parameters['mobile'] = userData['data']['user_mobile'];
        parameters['email'] = userData['data']['user_email'];
        parameters['country_id'] = userData['data']['user_country_id'];
        parameters['area'] = userData['data']['user_area'];
        parameters['street'] = userData['data']['user_street'];
        parameters['house'] = userData['data']['user_house'];
        parameters['block'] = userData['data']['user_block'];

        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
        parameters['device_token'] = Constants.deviceUUID;
        if (currency != null) {
          parameters['currency'] = currency;
        }

        final paymentcheckResponse =
            await _paymentRepository.getCartList(parameters);
        if (paymentcheckResponse.message == 'success') {
          yield PaymentCheckLoaded(paymentcheckResponse, userData);
        } else {
          yield PaymentCheckError('paymentcheckResponse.info');
        }
      } catch (e) {
        print("OOOO");
        print(e);
        print("OOOO");
        yield PaymentCheckError('Error in While Connecting Server');
      }
    }
    if (event is OrderPlaceFetch) {
      try {
        yield OrderPlaceLoading('Loading..');

        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var currency = prefs.getInt("currencyCode");

        // var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
        //     Map<String, dynamic>();

        //     String sesionId = prefs.getString(Constants.sessionId);

        print('OrderPlaceFetch:${Constants.deviceUUID}');

        parameters['session_id'] = Constants.deviceUUID;
        parameters['paymentId'] = event.paymentId;
        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';

        parameters['lang'] = Constants.selectedLang;
        parameters['device_token'] = Constants.deviceUUID;
        if (currency != null) {
          parameters['currency'] = currency;
        }
        final orderPlacedResponse =
            await _paymentRepository.orderPlaced(parameters);
        if (orderPlacedResponse.message == 'success') {
          yield OrderPlaceLoaded(orderPlacedResponse);
        } else {
          yield OrderPlaceError('Error in Placing the Order');
        }
      } catch (e) {
        yield OrderPlaceError('Error in Contacting the Server');
      }
    }
  }

  @override
  PaymentCheckState get initialState => PaymentCheckInitial();
}
