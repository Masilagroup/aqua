// @dart=2.9
import 'package:aqua/Account/MyOrders/bloc/orders_bloc.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_response.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderDetailsProductItem extends StatefulWidget {
  final OrderItem orderItem;
  final String type;
  OrderDetailsProductItem({Key key, this.orderItem, this.type})
      : super(key: key);

  @override
  _OrderDetailsProductItemState createState() =>
      _OrderDetailsProductItemState();
}

class _OrderDetailsProductItemState extends State<OrderDetailsProductItem> {
  int itemCount = 1;
  double individualTotal = 6.95;
  double itemCost = 6.95;
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    // _ordersBloc = BlocProvider.of<OrdersBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.WHITE_COLOR,
        border: Border(
          bottom: BorderSide(
            color: AppColors.LIGHT_GRAY_BGCOLOR,
            width: 0.2,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Visibility(
            visible: showCheckBox(),
            child: Checkbox(
                value: isSelected,
                onChanged: (value) {
                  setState(() {
                    isSelected = value;
                    if (isSelected == true) {
                      Constants.selectedProductIds
                          .add(widget.orderItem.productItemId);
                    } else {
                      Constants.selectedProductIds
                          .remove(widget.orderItem.productItemId);
                    }
                  });
                }),
          ),
          Container(
              alignment: Alignment.center,
              width: globalMediaWidth * 0.25,
              //    margin: const EdgeInsets.only(left: 10, top: 10),
              padding: const EdgeInsets.all(10),
              child: Image.network(
                '${widget.orderItem.productImage}',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              )
              // Image.asset(
              //   'assets/demoImages/AquaDemo2.jpg',
              //   fit: BoxFit.cover,
              // ),
              ),
          Container(
            margin: const EdgeInsets.only(
              top: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: globalMediaWidth * 0.4,
                  child: Text(
                    // 'WIDE-LEG KNIT TROUSERS',
                    '${widget.orderItem.productTitle.toUpperCase()}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.only(top: 8),
                //   child: Text(
                //     'Malibu Travel Scarlet',
                //     style: Theme.of(context).textTheme.body2,
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  child: Text(
                    '${AppLocalizations.of(context).translate('size')} : ${widget.orderItem.productProductSize.sizeName}',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                _colorBlock(),
                _itemStatusMessage(),
                //  _cancelButtonPlaceHolder(context),
              ],
            ),
          ),
          _totalPriceBlock(),
        ],
      ),
    );
  }

  Widget _itemStatusMessage() {
    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 10),
      color: Colors.greenAccent.withOpacity(0.3),
      child: Text(
        _itemUserMessage(),
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }

  bool showCheckBox() {
    if (widget.type == AppLocalizations.of(context).translate('failed')) {
      return false;
    }
    if ((widget.orderItem.productIsCancel == 0) &&
        (widget.orderItem.productisReturn == 0) &&
        (widget.orderItem.productisReturnRequest == 0)) {
      return true;
    } else {
      return false;
    }
  }

  String _itemUserMessage() {
    String userMessage = '';
    if ((widget.orderItem.productisReturnRequest == 1) &&
        (widget.orderItem.productisReturn == 0)) {
      userMessage =
          AppLocalizations.of(context).translate('waitingForApproval');
    } else {
      userMessage = '';
      if (widget.orderItem.productisReturn == 1) {
        userMessage =
            AppLocalizations.of(context).translate('returnRequestApproved');
      } else {
        userMessage = '';
      }
    }

    return userMessage;
  }

  Widget _colorBlock() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 20,
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            '${AppLocalizations.of(context).translate('color')}: ',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.bottomCenter,
          margin: AppLocalizations.of(context).locale.languageCode == 'en'
              ? EdgeInsets.only(left: 10, top: 10)
              : EdgeInsets.only(right: 10, top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            color: Constants.hexToColor(
                widget.orderItem.productProductColor.colorCode),
            border: Border.all(
              color: AppColors.DEEP_LIGHT_GRAY,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _totalPriceBlock() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          margin: AppLocalizations.of(context).locale.languageCode == 'en'
              ? EdgeInsets.only(left: 10, top: 10)
              : EdgeInsets.only(right: 10, top: 10),
          child: Text(
            '${widget.orderItem.productTotalPrice}',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ],
    );
  }
}
