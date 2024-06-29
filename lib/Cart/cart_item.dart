// @dart=2.9
import 'package:aqua/Cart/bloc/cart_bloc.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartItem extends StatefulWidget {
  final CartItemData cartItemData;
  CartItem({Key key, this.cartItemData}) : super(key: key);

  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  int itemCount = 1;
  double individualTotal = 6.95;
  double itemCost = 6.95;
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  CartBloc _cartBloc;

  @override
  void initState() {
    super.initState();
    _cartBloc = BlocProvider.of<CartBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<CartBloc, CartState>(
      bloc: _cartBloc,
      builder: (context, state) {
        return InkWell(
          onTap: () {
            print('${Slidable.of(context)?.renderingMode}');
            Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
                ? Slidable.of(context)?.open()
                : Slidable.of(context)?.close();
          },
          child: Container(
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
                Container(
                  alignment: Alignment.center,
                  width: globalMediaWidth * 0.22,
                  //    margin: const EdgeInsets.only(left: 10, top: 10),
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: CachedNetworkImage(
                    imageUrl: widget.cartItemData.cartImage,
                    imageBuilder: (context, imageProvider) => Container(
                      width: globalMediaWidth * 0.22,
                      height: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: Icon(Icons.error)),
                  ),
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
                        width: globalMediaWidth * 0.50,
                        child: Text(
                          // 'WIDE-LEG KNIT TROUSERS',
                          '${widget.cartItemData.cartTitle.toUpperCase()}',
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
                          '${AppLocalizations.of(context).translate('size')} : ${widget.cartItemData.size.sizeName}',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ),
                      _colorBlock(),
                      _increaseDecreseBlock(state),
                    ],
                  ),
                ),
                _totalPriceBlock(state),
              ],
            ),
          ),
        );
      },
    );
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
              color: Constants.hexToColor(widget.cartItemData.color.colorCode),
              border: Border.all(
                color: AppColors.DEEP_LIGHT_GRAY,
                width: 2,
              )
              // : Border.all(
              //     color: Colors.transparent,
              //     width: 2,
              //   ),
              ),
        ),
      ],
    );
  }

  Widget _increaseDecreseBlock(CartState state) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              // setState(() {
              //   if (itemCount > 1) {
              //     itemCount = itemCount - 1;
              //   } else {
              //     itemCount = 1;
              //   }
              //   individualTotal = itemCount * itemCost;
              // });

              if (widget.cartItemData.cartQuantity > 1) {
                _cartBloc.add(
                  CartAddEvent(
                    widget.cartItemData.cartProductId,
                    widget.cartItemData.size.sizeId,
                    widget.cartItemData.color.colorId,
                    (widget.cartItemData.cartQuantity - 1),
                  ),
                );
              } else {
                _cartBloc.add(CartDeleteEvent(widget.cartItemData.cartId));
              }
            },
            child: Container(
              height: 25,
              width: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.LIGHT_GRAY_BGCOLOR,
                  width: 0.3,
                ),
              ),
              child: Text(
                '-',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    color: AppColors.BLACK_COLOR),
              ),
            ),
          ),
          Container(
            height: 25,
            width: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.LIGHT_GRAY_BGCOLOR,
                width: 0.3,
              ),
            ),
            child: Text(
              '${widget.cartItemData.cartQuantity}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  color: AppColors.BLACK_COLOR),
            ),
          ),
          InkWell(
            onTap: () {
              // setState(() {
              //   itemCount = itemCount + 1;
              //   individualTotal = itemCount * itemCost;
              // });
              _cartBloc.add(
                CartAddEvent(
                  widget.cartItemData.cartProductId,
                  widget.cartItemData.size.sizeId,
                  widget.cartItemData.color.colorId,
                  (widget.cartItemData.cartQuantity + 1),
                ),
              );
            },
            child: Container(
              height: 25,
              width: 25,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.LIGHT_GRAY_BGCOLOR,
                  width: 0.3,
                ),
              ),
              child: Text(
                '+',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    color: AppColors.BLACK_COLOR),
              ),
            ),
          ),
          _priceBlock(),
        ],
      ),
    );
  }

  void _decreaseAction() {
    if (widget.cartItemData.cartQuantity == 1) {}
  }

  // String _updateQuantity(CartState state) {
  //   String qty = '';
  //   if (state is CartListLoaded) {
  //     qty = state.cartListResponse.data.cartTotalQuantity.toString();
  //   }
  //   if (state is CartAddLoaded) {
  //     qty = state.cartListResponse.data.cartTotalQuantity.toString();
  //   }
  // }

  Widget _priceBlock() {
    return Container(
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 10)
          : EdgeInsets.only(right: 10),
      child: Column(
        children: <Widget>[
          Text(
            '${widget.cartItemData.cartPrice}',
            style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontFamily: 'Montserrat',
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _totalPriceBlock(CartState state) {
    return Container(
      alignment: Alignment.centerRight,
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(right: 10, top: 10)
          : EdgeInsets.only(left: 10, top: 10),
      child: Text(
        '${widget.cartItemData.cartProductTotalPrice}',
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}
