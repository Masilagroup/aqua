// @dart=2.9
import 'package:aqua/Account/AddressList/address_item.dart';
import 'package:aqua/Account/PaymentPage/bloc/payment_check_bloc.dart';
import 'package:aqua/Account/PaymentPage/payment_page.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddressList extends StatefulWidget {
  final Map<String, dynamic> userData;
  AddressList({Key key, this.userData}) : super(key: key);

  @override
  _AddressListState createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  double globalMediaWidth;
  double globalMediaHeight;
  int currentSelectedIndex;
  double summaryFactor = 0.15;
  double height = 160;
  GlobalKey _keyAppBar = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  _afterLayout(_) {
    final RenderBox renderAppBar = _keyAppBar.currentContext.findRenderObject();

    setState(() {
      print(renderAppBar.size.height);
      height = renderAppBar.size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: new AppBar(
        key: _keyAppBar,
        centerTitle: true,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          AppLocalizations.of(context).translate('address').toUpperCase(),
          style: Theme.of(context).textTheme.headline1,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: <Widget>[
          _addressList(),
          _nextDetails(),
        ],
      ),
    );
  }

  Widget _addressList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height:
              globalMediaHeight - height - (globalMediaHeight * summaryFactor),
          child: ListView.builder(
            cacheExtent: 10000,
            itemCount: 1,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index == 5) {
                return _addAddressDetails();
              } else {
                return AddressItem(
                    userData: widget.userData,
                    isSelected: currentSelectedIndex == index,
                    onSelect: () {
                      setState(() {
                        currentSelectedIndex = index;
                      });
                    });
              }
            },
          ),
        ),
        // _addAddressDetails(),
      ],
    );
  }

  Widget _addAddressDetails() {
    return Container(
      height: 30,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      child: InkWell(
        onTap: () {},
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_circle,
              //  size: 20,
            ),
            Container(
              height: 30,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                AppLocalizations.of(context).translate('addNewAddress'),
                style: Theme.of(context).textTheme.headline4,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _checkAddresSelected() {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context).translate('pleaseCheckAddress'),
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

  bool _checkAddressValid() {
    if ((widget.userData['data']['user_house'] == '') ||
        (widget.userData['data']['user_street'] == '') ||
        (widget.userData['data']['user_area'] == '')) {
      return false;
    } else {
      return true;
    }
  }

  Widget _nextDetails() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        alignment: Alignment.center,
        height: globalMediaHeight * 0.15,
        width: globalMediaWidth,
        color: AppColors.WHITE_COLOR,
        child: InkWell(
          onTap: () {
            (currentSelectedIndex != null && _checkAddressValid())
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => PaymentCheckBloc(),
                        child: PaymentPage(),
                      ),
                      fullscreenDialog: false,
                    ),
                  )
                : _checkAddresSelected();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 10),
            width: globalMediaWidth * 0.25,
            height: 30,
            color: AppColors.BLACK_COLOR,
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context).translate('next'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
      ),
    );
  }
}
