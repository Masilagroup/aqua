// @dart=2.9
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/utils/constants.dart';

class OrdersListRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<OrdersListResponse> getOrdersListData(
      Map<String, dynamic> parameters) async {
    final listOrders = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.ORDERS_LIST, parameters);
    return OrdersListResponse.fromJson(listOrders);
  }

  List<List<OrderListData>> sortOrders(List<OrderListData> list) {
    var processingList = list
        .where((x) => ((x.orderStatusTxt == "Pending") &&
            (x.paymentStatusTxt != "Failed")))
        .toList();
    var completedList =
        list.where((x) => (x.orderStatusTxt == "Delivered")).toList();
    var cancelledList =
        list.where((x) => (x.paymentStatusTxt == "Failed")).toList();
    return [processingList, completedList, cancelledList];
  }

  Future<OrderCancelResponse> cancelOrders(
      Map<String, dynamic> parameters) async {
    final cancelOrderData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.CANCEL_ORDER, parameters);
    return OrderCancelResponse.fromJson(cancelOrderData);
  }

  Future<OrderCancelResponse> returnOrders(
      Map<String, dynamic> parameters) async {
    final cancelOrderData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.RETURN_ORDER, parameters);
    return OrderCancelResponse.fromJson(cancelOrderData);
  }
}
