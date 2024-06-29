// @dart=2.9

import 'dart:convert';

import 'package:aqua/Account/ChangePassword/bloc/change_password_bloc.dart';
import 'package:aqua/Account/ChangePassword/change_password.dart';
import 'package:aqua/Account/ContentPages/contentPage.dart';
import 'package:aqua/Account/MyOrders/bloc/orders_bloc.dart';
import 'package:aqua/Account/MyOrders/my_orders.dart';
import 'package:aqua/Account/MyProfile/bloc/my_profile_bloc.dart';
import 'package:aqua/Account/SelectCurrency/select_currency.dart';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/translation/AppLanguage.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MyProfile/my_profile.dart';
import 'authentication_bloc/authentication_bloc.dart';

class MyAccount extends StatefulWidget {
  // final String customerName;
  final Map<String, dynamic> userData;
  MyAccount({Key key, this.userData}) : super(key: key);

  @override
  _MyAccountState createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  var appLanguage;

  @override
  Widget build(BuildContext context) {
    appLanguage = Provider.of<AppLanguage>(context);

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.WHITE_BACKGROUND,
          body: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _header(),
                _ordersAddressBlock(),
                _currencyAndLanguageBlock(),
                _changePwdBlock(),
                _accountDeletionBlock(),
                _contentBlock(),
                _lognLogOut(state),
                Padding(padding: const EdgeInsets.all(10)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmLogOut() {
    Alert(
      context: context,
      title: "",
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(padding: const EdgeInsets.all(10)),
          Text(
            AppLocalizations.of(context).translate('areyousureToLogout'),
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          Padding(padding: const EdgeInsets.all(10)),
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
            BlocProvider.of<AuthenticationBloc>(context)
              ..add(
                LoggedOut(),
              );
          },
          width: 120,
        )
      ],
    ).show();
  }

  _showAlert() {
    Alert(
        context: context,
        title: AppLocalizations.of(context).translate('changeLanguage'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(20)),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
              appLanguage.changeLanguage(Locale("ar"));
              Constants.isLanguageChanged = true;
              // CurrencyRepository currencyRepository = CurrencyRepository();
              // currencyRepository.getCurrenciesData();

              Navigator.pop(context);
            },
            child: Text(
              "العربية",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          DialogButton(
            onPressed: () {
              appLanguage.changeLanguage(Locale("en"));
              Constants.isLanguageChanged = true;
              // CurrencyRepository currencyRepository = CurrencyRepository();
              // currencyRepository.getCurrenciesData();

              Navigator.pop(context);
            },
            child: Text(
              'English',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget _header() {
    globalMediaWidth = MediaQuery.of(context).size.width;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(90),
        bottomRight: Radius.circular(0),
      ),
      child: Container(
        height: 250,
        width: globalMediaWidth,
        color: AppColors.BLACK_COLOR,
        child: Stack(
          //  fit: StackFit.loose,
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
                top: 30,
                right: -100,
                child: _circularContainer(300, AppColors.darkBlacShade2)),
            Positioned(
                top: -100,
                left: -45,
                child: _circularContainer(
                    globalMediaWidth * .5, AppColors.darkBlacShade1)),
            Positioned(
                top: -180,
                right: -30,
                child: _circularContainer(
                    globalMediaWidth * .7, AppColors.blackShade3,
                    borderColor: Colors.transparent, borderWidth: 1)),
            _titleHeader(),
            Positioned(
              top: 80,
              child: _profileAvatar(),
            ),
            Positioned(
              bottom: 30,
              right: 20,
              child: _editButton(),
            )
          ],
        ),
      ),
    );
  }

  Widget _circularContainer(double height, Color color,
      {Color borderColor = Colors.transparent, double borderWidth = 2}) {
    return Container(
      height: height,
      width: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: borderColor, width: borderWidth),
      ),
    );
  }

  Widget _editButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                  create: (context) => MyProfileBloc(),
                  child: MyProfile(
                    userData: widget.userData,
                  )),
              fullscreenDialog: true,
            ),
          ).then((value) {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
          });
        },
        child: Container(
          width: 50,
          height: 50,
          child: Icon(
            Icons.edit,
            color: AppColors.WHITE_COLOR,
            size: 25,
          ),
        ),
        splashColor: AppColors.SPLASH_COLOR,
      ),
    );
  }

  Widget _profileAvatar() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Card(
          color: Colors.transparent,
          elevation: 5.0,
          shape: CircleBorder(),
          child: Container(
            //    alignment: Alignment.center,
            width: 90,
            height: 90,
            color: Colors.transparent,
            // child: Image.asset(
            //   'assets/images/avatar.png',
            //   color: AppColors.TEXT_GRAY_COLOR.withOpacity(0.9),
            // ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(widget.userData['data']['user_name'].toUpperCase(),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                  color: AppColors.WHITE_COLOR,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.normal)),
        ),
      ],
    );
  }

  Widget _titleHeader() {
    return Positioned(
      top: 50,
      left: 0,
      child: Container(
        width: globalMediaWidth,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('dashBoard'),
                  style: Theme.of(context).textTheme.headline4,
                ),
                // Material(
                //   color: Colors.transparent,
                //   child: InkWell(
                //     customBorder: CircleBorder(),
                //     onTap: () {
                //       print('Clicked on Settings');
                //     },
                //     child: Container(
                //       width: 50,
                //       height: 50,
                //       child: Icon(
                //         Icons.settings,
                //         color: AppColors.WHITE_COLOR,
                //         size: 25,
                //       ),
                //     ),
                //     splashColor: AppColors.SPLASH_COLOR,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _ordersAddressBlock() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => OrdersBloc(),
                    child: MyOrders(),
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('myOrders'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          // Divider(
          //   height: 1,
          //   color: AppColors.TEXT_GRAY_COLOR,
          // ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => AccountsAddressList(),
          //         fullscreenDialog: true,
          //       ),
          //     );
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         margin: const EdgeInsets.only(left: 10),
          //         alignment: Alignment.centerLeft,
          //         height: 50,
          //         child: Text(
          //           'MY ADDRESSES',
          //           style: Theme.of(context).textTheme.bodyText1,
          //         ),
          //       ),
          //       Icon(
          //         Icons.chevron_right,
          //         size: 25,
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // Widget _currencyBlock() {
  //   return Card(
  //     margin: const EdgeInsets.all(20),
  //     elevation: 1.0,
  //     child: InkWell(
  //       onTap: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => SelectedCurrency(),
  //             fullscreenDialog: true,
  //           ),
  //         );
  //       },
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Container(
  //             margin: const EdgeInsets.only(left: 10),
  //             alignment: Alignment.centerLeft,
  //             height: 50,
  //             child: Text(
  //               'CURRENCY / COUNTRY',
  //               style: Theme.of(context).textTheme.bodyText1,
  //             ),
  //           ),
  //           Icon(
  //             Icons.chevron_right,
  //             size: 25,
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _currencyAndLanguageBlock() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectedCurrency(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('currencyorCountry'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              // print('On My contact us');
              _showAlert();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('changeLanguage'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _changePwdBlock() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              print('On My Change Pwd');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => ChangePasswordBloc(),
                      child: ChangePassword(
                        userData: widget.userData,
                      )),
                  fullscreenDialog: true,
                ),
              ).then((value) {
                BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('changePassword'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          // Divider(
          //   height: 1,
          //   color: AppColors.TEXT_GRAY_COLOR,
          // ),
          // InkWell(
          //   onTap: () {
          //     print('On My contact us');
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         margin: const EdgeInsets.only(left: 10, right: 10),
          //         alignment: Alignment.centerLeft,
          //         height: 50,
          //         child: Text(
          //           AppLocalizations.of(context).translate('contactUs'),
          //           style: Theme.of(context).textTheme.bodyText1,
          //         ),
          //       ),
          //       Icon(
          //         Icons.chevron_right,
          //         size: 25,
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _accountDeletionBlock() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              print('On My Change Pwd');
              _confirmdDeleteYourAccount();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => BlocProvider(
              //         create: (context) => ChangePasswordBloc(),
              //         child: ChangePassword(
              //           userData: widget.userData,
              //         )),
              //     fullscreenDialog: true,
              //   ),
              // ).then((value) {
              //   BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
              // });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('deleteMyAccount'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          // Divider(
          //   height: 1,
          //   color: AppColors.TEXT_GRAY_COLOR,
          // ),
          // InkWell(
          //   onTap: () {
          //     print('On My contact us');
          //   },
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[
          //       Container(
          //         margin: const EdgeInsets.only(left: 10, right: 10),
          //         alignment: Alignment.centerLeft,
          //         height: 50,
          //         child: Text(
          //           AppLocalizations.of(context).translate('contactUs'),
          //           style: Theme.of(context).textTheme.bodyText1,
          //         ),
          //       ),
          //       Icon(
          //         Icons.chevron_right,
          //         size: 25,
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  void _confirmdDeleteYourAccount() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('areYouSureToDelete'),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('ok'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            deleteMyAccount();
            // Navigator.pop(context);
            // BlocProvider.of<AuthenticationBloc>(context)
            //   ..add(
            //     LoggedOut(),
            //   );
          },
          width: 120,
        )
      ],
    ).show();
  }

  deleteMyAccount() async {
    try {
      var repo = UserRepository();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userData = json.decode(prefs.getString(Constants.aquaUserData)) ??
          Map<String, dynamic>();
      var user_id = userData['data']['user_id'];
      var access_token = userData['data']['user_api_access_token'];
      var response = await repo.deleteMyAccount(access_token, user_id);
      if (response != null) {
        if (response.info == "Success") {
          Navigator.pop(context);
          BlocProvider.of<AuthenticationBloc>(context)
            ..add(
              LoggedOut(),
            );
        } else {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Widget _contentBlock() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 1.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_ABOUTUS,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('aboutUs'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_TERMS,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('termsandConditions'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_SHIPPING_RETURN,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('shippingandReturn'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_SECURE_SHOPPING,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('secureShopping'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_PRIVACY_POLICY,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('privacyPolicy'),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
          Divider(
            height: 1,
            color: AppColors.TEXT_GRAY_COLOR,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContentPage(
                          pageName: Constants.CONTENT_URL_OUR_STORES,
                        ),
                    fullscreenDialog: true),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.centerLeft,
                  height: 50,
                  child: Text(
                    AppLocalizations.of(context).translate('ourStores') ?? " ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: 25,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _lognLogOut(AuthenticationState state) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _confirmLogOut();
          },
          child: Container(
            width: globalMediaWidth * 0.30,
            height: 40,
            color: AppColors.BLACK_COLOR,
            alignment: Alignment.center,
            child: Text(
              state is Authenticated
                  ? AppLocalizations.of(context).translate('logout')
                  : AppLocalizations.of(context).translate('login'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          splashColor: AppColors.SPLASH_COLOR,
        ),
      ),
    );
  }
}
