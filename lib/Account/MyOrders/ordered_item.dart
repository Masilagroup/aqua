// @dart=2.9
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/Account/MyOrders/order_details.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';

class OrderedItem extends StatefulWidget {
  final int orderType;
  final OrderListData orderListData;
  OrderedItem({Key key, this.orderType, this.orderListData}) : super(key: key);

  @override
  _OrderedItemState createState() => _OrderedItemState();
}

class _OrderedItemState extends State<OrderedItem> {
  double globalMediaWidth = 0.0;

  double globalMediaHeight = 0.0;

  OrderListData localOrderListData;

  @override
  void initState() {
    super.initState();
    localOrderListData = widget.orderListData;
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _orderIDRow(),
          Container(
            margin: AppLocalizations.of(context).locale.languageCode == 'en'
                ? EdgeInsets.only(left: 10)
                : EdgeInsets.only(right: 10),
            child: Text(
              '${AppLocalizations.of(context).translate('referenceID')} :  ${localOrderListData.refId}',
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.left,
            ),
          ),
          _qtyAmountRow(),
          _buttonsRow(context),
        ],
      ),
    );
  }

  Widget _orderIDRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            '${AppLocalizations.of(context).translate('invoiceID')} : ${localOrderListData.invoiceNo}',
            style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            localOrderListData.transactionDetails.transactionDate,
            style: TextStyle(
              color: AppColors.TEXT_GRAY_COLOR,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _qtyAmountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            '${AppLocalizations.of(context).translate('totalQuantity')}: ${localOrderListData.orderTotalQuantity}',
            style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            '${AppLocalizations.of(context).translate('total')}: ${localOrderListData.orderTotal}',
            style: TextStyle(
              color: AppColors.TEXT_GRAY_COLOR,
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttonsRow(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            // margin: const EdgeInsets.only(bottom: 10),
            height: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderDetails(
                            orderListData: localOrderListData,
                          ),
                      fullscreenDialog: false),
                ).then((updatedItem) {
                  if (updatedItem != null) {
                    localOrderListData = updatedItem;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.WHITE_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: AppColors.BLACK_COLOR,
                    ),
                  )),
              //  color: AppColors.WHITE_COLOR,
              child: Text(
                AppLocalizations.of(context).translate('details'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              // shape: new RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              //   side: BorderSide(
              //     color: AppColors.BLACK_COLOR,
              //   ),
              // ),
            ),
          ),
          // Container(
          //   height: 30,
          //   margin: const EdgeInsets.only(top: 10),
          //   child: RaisedButton(
          //     onPressed: () {},
          //     color: Colors.white,
          //     child: Text(
          //       'CANCEL ORDER',
          //       style: Theme.of(context).textTheme.body2,
          //     ),
          //     shape: new RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //       side: BorderSide(
          //         color: Colors.red,
          //       ),
          //     ),
          //   ),
          // ),
          //     _cancelButtonPlaceHolder(widget.orderType, context),
        ],
      ),
    );
  }

  Widget _cancelButtonPlaceHolder(int value, BuildContext context) {
    print(localOrderListData.canCancel);
    switch (value) {
      case 0:
        return localOrderListData.canCancel != 0
            ? Container(
                height: 30,
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  // color: Colors.white,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.red,
                        ),
                      )),
                  child: Text(
                    AppLocalizations.of(context).translate('cancelOrder'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  // shape: new RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  //   side: BorderSide(
                  //     color: Colors.red,
                  //   ),
                  // ),
                ),
              )
            : Container();
        break;
      case 1:
        // return Container(
        //   padding: const EdgeInsets.all(5),
        //   child: Text(
        //     'Delivered',
        //     style: TextStyle(
        //       color: Colors.green,
        //       fontSize: 16.0,
        //       fontWeight: FontWeight.w600,
        //       fontFamily: 'Montserrat',
        //     ),
        //   ),
        // );
        return localOrderListData.canReturn != 0
            ? Container(
                height: 30,
                margin: const EdgeInsets.only(top: 5),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: Colors.green,
                        ),
                      )),
                  child: Text(
                    AppLocalizations.of(context).translate('return'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  // shape: new RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  //   side: BorderSide(
                  //     color: Colors.green,
                  //   ),
                  // ),
                ),
              )
            : Container();
        break;
      case 2:
        return Container(
          padding: const EdgeInsets.all(5),
          child: Text(
            AppLocalizations.of(context).translate('cancelled'),
            style: TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              fontFamily: 'Montserrat',
            ),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }
}
