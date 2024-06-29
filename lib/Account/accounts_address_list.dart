// @dart=2.9
import 'package:aqua/Account/accounts_address_item.dart';
import 'package:aqua/Account/add_address.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';

class AccountsAddressList extends StatefulWidget {
  AccountsAddressList({Key key}) : super(key: key);

  @override
  _AccountsAddressListState createState() => _AccountsAddressListState();
}

class _AccountsAddressListState extends State<AccountsAddressList> {
  double globalMediaWidth;
  double globalMediaHeight;
  int currentSelectedIndex;

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.WHITE_BACKGROUND,
      appBar: new AppBar(
        //  key: _keyAppBar,
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          'ADDRESS',
          style: Theme.of(context).textTheme.headline1,
        ),
      ),
      body: SingleChildScrollView(
        child: _addressList(),
      ),
    );
  }

  Widget _addressList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: globalMediaHeight,
          child: ListView.builder(
              cacheExtent: 10000,
              itemCount: 6,
              scrollDirection: Axis.vertical,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (index == 5) {
                  return _addAddressDetails();
                } else {
                  return AccountAddressItem(
                      isSelected: currentSelectedIndex == index,
                      onSelect: () {
                        setState(() {
                          currentSelectedIndex = index;
                        });
                      });
                }
              }),
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
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAddress(),
              fullscreenDialog: true,
            ),
          );
        },
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
                'Add New Address',
                style: Theme.of(context).textTheme.headline1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
