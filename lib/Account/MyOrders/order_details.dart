// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:aqua/Account/MyOrders/bloc/order_repository.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_bloc.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/Account/MyOrders/order_details_productItem.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  final OrderListData orderListData;
  const OrderDetails({Key key, this.orderListData}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  double globalMediaWidth = 0.0;
  OrdersBloc _ordersBloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  OrderListData localOrderListData = OrderListData();

  @override
  void initState() {
    super.initState();
    _ordersBloc = OrdersBloc();
    localOrderListData = widget.orderListData;
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: new AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 25,
          ),
          onPressed: () {
            Constants.selectedProductIds = [];
            Navigator.pop(context, localOrderListData);
          },
        ),
        title: Text(
          AppLocalizations.of(context).translate('orderDetails'),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: <Widget>[
            _orderDetailsCard(),
            _addressCard(),
            Padding(padding: const EdgeInsets.only(top: 10)),
            _cancelButtonPlaceHolder(context),
            Padding(padding: const EdgeInsets.only(top: 20)),
            _productDetails(),
            _totalsCard(),
            Padding(padding: const EdgeInsets.only(top: 20)),
          ],
        ),
      ),
    );
  }

  Widget _addressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Card(
        elevation: 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(top: 10, left: 10, bottom: 10)
                  : EdgeInsets.only(top: 10, right: 10, bottom: 10),
              alignment:
                  AppLocalizations.of(context).locale.languageCode == 'en'
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
              child: Text(
                AppLocalizations.of(context).translate('shippingAddress'),
                style: TextStyle(
                  color: AppColors.BLACK_COLOR,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 10)
                  : EdgeInsets.only(right: 10, top: 10),
              child: Text(
                '${AppLocalizations.of(context).translate('name')} : ${localOrderListData.shippingDetails.shippingName}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('mobile')} : ${localOrderListData.shippingDetails.shippingMobile}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('email')} : ${localOrderListData.shippingDetails.shippingEmail}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(padding: const EdgeInsets.all(5)),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('country')} : ${localOrderListData.shippingDetails.shippingCountryName}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('area')} : ${localOrderListData.shippingDetails.shippingArea}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('block')} : ${localOrderListData.shippingDetails.shippingBlock}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
              padding: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 5)
                  : EdgeInsets.only(right: 10, top: 5),
              child: Text(
                '${AppLocalizations.of(context).translate('street')} : ${localOrderListData.shippingDetails.shippingStreet}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(padding: const EdgeInsets.all(10))
          ],
        ),
      ),
    );
  }

  Widget _orderDetailsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 1.0,
        child: Column(
          children: <Widget>[
            _totalCardRow(
                '${AppLocalizations.of(context).translate('referenceID')} :',
                localOrderListData.refId.toString(),
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                '${AppLocalizations.of(context).translate('invoiceID')} :',
                localOrderListData.invoiceNo.toString(),
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                '${AppLocalizations.of(context).translate('orderDate')} :',
                localOrderListData.orderDate,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                '${AppLocalizations.of(context).translate('paymentStatus')} :',
                localOrderListData.paymentStatusTxt,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                '${AppLocalizations.of(context).translate('orderStatus')} :',
                localOrderListData.orderStatusTxt,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
          ],
        ),
      ),
    );
  }

  Widget _totalsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 1.0,
        child: Column(
          children: <Widget>[
            _totalCardRow(
                AppLocalizations.of(context).translate('subTotal'),
                localOrderListData.orderSubTotal,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                AppLocalizations.of(context).translate('discount'),
                localOrderListData.orderDiscount,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(
                AppLocalizations.of(context).translate('shipping'),
                localOrderListData.orderShippingPrice,
                Colors.green,
                Colors.green,
                FontWeight.w400),
            Divider(
              height: 1.0,
            ),
            _totalCardRow(
                AppLocalizations.of(context).translate('total'),
                localOrderListData.orderTotal,
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w800),
          ],
        ),
      ),
    );
  }

  Widget _totalCardRow(String leftItem, String rightItem, Color leftColor,
      Color rightColor, FontWeight fontWeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            leftItem,
            style: TextStyle(
              color: leftColor,
              fontSize: 14.0,
              fontWeight: fontWeight,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            rightItem,
            style: TextStyle(
              color: rightColor,
              fontSize: 14.0,
              fontWeight: fontWeight,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _productDetails() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                AppLocalizations.of(context).translate('orderItems'),
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Divider(
              height: 1,
            ),
            _titleForOrderSummary(),
            Divider(
              height: 1.0,
            ),
            _itemsList(),
          ],
        ),
      ),
    );
  }

  Widget _titleForOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context).translate('product'),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context).translate('total'),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
        ],
      ),
    );
  }

  _showMessage(String message) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  _showSuccessMessage(String message) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ],
      ),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  _processCancelOrder() async {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(
          AppLocalizations.of(context).translate('loading'),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );

    OrdersListRepository _ordersListRepository = OrdersListRepository();
    Map<String, dynamic> parameters = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Constants.isSignIN) {
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      parameters['user_id'] = userData['data']['user_id'];
      parameters['access_token'] = userData['data']['user_api_access_token'];
    }

    parameters['items'] = Constants.selectedProductIds;
    parameters['oid'] = localOrderListData.id;

    parameters['lang'] = Constants.selectedLang;
    parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
    parameters['device_token'] = Constants.deviceUUID;

    print(parameters);

    await _ordersListRepository
        .cancelOrders(parameters)
        .then((orderCancelResponse) {
      print(orderCancelResponse);
      if (orderCancelResponse.message == 'success') {
        setState(() {
          if (orderCancelResponse.data.orders.length > 0) {
            localOrderListData = orderCancelResponse.data.orders[0];
          }
        });
        _showSuccessMessage(
            '${orderCancelResponse.info} \n New Invoice No : ${orderCancelResponse.data.cancelInvoiceNo}');
      } else {
        _showMessage('${orderCancelResponse.info}}');
      }
    });
  }

  _processReturnOrder() async {
    ScaffoldMessenger.of(_scaffoldKey.currentContext).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 500),
        content: Text(
          AppLocalizations.of(context).translate('loading'),
        ),
        backgroundColor: Colors.greenAccent,
      ),
    );

    OrdersListRepository _ordersListRepository = OrdersListRepository();
    Map<String, dynamic> parameters = new Map<String, dynamic>();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (Constants.isSignIN) {
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      parameters['user_id'] = userData['data']['user_id'];
      parameters['access_token'] = userData['data']['user_api_access_token'];
    }

    parameters['items'] = Constants.selectedProductIds;
    parameters['oid'] = localOrderListData.id;

    parameters['lang'] = Constants.selectedLang;
    parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
    parameters['device_token'] = Constants.deviceUUID;

    print(parameters);

    await _ordersListRepository
        .returnOrders(parameters)
        .then((orderCancelResponse) {
      print(orderCancelResponse);
      if (orderCancelResponse.message == 'success') {
        setState(() {
          if (orderCancelResponse.data.orders.length > 0) {
            localOrderListData = orderCancelResponse.data.orders[0];
          }
        });
        _showSuccessMessage('${orderCancelResponse.info}');
      } else {
        _showMessage('${orderCancelResponse.info}}');
      }
    });
  }

  Widget _cancelButtonPlaceHolder(BuildContext context) {
    if (localOrderListData.canCancel != 0) {
      return Container(
        height: 30,
        width: globalMediaWidth * 0.7,
        margin: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          onPressed: () {
            Constants.selectedProductIds.length <= 0
                ? _showMessage(
                    AppLocalizations.of(context)
                        .translate('pleaseSelectItemtoCancel'),
                  )
                : _processCancelOrder();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.red,
                ),
              )),
          // color: Colors.white,
          child: Text(
            AppLocalizations.of(context).translate('cancelOrder'),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // shape: new RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   side: BorderSide(
          //     color: Colors.red,
          //   ),
          //  ),
        ),
      );
    }
    if (localOrderListData.canReturn != 0) {
      return Container(
        height: 30,
        width: globalMediaWidth * 0.7,
        margin: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
          onPressed: () {
            Constants.selectedProductIds.length <= 0
                ? _showMessage(
                    AppLocalizations.of(context)
                        .translate('pleaseSelectItemtoReturn'),
                  )
                : _processReturnOrder();
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.red,
                ),
              )),
          // color: Colors.white,
          child: Text(
            AppLocalizations.of(context).translate('return'),
            style: Theme.of(context).textTheme.bodyText2,
          ),
          // shape: new RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(20),
          //   side: BorderSide(
          //     color: Colors.red,
          //   ),
          // ),
        ),
      );
    }
    // if (localOrderListData.isCancel != 0) {
    //   return Container(
    //     padding: const EdgeInsets.all(15),
    //     child: Text(
    //       AppLocalizations.of(context).translate('cancelled'),
    //       style: TextStyle(
    //         color: Colors.red,
    //         fontSize: 16.0,
    //         fontWeight: FontWeight.w600,
    //         fontFamily: 'Montserrat',
    //       ),
    //     ),
    //   );
    // }
    return Container();
  }

  Widget _itemsList() {
    return Column(
      children: List.generate(localOrderListData.orderItems.length, (index) {
        return OrderDetailsProductItem(
          type: localOrderListData.paymentStatusTxt,
          orderItem: localOrderListData.orderItems[index],
        );
        // return Container(
        //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       Container(
        //         width: globalMediaWidth * 0.65,
        //         child: Text(
        //           '${localOrderListData.orderItems[index].productTitle} X ${localOrderListData.orderItems[index].productQuantity}',
        //           softWrap: true,
        //           overflow: TextOverflow.ellipsis,
        //           maxLines: 1,
        //           style: Theme.of(context).textTheme.body2,
        //         ),
        //       ),
        //       Container(
        //         child: Text(
        //           '${localOrderListData.orderItems[index].productPrice}',
        //           style: Theme.of(context).textTheme.body2,
        //         ),
        //       ),
        //     ],
        //   ),
        // );
      }),
    );
  }
}
