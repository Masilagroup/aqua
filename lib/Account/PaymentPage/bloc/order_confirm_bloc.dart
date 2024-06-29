// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:aqua/Account/PaymentPage/bloc/payment_page_response.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_confirm_event.dart';
part 'order_confirm_state.dart';

class OrderConfirmBloc extends Bloc<OrderConfirmEvent, OrderConfirmState> {
  final PaymentRepository _paymentRepository = PaymentRepository();

  @override
  Stream<OrderConfirmState> mapEventToState(
    OrderConfirmEvent event,
  ) async* {
    if (event is OrderConfirmFetch) {
      yield OrderConfirmLoading('Loading..');

      try {
        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
            Map<String, dynamic>();

        String sesionId = prefs.getString(Constants.sessionId);
        parameters['session_id'] = sesionId;
        String couponString = prefs.getString(Constants.aquaCouponData);

        if (couponString != '') {
          var couponResponse = CouponResponse.fromRawJson(
              prefs.getString(Constants.aquaCouponData) ?? {});

          if (couponResponse != null) {
            parameters['coupon_code'] = couponResponse.data.cartCouponCode;
          }
        } else {
          //   parameters['coupon_code'] = 'AQUA7';
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
        parameters['payment_method'] = event.paymentMethod;

        final orderConfirmResponse =
            await _paymentRepository.confirmOrder(parameters);
        if (orderConfirmResponse.message == 'success' &&
            parameters['payment_method'] != 'cod') {
          yield OrderConfirmLoaded(orderConfirmResponse);
        } else if (orderConfirmResponse.message == 'success' &&
            parameters['payment_method'] == 'cod') {
          yield OrderPlacedForCOD(orderConfirmResponse);
        } else {
          yield OrderConfirmError('paymentcheckResponse.info');
        }
      } catch (e) {
        print("OOqOO");
        print(e);
        print("OOqOO");
        yield OrderConfirmError('Error in While Connecting Server');
      }
    }
  }

  @override
  // TODO: implement initialState
  OrderConfirmState get initialState => OrderConfirmInitial();
}
