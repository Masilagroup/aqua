// @dart=2.9
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aqua/Account/MyOrders/bloc/order_repository.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersListRepository ordersListRepository = OrdersListRepository();
  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is OrdersListFetch) {
      try {
        yield OrdersListLoading('Loading..');

        Map<String, dynamic> parameters = Map<String, dynamic>();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
        //     Map<String, dynamic>();
        if (Constants.isSignIN) {
          var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
              Map<String, dynamic>();
          parameters['user_id'] = userData['data']['user_id'];
          parameters['access_token'] =
              userData['data']['user_api_access_token'];
        }

        parameters['lang'] = Constants.selectedLang;
        parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
        parameters['device_token'] = Constants.deviceUUID;

        // String sesionId = prefs.getString(Constants.deviceToken);
        // parameters['session_id'] = sesionId;
        final ordersListResponse =
            await ordersListRepository.getOrdersListData(parameters);
        if (ordersListResponse.message == 'success') {
          yield OrdersListLoaded(ordersListResponse);
        } else {
          yield OrdersListError('${ordersListResponse.info}');
        }
      } catch (e) {
        yield OrdersListError('Error in Contacting the Server');
      }
    }
  }

  @override
  OrdersState get initialState => OrdersInitial();
}
