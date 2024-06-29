// @dart=2.9
import 'dart:convert';

import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<CartListResponse> getCartList(Map<String, dynamic> parameters) async {
    final cartListResponse = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.CART_LIST_URL, parameters);
    return CartListResponse.fromJson(cartListResponse);
  }

  Future<CartListResponse> addtoCart(Map<String, dynamic> parameters) async {
    final cartListResponse = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.ADD_TO_CART_URL, parameters);
    return CartListResponse.fromJson(cartListResponse);
  }

  Future<CartListResponse> delteFromCart(
      Map<String, dynamic> parameters) async {
    print(parameters);
    final cartListResponse = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.DELETE_FROM_CART_URL, parameters);
    return CartListResponse.fromJson(cartListResponse);
  }

  Future<void> couponApply(
      Map<String, dynamic> parameters, SharedPreferences prefs) async {
    final couponResponse = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.CART_COUPON_CODE, parameters);

    // print(couponResponse.fromRawJson());
    prefs.setString(Constants.aquaCouponData,
        json.encode(CouponResponse.fromJson(couponResponse)));
    //  prefs.setString(Constants.aquaCouponData, couponResponse.toRawJson());
  }

  Future<void> removeCoupon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.aquaCouponData, '');
  }
}
