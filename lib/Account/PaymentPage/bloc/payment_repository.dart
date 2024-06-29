// @dart=2.9
import 'package:aqua/Account/PaymentPage/bloc/payment_page_response.dart';
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/utils/constants.dart';

class PaymentRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<PaymentCheckStatusResponse> getCartList(
      Map<String, dynamic> parameters) async {
    print(Constants.BASE_URL + Constants.PAYMENT_PAGE_CHECK);
    final cartListResponse = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.PAYMENT_PAGE_CHECK, parameters);
    print("*****");
    print(cartListResponse);
    print("*****");
    return PaymentCheckStatusResponse.fromJson(cartListResponse);
  }

  Future<OrderConfirmResponse> confirmOrder(
      Map<String, dynamic> parameters) async {
    print(Constants.BASE_URL + Constants.ORDER_CONFIRM);
    final orderConfirm = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.ORDER_CONFIRM, parameters);
    print("**&***");
    print(orderConfirm);
    print("**&***");
    return OrderConfirmResponse.fromJson(orderConfirm);
  }

  Future<OrderConfirmResponse> orderCashConfirm(
      Map<String, dynamic> parameters) async {
    final orderConfirm = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.ORDER_CASH_CONFIRM, parameters);
    return OrderConfirmResponse.fromJson(orderConfirm);
  }

  Future<OrderPlacedResponse> orderPlaced(
      Map<String, dynamic> parameters) async {
    final orderConfirm = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.PAYMENT_RESPONSE, parameters);
    return OrderPlacedResponse.fromJson(orderConfirm);
  }
}
