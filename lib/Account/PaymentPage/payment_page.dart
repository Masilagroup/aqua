// @dart=2.9
import 'package:aqua/Account/PaymentPage/bloc/order_confirm_bloc.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_check_bloc.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_page_response.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_repository.dart';
import 'package:aqua/Cart/bloc/cart_response.dart';
import 'package:aqua/Navbar/navbar.dart';
import 'package:aqua/global.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart' as myfathoorah;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../utils/app_colors.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isCOD = false;
  bool isCODAvailable = false;
  bool isKNET = false;
  bool isVISA = false;
  bool isVISAUAE = false;

  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  bool isCouponApplied = false;
  double height = 160;
  GlobalKey _keyAppBar = GlobalKey();
  double summaryFactor = 0.15;
  PaymentCheckBloc _paymentCheckBloc;
  OrderConfirmBloc _orderConfirmBloc;
  String totalAmount;

  List<myfathoorah.PaymentMethods> paymentMethods = List();

  List<bool> isSelected = List();
  final PaymentRepository _paymentRepository = PaymentRepository();
  int selectedPaymentMethodIndex = -1;
  String _response = '';
  String _loading = "Loading...";
  bool paymentOptions = false;
  Map<String, dynamic> userData = Map<String, dynamic>();
  Map<String, dynamic> parameters = Map<String, dynamic>();
  OrderConfirmResponse _orderConfirmResponse = OrderConfirmResponse();
  var currency;
  @override
  void initState() {
    super.initState();
    _paymentCheckBloc = BlocProvider.of<PaymentCheckBloc>(context)
      ..add(PaymentCheckFetch());
    _orderConfirmBloc = OrderConfirmBloc();
    currency = prefs.getInt("currencyCode");
    myfathoorah.MFSDK
        .init(Constants.MY_FATHOORAH_MAIN_URL, Constants.directPaymentToken);
    initiatePayment();
  }

  // _showPaymentmethods() {
  //   Alert(
  //       context: context,
  //       title: "SELECT CARD",
  //       content: Container(
  //         height: 300,
  //         width: 200,
  //         child: ListView.builder(
  //             // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             //     crossAxisCount: 4, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
  //             itemCount: paymentMethods.length,
  //             itemBuilder: (BuildContext ctxt, int index) {
  //               return Row(
  //                 children: <Widget>[
  //                   Checkbox(
  //                       value: isSelected[index],
  //                       onChanged: (bool value) {
  //                         setState(() {
  //                           setPaymentMethodSelected(index, true);
  //                         });
  //                       }),
  //                   Image.network(paymentMethods[index].imageUrl,
  //                       width: 50.0, height: 50.0),
  //                 ],
  //               );
  //             }),
  //       ),
  //       buttons: [
  //         DialogButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text(
  //             "APPLY",
  //             style: TextStyle(color: Colors.white, fontSize: 20),
  //           ),
  //         )
  //       ]).show();
  // }

  void setPaymentMethodSelected(int index, bool value) {
    for (int i = 0; i < isSelected.length; i++) {
      if (i == index) {
        isSelected[i] = value;
        if (value) {
          selectedPaymentMethodIndex = index;
        } else {
          selectedPaymentMethodIndex = -1;
        }
      } else
        isSelected[i] = false;
    }
  }

  resetSelection() {
    if (selectedPaymentMethodIndex != -1) {
      setState(() {
        isSelected[selectedPaymentMethodIndex] = false;
        selectedPaymentMethodIndex = -1;
      });
    }
  }

  // filterFunction(List<myfathoorah.PaymentMethods> array) {
  //   // List<myfathoorah.PaymentMethods> filteredPaymentMethods =
  //   //     List<myfathoorah.PaymentMethods>();
  //   //  List<String> filteredIds = List<String>();
  //   filterCodes.forEach((filter) {
  //     print(filter);
  //     var element =
  //         array.where((x) => (x.paymentMethodCode == filter)).toList();
  //     filteredPaymentMethods.addAll(element);
  //     print(filteredPaymentMethods.length);
  //   });
  //   // filteredAmenities.forEach((f) {
  //   //   filteredIds.add(f.id.toString());
  //   // });
  //   //  return filteredPaymentMethods;
  // }

  void initiatePayment() {
    var request = new myfathoorah.MFInitiatePaymentRequest(
        double.parse('0.000'), myfathoorah.MFCurrencyISO.KUWAIT_KWD);

    myfathoorah.MFSDK.initiatePayment(
        request,
        myfathoorah.MFAPILanguage.EN,
        (myfathoorah.MFResult<myfathoorah.MFInitiatePaymentResponse> result) =>
            // ignore: sdk_version_set_literal
            {
              // ignore: sdk_version_ui_as_code
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    _response = ""; //result.response.toJson().toString();
                    paymentMethods.addAll(result.response.paymentMethods);
                    //   print(paymentMethods[5].paymentMethodCode);
                    //    filterFunction(paymentMethods);
                    for (int i = 0; i < paymentMethods.length; i++)
                      isSelected.add(false);
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        key: _keyAppBar,
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context).translate('payment'),
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: BlocListener<PaymentCheckBloc, PaymentCheckState>(
        listener: (context, state) {
          if (state is OrderPlaceLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                //   duration: Duration(milliseconds: 300),
                content: Text(
                  AppLocalizations.of(context).translate('loading'),
                ),
                backgroundColor: Colors.greenAccent,
              ),
            );
          }

          if (state is OrderPlaceLoaded) {
            Alert(
                context: context,
                title: '${state.orderPlacedResponse.data.responseMessage}',
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.all(10)),
                    Text(
                        '${AppLocalizations.of(context).translate('referenceID')} :    ${state.orderPlacedResponse.data.referenceId}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('trackId')} :    ${state.orderPlacedResponse.data.trackId}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('transactionID')} :    ${state.orderPlacedResponse.data.transactionId}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('paymentID')} :    ${state.orderPlacedResponse.data.paymentId}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('autherizationID')} :    ${state.orderPlacedResponse.data.authorizationId}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('orderReferenceID')} :    ${state.orderPlacedResponse.data.orderIds}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('result')} :    ${state.orderPlacedResponse.data.result}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('amount')} :    ${state.orderPlacedResponse.data.paidCurrency} ${state.orderPlacedResponse.data.paidCurrencyValue}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Text(
                        '${AppLocalizations.of(context).translate('orderStatus')} :    ${AppLocalizations.of(context).translate('success')}'),
                    Divider(
                      thickness: 0.2,
                    ),
                    Padding(padding: const EdgeInsets.all(10)),
                  ],
                ),
                buttons: [
                  DialogButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavBar(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).translate('ok'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
          }
        },
        child: BlocBuilder<PaymentCheckBloc, PaymentCheckState>(
            builder: (context, state) {
          if (state is PaymentCheckInitial) {
            return Center(child: AquaProgressIndicator());
          }
          if (state is PaymentCheckLoading) {
            return Center(
              child: AquaProgressIndicator(),
            );
          }
          if (state is OrderPlaceLoading) {
            return Center(
              child: Text(
                AppLocalizations.of(context).translate('pleaseWait'),
              ),
            );
          }
          if (state is PaymentCheckError) {
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
                      _paymentCheckBloc.add(PaymentCheckFetch());
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
          }
          if (state is PaymentCheckLoaded) {
            if (state.userData['data']['user_country_name']
                    .toString()
                    .toLowerCase() ==
                "kuwait") {
              isCODAvailable = true;
            }
            return Stack(
              children: <Widget>[
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _paymentOptions(state, isCODAvailable),
                      Padding(padding: const EdgeInsets.only(top: 10)),

                      _totalsCard(state),

                      _addressCard(state),

                      _alertCard(state),

                      //        _couponDetails(state),

                      _productDetails(state),
                      Padding(
                          padding: EdgeInsets.only(
                              bottom: globalMediaHeight * summaryFactor))
                    ],
                  ),
                ),
                // Visibility(
                //   visible: paymentOptions,
                //   child: Container(
                //     height: 300,
                //     width: 200,
                //     child: ListView.builder(
                //         // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                //         //     crossAxisCount: 4, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
                //         itemCount: paymentMethods.length,
                //         itemBuilder: (BuildContext ctxt, int index) {
                //           return Row(
                //             children: <Widget>[
                //               Checkbox(
                //                   value: isSelected[index],
                //                   onChanged: (bool value) {
                //                     setState(() {
                //                       setPaymentMethodSelected(index, true);
                //                     });
                //                   }),
                //               Image.network(paymentMethods[index].imageUrl,
                //                   width: 50.0, height: 50.0),
                //             ],
                //           );
                //         }),
                //   ),
                // ),
                _nextDetails(),
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
                    _paymentCheckBloc.add(PaymentCheckFetch());
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
        }),
      ),
    );
  }

  Widget _paymentOptions(PaymentCheckState state, bool isCODAvailable) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Card(
        elevation: 1.0,
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _total(state) != "KWD 0.000"
                ? _paymentCardsList(isCODAvailable)
                : Container(),
            // InkWell(
            //   onTap: () {
            //     setState(() {
            //       isCOD = false;
            //       isCARD = true;
            //       // setState(() {
            //       //   paymentOptions = true;
            //       // });
            //       //     _showPaymentmethods();
            //     });
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.only(top: 10, bottom: 10),
            //     child: Column(
            //       children: <Widget>[
            //         Row(
            //           children: <Widget>[
            //             _selectedIndicator(isCARD),
            //             Container(
            //               margin: const EdgeInsets.only(left: 10),
            //               child: Text(
            //                 'KNET/Credit Card',
            //                 style: Theme.of(context).textTheme.bodyText2,
            //               ),
            //             ),
            //           ],
            //         ),
            //         _knetList(),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCardsList(bool isCODAvailable) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Text(
            AppLocalizations.of(context).translate('paymentType'),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        Divider(
          height: 1,
        ),
        Container(
          // height: 320,
          //     globalMediaHeight - height - (globalMediaHeight * summaryFactor),
          child: ListView.builder(
              // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 4, crossAxisSpacing: 0.0, mainAxisSpacing: 0.0),
              itemCount: paymentMethods.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext ctxt, int index) {
                return Row(
                  children: <Widget>[
                    Checkbox(
                        value: isSelected[index],
                        onChanged: (bool value) {
                          setState(() {
                            setPaymentMethodSelected(index, true);
                            isCOD = false;
                          });
                        }),
                    Image.network(paymentMethods[index].imageUrl,
                        width: 50.0, height: 50.0),
                  ],
                );
              }),
        ),
        isCODAvailable
            ? Row(
                children: <Widget>[
                  Checkbox(
                      value: isCOD,
                      onChanged: (bool value) {
                        setState(() {
                          resetSelection();
                          isCOD = value;
                        });
                      }),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      AppLocalizations.of(context).translate('cod'),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              )
            : Container()
        // _addAddressDetails(),
      ],
    );
  }

  // Widget _knetList() {
  //   return Container(
  //     margin: const EdgeInsets.only(top: 5),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: <Widget>[
  //         Container(
  //           child: Image.asset(
  //             'assets/cards/Knet.png',
  //             width: globalMediaWidth * 0.2,
  //             height: globalMediaWidth * 0.2 * 0.6,
  //           ),
  //         ),
  //         Container(
  //           child: Image.asset(
  //             'assets/cards/MasterCard.png',
  //             width: globalMediaWidth * 0.2,
  //             height: globalMediaWidth * 0.2 * 0.6,
  //           ),
  //         ),
  //         Container(
  //           child: Image.asset(
  //             'assets/cards/visacard.png',
  //             width: globalMediaWidth * 0.2,
  //             height: globalMediaWidth * 0.2 * 0.6,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _totalsCard(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      userData = state.userData;
      totalAmount = _total(state);
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        elevation: 1.0,
        child: Column(
          children: <Widget>[
            _totalCardRow(
                AppLocalizations.of(context).translate('subTotal'),
                _subTotal(state),
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            _totalCardRow(AppLocalizations.of(context).translate('discount'),
                _discount(state), Colors.red, Colors.red, FontWeight.w400),
            _totalCardRow(
                AppLocalizations.of(context).translate('shipping'),
                _shipping(state),
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w400),
            Divider(
              height: 1.0,
            ),
            _totalCardRow(
                AppLocalizations.of(context).translate('total').toUpperCase(),
                _total(state),
                AppColors.BLACK_COLOR,
                AppColors.BLACK_COLOR,
                FontWeight.w800),
          ],
        ),
      ),
    );
  }

  String _subTotal(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return state.paymentCheckStatusResponse.data.cartSubTotal;
    } else {
      return '';
    }
  }

  String _discount(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return state.paymentCheckStatusResponse.data.cartDiscount;
    } else {
      return '';
    }
  }

  String _shipping(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return state.paymentCheckStatusResponse.data.cartShippingPrice;
    } else {
      return '';
    }
  }

  String _total(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return state.paymentCheckStatusResponse.data.cartTotal;
    } else {
      return '';
    }
  }

  Widget _totalCardRow(String leftItem, String rightItem, Color leftColor,
      Color rightColor, FontWeight fontWeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(10),
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
          padding: const EdgeInsets.all(10),
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

  Widget _productDetails(PaymentCheckState state) {
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
                AppLocalizations.of(context).translate('reviewOrder'),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
            Divider(
              height: 1,
            ),
            _titleForOrderSummary(),
            Divider(
              height: 1.0,
            ),
            _loadItems(state),
          ],
        ),
      ),
    );
  }

  Widget _loadItems(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return _itemsList(state);
    } else {
      return Container();
    }
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

  Widget _itemsList(PaymentCheckLoaded state) {
    return Column(
      children: List.generate(
          state.paymentCheckStatusResponse.data.cartItems.length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: globalMediaWidth * 0.65,
                child: Text(
                  '${state.paymentCheckStatusResponse.data.cartItems[index].cartTitle} X ${state.paymentCheckStatusResponse.data.cartItems[index].cartQuantity}',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
              Container(
                child: Text(
                  '${state.paymentCheckStatusResponse.data.cartItems[index].cartProductTotalPrice}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _nextDetails() {
    return BlocListener<OrderConfirmBloc, OrderConfirmState>(
      bloc: _orderConfirmBloc,
      listener: (context, state) {
        if (state is OrderConfirmInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text(
                AppLocalizations.of(context).translate('loading'),
              ),
              backgroundColor: Colors.greenAccent,
            ),
          );
        }
        if (state is OrderConfirmError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text('${state.errorMessage}'),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (state is OrderConfirmLoaded) {
          // Scaffold.of(context).showSnackBar(
          //   SnackBar(
          //     duration: Duration(milliseconds: 1000),
          //     content: Text('${state.orderConfirmResponse.data.refId}'),
          //     backgroundColor: Colors.greenAccent,
          //   ),
          // );
          _orderConfirmResponse = state.orderConfirmResponse;
          _showPlaceOrderAction(state.orderConfirmResponse);
        }

        if (state is OrderPlacedForCOD) {
          Alert(
              context: context,
              title: '${state.orderConfirmResponse.message}',
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: const EdgeInsets.all(10)),
                  Text(
                      '${AppLocalizations.of(context).translate('invoiceID')} :    ${state.orderConfirmResponse.data.invoiceId}'),
                  Divider(
                    thickness: 0.2,
                  ),
                  Text(
                      '${AppLocalizations.of(context).translate('referenceID')} :    ${state.orderConfirmResponse.data.refId}'),
                  Divider(
                    thickness: 0.2,
                  ),
                  Text(
                      '${AppLocalizations.of(context).translate('amount')} :   ${state.orderConfirmResponse.data.grandTotal}'),
                  Divider(
                    thickness: 0.2,
                  ),
                  Text(
                      '${AppLocalizations.of(context).translate('orderStatus')} :    ${AppLocalizations.of(context).translate('success')}'),
                  Divider(
                    thickness: 0.2,
                  ),
                  Padding(padding: const EdgeInsets.all(10)),
                ],
              ),
              style: AlertStyle(isOverlayTapDismiss: false),
              buttons: [
                DialogButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context).translate('ok'),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
              closeFunction: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavBar(),
                  ),
                );
              }).show();
        }
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          alignment: Alignment.center,
          height: globalMediaHeight * 0.15,
          width: globalMediaWidth,
          color: AppColors.WHITE_COLOR,
          child: InkWell(
            onTap: () async {
              if (totalAmount != "KWD 0.000") {
                if (selectedPaymentMethodIndex != -1) {
                  _orderConfirmBloc.add(OrderConfirmFetch('myfatoorah'));
                } else if (isCOD == true) {
                  _orderConfirmBloc.add(OrderConfirmFetch('cod'));
                } else {
                  _checkPaymentSelected();
                }
              } else {
                var couponResponse = CouponResponse.fromRawJson(
                    prefs.getString(Constants.aquaCouponData) ?? {});
                if (couponResponse != null) {
                  parameters['coupon_code'] =
                      couponResponse.data.cartCouponCode;
                }
                String sesionId = prefs.getString(Constants.sessionId);
                parameters['session_id'] = sesionId;
                parameters['user_id'] = userData['data']['user_id'];
                parameters['name'] = userData['data']['user_name'];
                parameters['mobile'] = userData['data']['user_mobile'];
                parameters['email'] = userData['data']['user_email'];
                parameters['country_id'] = userData['data']['user_country_id'];
                parameters['area'] = userData['data']['user_area'];
                parameters['street'] = userData['data']['user_street'];
                parameters['house'] = userData['data']['user_house'];
                parameters['block'] = userData['data']['user_block'];
                parameters['payment_method'] =
                    (isCOD == true ? 'COD' : 'myfatoorah');
                print(parameters);
                Alert(
                  context: context,
                  title: AppLocalizations.of(context).translate('alert'),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppLocalizations.of(context).translate('loading')),
                    ],
                  ),
                  buttons: [
                    // DialogButton(
                    //   child: Text(
                    //     AppLocalizations.of(context).translate('ok'),
                    //     style: TextStyle(color: Colors.white, fontSize: 20),
                    //   ),
                    //   onPressed: () => Navigator.pop(context),
                    //   width: 120,
                    // )
                  ],
                ).show();
                final orderConfirmResponse =
                    await _paymentRepository.orderCashConfirm(parameters);
                Navigator.of(context).pop();
                print(orderConfirmResponse);
                if (orderConfirmResponse.message == 'success') {
                  Alert(
                      context: context,
                      title: AppLocalizations.of(context)
                          .translate('order_place_successfully'),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: const EdgeInsets.all(10)),
                          Text(
                              '${AppLocalizations.of(context).translate('referenceID')} :    ${orderConfirmResponse.data.refId}'),
                          Divider(
                            thickness: 0.2,
                          ),
                          Text(
                              '${AppLocalizations.of(context).translate('orderReferenceID')} :    ${orderConfirmResponse.data.orderId}'),
                          Divider(
                            thickness: 0.2,
                          ),
                          Text(
                              '${AppLocalizations.of(context).translate('invoiceID')} :    ${orderConfirmResponse.data.invoiceId}'),
                          Divider(
                            thickness: 0.2,
                          ),
                          Text(
                              '${AppLocalizations.of(context).translate('amount')} :  ${orderConfirmResponse.data.grandTotal}'),
                          Divider(
                            thickness: 0.2,
                          ),
                          Text(
                              '${AppLocalizations.of(context).translate('orderStatus')} :    ${AppLocalizations.of(context).translate('success')}'),
                          Divider(
                            thickness: 0.2,
                          ),
                          Padding(padding: const EdgeInsets.all(10)),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BottomNavBar(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context).translate('ok'),
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ]).show();
                  // Alert(
                  //     context: context,
                  //     title: AppLocalizations.of(context).translate('placeOrder'),
                  //     content: Column(
                  //       children: <Widget>[
                  //         Padding(padding: const EdgeInsets.all(10)),
                  //         Image.network(paymentMethods[selectedPaymentMethodIndex].imageUrl,
                  //             width: 50.0, height: 50.0),
                  //         Padding(padding: const EdgeInsets.all(10)),
                  //         Text(
                  //             '${AppLocalizations.of(context).translate('total').toUpperCase()} :    ${orderConfirmResponse.data.grandTotal}'),
                  //         Padding(padding: const EdgeInsets.all(10)),
                  //       ],
                  //     ),
                  //     buttons: [
                  //       DialogButton(
                  //         onPressed: () {
                  //
                  //
                  //           print(paymentMethods[selectedPaymentMethodIndex].paymentMethodId);
                  //           print(paymentMethods[selectedPaymentMethodIndex].paymentMethodEn);
                  //           executeRegularPayment(
                  //               paymentMethods[selectedPaymentMethodIndex]
                  //                   .paymentMethodId
                  //                   .toString(),
                  //               '${orderConfirmResponse.data.grandTotal}',
                  //               '${orderConfirmResponse.data.refId}');
                  //           Navigator.pop(context);
                  //         },
                  //         child: Text(
                  //           AppLocalizations.of(context).translate('pay'),
                  //           style: TextStyle(color: Colors.white, fontSize: 20),
                  //         ),
                  //       )
                  //     ]).show();
                } else {
                  print(orderConfirmResponse);
                }
              }
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: globalMediaWidth * 0.35,
              height: 30,
              color: AppColors.BLACK_COLOR,
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context).translate('confirm'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _checkPaymentSelected() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              AppLocalizations.of(context)
                  .translate('pleaseSelectPaymentMethod'),
              style: Theme.of(context).textTheme.bodyText2),
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

  _showPlaceOrderAction(OrderConfirmResponse orderConfirmResponse) {
    Alert(
        context: context,
        title: AppLocalizations.of(context).translate('placeOrder'),
        content: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(10)),
            Image.network(paymentMethods[selectedPaymentMethodIndex].imageUrl,
                width: 50.0, height: 50.0),
            Padding(padding: const EdgeInsets.all(10)),
            Text(
                '${AppLocalizations.of(context).translate('total').toUpperCase()} :  KWD ${orderConfirmResponse.data.grandTotal}'),
            Padding(padding: const EdgeInsets.all(10)),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              print(paymentMethods[selectedPaymentMethodIndex].paymentMethodId);
              print(paymentMethods[selectedPaymentMethodIndex].paymentMethodEn);
              executeRegularPayment(
                  paymentMethods[selectedPaymentMethodIndex]
                      .paymentMethodId
                      .toString(),
                  '${orderConfirmResponse.data.grandTotal}',
                  '${orderConfirmResponse.data.refId}');
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).translate('pay'),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  void executeRegularPayment(
      String paymentMethodId, String amount, String customerReference) {
    var request = new myfathoorah.MFExecutePaymentRequest(
      paymentMethodId,
      amount,
//      customerReference,
//      userData['data']['user_name'],
//      userData['data']['user_mobile'],
//      userData['data']['user_email'],
//      Platform.isAndroid ? "android" : "ios",
    );
    request.customerReference = customerReference;

    myfathoorah.MFSDK.executePayment(
        context,
        request,
        //   myfathoorah.MFAPILanguage.EN,
        AppLocalizations.of(context).locale.languageCode,
        (String invoiceId,
                myfathoorah.MFResult<myfathoorah.MFPaymentStatusResponse>
                    result) =>
            {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());

                    _response = result.response.toJson().toString();

                    _paymentCheckBloc.add(OrderPlaceFetch(
                        result.response.invoiceTransactions[0].paymentId));

                    //   _showSuccessAction(
                    //      result.response.invoiceTransactions[0].paymentId);
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  // _showSuccessAction(String paymentId) {
  //   // _orderPlaceBloc.add(OrderPlaceFetch(paymentId));
  //   BlocListener<OrderPlaceBloc, OrderPlaceState>(
  //     bloc: _orderPlaceBloc,
  //     listener: (context, state) {
  //       if (state is OrderPlaceLoading) {
  //         Scaffold.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('${state.loadingMessage}'),
  //             backgroundColor: Colors.greenAccent,
  //           ),
  //         );
  //       }
  //       if (state is OrderPlaceError) {
  //         Scaffold.of(context).showSnackBar(
  //           SnackBar(
  //             duration: Duration(milliseconds: 2000),
  //             content: Text('${state.errorMessage}'),
  //             backgroundColor: Colors.redAccent,
  //           ),
  //         );
  //       }
  //       if (state is OrderPlaceLoaded) {
  //         Alert(
  //             context: context,
  //             title: '${state.orderPlacedResponse.data.responseMessage}',
  //             content: Column(
  //               children: <Widget>[
  //                 Padding(padding: const EdgeInsets.all(10)),
  //                 Text(
  //                     'Reference ID :    ${state.orderPlacedResponse.data.referenceId}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Track ID :    ${state.orderPlacedResponse.data.trackId}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Transaction ID :    ${state.orderPlacedResponse.data.transactionId}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Payment ID :    ${state.orderPlacedResponse.data.paymentId}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Autherization ID :    ${state.orderPlacedResponse.data.authorizationId}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Order Reference ID :    ${state.orderPlacedResponse.data.orderIds}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text('Result :    ${state.orderPlacedResponse.data.result}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Text(
  //                     'Amount :    ${state.orderPlacedResponse.data.paidCurrency} ${state.orderPlacedResponse.data.paidCurrencyValue}'),
  //                 Divider(
  //                   thickness: 0.2,
  //                 ),
  //                 Padding(padding: const EdgeInsets.all(10)),
  //               ],
  //             ),
  //             buttons: [
  //               DialogButton(
  //                 onPressed: () {
  //                   Navigator.pop(context);
  //                 },
  //                 child: Text(
  //                   "OK",
  //                   style: TextStyle(color: Colors.white, fontSize: 20),
  //                 ),
  //               )
  //             ]).show();
  //       }
  //     },
  //   );
  // }

  void executeDirectPayment(
      String paymentMethodId, String amount, String customerReference) {
    // var request =
    //     new myfathoorah.MFExecutePaymentRequest(paymentMethodId, amount);

    var request = new myfathoorah.MFExecutePaymentRequest(
      paymentMethodId,
      amount,
//      customerReference,
//      userData['data']['user_name'],
//      userData['data']['user_mobile'],
//      userData['data']['user_email'],
//      Platform.isAndroid ? "android" : "ios",
    );
    var mfCardInfo =
        new myfathoorah.MFCardInfo(cardToken: Constants.directPaymentToken);

    // var mfCardInfo = new MFCardInfo(
    //     cardNumber: cardNumber,
    //     expiryMonth: expiryMonth,
    //     expiryYear: expiryYear,
    //     securityCode: securityCode,
    //     bypass3DS: true,
    //     saveToken: false);

    myfathoorah.MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        myfathoorah.MFAPILanguage.EN,
        (String invoiceId,
                myfathoorah.MFResult<myfathoorah.MFDirectPaymentResponse>
                    result) =>
            {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    print(invoiceId);

                    print(result.response.cardInfoResponse.toJson());
                    print(result.response.mfPaymentStatusResponse.toJson());

                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  Widget _addressCard(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      print("LLLL");
      print(state.userData['data']['user_country_name']);
      print("LLLL");
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Card(
          elevation: 1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                alignment: Alignment.centerLeft,
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
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  state.userData['data']['user_name'],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  state.userData['data']['user_mobile'],
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              _addressLine(
                '${AppLocalizations.of(context).translate('house')} : ${state.userData['data']['user_house']},',
                "",
              ),
              _addressLine(" ",
                  '${AppLocalizations.of(context).translate('block')} : ${state.userData['data']['user_block']}'),
              _addressLine('${state.userData['data']['user_street']}, ',
                  '${state.userData['data']['user_area']}'),
              _addressLine(
                  '${state.userData['data']['user_country_name']}', ''),
              Padding(padding: const EdgeInsets.all(10))
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _alertCard(PaymentCheckState state) {
    if (state is PaymentCheckLoaded) {
      return (state.paymentCheckStatusResponse.data.notes != "" &&
              state.paymentCheckStatusResponse.data.notes != null)
          ? Container(
              margin:
                  const EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 5),
              child: Card(
                elevation: 1.0,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                          child: Text(
                            state.paymentCheckStatusResponse.data.notes,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const IgnorePointer();
    } else {
      return Container();
    }
  }

  Widget _addressLine(String text1, String text2) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              text1 != " "
                  ? Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Text(
                        text1,
                        softWrap: false,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  : null,
              Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Text(
                    '$text2',
                    softWrap: false,
                    style: Theme.of(context).textTheme.bodyText2,
                  )),
            ].where((child) => child != null).toList(),
          ),
        ],
      ),
    );
  }

  Widget _selectedIndicator(bool isSelected) {
    return isSelected
        ? Container(
            width: 20,
            height: 20,
            alignment: Alignment.center,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.WHITE_COLOR,
              border: Border.all(
                color: AppColors.BLACK_COLOR,
                width: 2,
              ),
            ),
            child: Container(
              width: 10,
              height: 10,
              alignment: Alignment.center,
              // margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColors.BLACK_COLOR,
              ),
            ),
          )
        : Container(
            width: 20,
            height: 20,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColors.WHITE_COLOR,
              border: Border.all(
                color: AppColors.BLACK_COLOR,
                width: 2,
              ),
            ),
          );
  }
}
