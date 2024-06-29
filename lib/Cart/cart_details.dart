// @dart=2.9
import 'package:aqua/Account/AddressList/address_page_authentication.dart';
import 'package:aqua/Cart/bloc/cart_bloc.dart';
import 'package:aqua/Cart/bloc/cart_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/Cart/bloc/coupon/coupon_bloc.dart';
import 'package:aqua/Cart/cart_item.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartDetailsPage extends StatefulWidget {
  CartDetailsPage({Key key}) : super(key: key);

  @override
  _CartDetailsPageState createState() => _CartDetailsPageState();
}

class _CartDetailsPageState extends State<CartDetailsPage> {
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  double listFactor = 0.70;
  double summaryFactor = 0.15;
  GlobalKey _keyAppBar = GlobalKey();
  double height = 200;
  CartBloc _cartBloc = CartBloc();
  CouponBloc _couponBloc = CouponBloc();
  String couponText = 'Coupon';
  String couponTextAR = "كوبون";
  String couponValue = '0.00';
  String afterDiscount = "0.0";

  TextEditingController couponController = TextEditingController();

  bool couponAdded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    _cartBloc = BlocProvider.of<CartBloc>(context);
    _cartBloc.add(CartListFetch());
  }

  _afterLayout(_) {
    final RenderBox renderAppBar = _keyAppBar.currentContext.findRenderObject();

    setState(() {
      print(renderAppBar.size.height);
      height = renderAppBar.size.height * 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.LIGHT_GRAY_BGCOLOR.withOpacity(0.2),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        key: _keyAppBar,
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context).translate('shoppingCart'),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocListener<CartBloc, CartState>(
        bloc: _cartBloc,
        listener: (context, state) {
          if (state is CartAddError) {
            print('${state.errorMessage}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartListLoading || state is CartInitial) {
              return Center(child: AquaProgressIndicator());
            }
            if (state is CartListError) {
              return Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.refresh,
                      ),
                      onPressed: () {
                        _cartBloc.add(CartListFetch());
                      },
                    ),
                    Text(
                      '${state.errorMessage}',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              );
            }
            if (state is CartAddErrorRetainState) {
              print(state.cartListResponse.data.cartItems.length);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: _cartList(state),
                  ),
                  _summaryDetails(state),
                ],
              );
            }
            if (state is CartListLoaded) {
              return Column(
                children: <Widget>[
                  Expanded(child: _cartList(state)),
                  _summaryDetails(state),
                ],
              );
            }
            if (state is CartAddLoaded) {
              print(state.cartListResponse.data.cartItems.length);
              return Column(
                children: <Widget>[
                  Expanded(child: _cartList(state)),
                  _summaryDetails(state),
                ],
              );
            }
            if (state is CartDeleteLoaded) {
              print(state.cartListResponse.data.cartItems.length);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: _cartList(state),
                  ),
                  _summaryDetails(state),
                ],
              );
            }
            if (state is CartDeleteErrorRetainState) {
              print(state.cartListResponse.data.cartItems.length);
              return Column(
                children: <Widget>[
                  Expanded(
                    child: _cartList(state),
                  ),
                  _summaryDetails(state),
                ],
              );
            }
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                    ),
                    onPressed: () {
                      _cartBloc.add(CartListFetch());
                    },
                  ),
                  Text(
                    AppLocalizations.of(context).translate('reload'),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  int _cartItemCount(CartState state) {
    if (state is CartListLoaded) {
      return state.cartListResponse.data.cartItems.length;
    } else if (state is CartAddLoaded) {
      return state.cartListResponse.data.cartItems.length;
    } else if (state is CartAddErrorRetainState) {
      return state.cartListResponse.data.cartItems.length;
    } else if (state is CartDeleteLoaded) {
      return state.cartListResponse.data.cartItems.length;
    } else if (state is CartDeleteErrorRetainState) {
      return state.cartListResponse.data.cartItems.length;
    } else {
      return 0;
    }
  }

  CartItemData _getCartItemData(CartState state, index) {
    if (state is CartListLoaded) {
      return state.cartListResponse.data.cartItems[index];
    } else if (state is CartAddLoaded) {
      return state.cartListResponse.data.cartItems[index];
    } else if (state is CartAddErrorRetainState) {
      return state.cartListResponse.data.cartItems[index];
    } else if (state is CartDeleteLoaded) {
      return state.cartListResponse.data.cartItems[index];
    } else if (state is CartDeleteErrorRetainState) {
      return state.cartListResponse.data.cartItems[index];
    } else {
      return CartItemData();
    }
  }

  Widget _cartList(CartState state) {
    return Container(
      height: globalMediaHeight - height - (globalMediaHeight * summaryFactor),
      child: ListView.builder(
        cacheExtent: 10000,
        itemCount: _cartItemCount(state),
        scrollDirection: Axis.vertical,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            closeOnScroll: true,
            key: ValueKey(index),
            dismissal: SlidableDismissal(
              child: SlidableDrawerDismissal(),
              onDismissed: (actionType) {
                _cartBloc.add(
                    CartDeleteEvent(_getCartItemData(state, index).cartId));
              },
            ),
            child: CartItem(
              cartItemData: _getCartItemData(state, index),
            ),
            actionPane: SlidableDrawerActionPane(),
            actions: <Widget>[],
            secondaryActions: <Widget>[
              IconSlideAction(
                color: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  _cartBloc.add(
                      CartDeleteEvent(_getCartItemData(state, index).cartId));
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryDetails(CartState state) {
    // print(globalMediaHeight);
    // print(globalMediaHeight * listFactor);

    // print(globalMediaHeight * summaryFactor);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        //  height: globalMediaHeight * summaryFactor,
        //  width: globalMediaWidth,
        color: AppColors.WHITE_COLOR,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _addRemoveCouponCode(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '${AppLocalizations.of(context).translate('total').toUpperCase()} : ',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _cartListSubTotal(state),
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: couponAdded,
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            AppLocalizations.of(context).locale.languageCode ==
                                    'en'
                                ? couponText
                                : couponTextAR,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                            couponValue,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${AppLocalizations.of(context).translate('total').toUpperCase()}  : ',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                                Text(
                                  '(${AppLocalizations.of(context).translate('couponDiscountApplied')})',
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(color: Colors.grey),
                                )
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              afterDiscount ?? "KWD 0.00",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _cartItemCount(state) > 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressAuthentication(),
                          fullscreenDialog: false,
                        ),
                      )
                    : _showNOItemsINCart();
              },
              child: Container(
                margin: const EdgeInsets.only(top: 15),
                width: globalMediaWidth * 0.35,
                height: 30,
                color: AppColors.BLACK_COLOR,
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context).translate('checkOut'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.WHITE_COLOR,
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          AppLocalizations.of(context).locale.languageCode ==
                                  'en'
                              ? 'Montserrat'
                              : 'Almarai',
                      fontStyle: FontStyle.normal),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNOItemsINCart() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate('noItemsInCart'),
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

  _showApplyCoupon() {
    couponController.text = '';
    Alert(
        context: context,
        title: AppLocalizations.of(context).translate('coupon'),
        content: Container(
          padding: const EdgeInsets.all(20),
          child: TextFormField(
            style: Theme.of(context).textTheme.bodyText1,
            controller: couponController,
            decoration: InputDecoration(
              icon: Icon(Icons.camera_alt),
              labelText: AppLocalizations.of(context).translate('couponCode'),
              labelStyle: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              _couponBloc.add(CouponCheck(couponController.text));
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('apply'),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  _removeCoupon() {
    setState(() {
      couponAdded = false;
      couponText = '';
      couponValue = '';
    });
    CartRepository _cartRepository = CartRepository();
    _cartRepository.removeCoupon();
  }

  Widget _addRemoveCouponCode() {
    return BlocListener<CouponBloc, CouponState>(
      bloc: _couponBloc,
      listener: (context, state) {
        if (state is CartCouponError) {
          setState(() {
            couponAdded = false;
          });
          print('${state.errorMessage}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 2000),
              content: Text('${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is CartCouponLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('${state.loadMessage}'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (state is CartCouponLoaded) {
          setState(() {
            couponAdded = true;
            couponValue = state.couponResponse.data.cartDiscount;
            couponText =
                '${AppLocalizations.of(context).translate('coupon')} (${state.couponResponse.data.cartCouponCode}) :';

            afterDiscount = state.couponResponse.data.cartTotal;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 2000),
              content: Text(
                AppLocalizations.of(context).translate('couponAdded'),
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: BlocBuilder<CouponBloc, CouponState>(
        bloc: _couponBloc,
        builder: (context, state) {
          return Container(
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 0, bottom: 10),
            child: InkWell(
              onTap: () {
                !couponAdded ? _showApplyCoupon() : _removeCoupon();
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    couponAdded ? Icons.remove_circle : Icons.add_circle,
                    size: 15,
                  ),
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      couponAdded
                          ? AppLocalizations.of(context)
                              .translate('removeCouponCode')
                          : AppLocalizations.of(context)
                              .translate('addCouponCode'),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _cartListSubTotal(CartState state) {
    if (state is CartListLoaded) {
      return state.cartListResponse.data.cartSubTotal;
    } else if (state is CartAddLoaded) {
      return state.cartListResponse.data.cartSubTotal;
    } else if (state is CartAddErrorRetainState) {
      return state.cartListResponse.data.cartSubTotal;
    } else if (state is CartDeleteLoaded) {
      return state.cartListResponse.data.cartSubTotal;
    } else if (state is CartDeleteErrorRetainState) {
      return state.cartListResponse.data.cartSubTotal;
    } else {
      return '';
    }
  }

  String _cartListTotal(CartState state) {
    if (state is CartListLoaded) {
      return state.cartListResponse.data.cartTotal;
    } else if (state is CartAddLoaded) {
      return state.cartListResponse.data.cartTotal;
    } else if (state is CartAddErrorRetainState) {
      return state.cartListResponse.data.cartTotal;
    } else if (state is CartDeleteLoaded) {
      return state.cartListResponse.data.cartTotal;
    } else if (state is CartDeleteErrorRetainState) {
      return state.cartListResponse.data.cartTotal;
    } else {
      return '';
    }
  }
}
