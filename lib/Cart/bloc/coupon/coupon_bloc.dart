// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aqua/Cart/bloc/cart_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final CartRepository cartRepository = CartRepository();

  @override
  Stream<CouponState> mapEventToState(
    CouponEvent event,
  ) async* {
    if (event is CouponCheck) {
      try {
        yield CartCouponLoading('Loading..');
        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //       String sesionId = prefs.getString(Constants.sessionId);
        parameters['session_id'] = Constants.deviceUUID;
        print(event.couponCode);
        parameters['coupon_code'] = event.couponCode;

        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
        parameters['device_token'] = Constants.deviceUUID;

        if (Constants.isSignIN) {
          var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
              Map<String, dynamic>();
          parameters['user_id'] = userData['data']['user_id'];
          print(userData['data']['user_id']);
        }
        await cartRepository.couponApply(parameters, prefs);

        var couponResponse = CouponResponse.fromRawJson(
            prefs.getString(Constants.aquaCouponData));

        if (couponResponse.message == 'success') {
          yield CartCouponLoaded(couponResponse);
        } else {
          yield CartCouponError(couponResponse.info);
        }
      } catch (e) {
        yield CartCouponError('Error in Connecting Server');
      }
    }
  }

  @override
  CouponState get initialState => CouponInitial();
}
