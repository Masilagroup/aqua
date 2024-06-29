// @dart=2.9
import 'package:aqua/Account/authentication_bloc/authentication.dart';
import 'package:aqua/Cart/bloc/cart_bloc.dart';
import 'package:aqua/Cart/cart_details.dart';
import 'package:aqua/HomePage/homepage.dart';
import 'package:aqua/Search/search_page.dart';
import 'package:aqua/WishList/wishlist.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/app_colors.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>
    with TickerProviderStateMixin {
  PageController _myPage = PageController(initialPage: 0);
  Color normalColor = AppColors.LIGHT_GRAY_BGCOLOR;
  Color selectedColor = AppColors.BLACK_COLOR;
  int selectedIndex = 0;
  GlobalKey<_BottomNavBarState> _navbarState;

  @override
  void initState() {
    super.initState();
    Constants.pageController = _myPage;
    _navbarState = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _navbarState,
      //   resizeToAvoidBottomInset: true,
      bottomNavigationBar: BottomAppBar(
        elevation: 5.0,
        color: Color(0xFFF7F9F9),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _customBarbuttonItem(Icons.home,
                  AppLocalizations.of(context).translate('home'), 0, 5.0, 0.0),
              _customBarbuttonItem(
                  Icons.search,
                  AppLocalizations.of(context).translate('search'),
                  1,
                  0.0,
                  selectedIndex == 0 ? 0.0 : 0.0),
              _customBarbuttonItem(
                  Icons.favorite_border,
                  AppLocalizations.of(context).translate('wishList'),
                  2,
                  selectedIndex == 0 ? 0.0 : 0.0,
                  0.0),
              _customBarbuttonItem(Icons.shopping_basket,
                  AppLocalizations.of(context).translate('cart'), 3, 0.0, 0.0),
              _customBarbuttonItem(
                  FontAwesomeIcons.userCircle,
                  AppLocalizations.of(context).translate('myAqua'),
                  4,
                  0.0,
                  5.0),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: _myPage,
        onPageChanged: (int) {
          print('Page Changes to index $int');
        },
        children: <Widget>[
          HomePage(
            gotoCart: _changePage,
          ),
          SearchPage(
            gotoCart: _changePage,
          ),
          WishList(
            gotoCart: _changePage,
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(),
            child: CartDetailsPage(),
          ),
          Authentication()
        ],
        physics:
            NeverScrollableScrollPhysics(), // Comment this if you need to use Swipe.
      ),
    );
  }

  Widget _customBarbuttonItem(IconData icon, String title, int index,
      double leftMargin, double rightMargin) {
    return Container(
      margin: EdgeInsets.only(top: 0, left: leftMargin, right: rightMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            //    padding: const EdgeInsets.only(top: 5),
            child: IconButton(
              iconSize: 25.0,
              icon: Icon(
                icon,
                color: selectedIndex == index ? selectedColor : normalColor,
              ),
              splashColor: AppColors.SPLASH_COLOR,
              onPressed: () {
                _changePage(index);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: TextStyle(
                color: selectedIndex == index ? selectedColor : normalColor,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          )
        ],
      ),
    );
  }

  _changePage(int index) {
    setState(() {
      selectedIndex = index;
      _myPage.jumpToPage(index);
    });
  }
}
