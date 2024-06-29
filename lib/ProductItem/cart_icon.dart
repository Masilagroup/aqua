// @dart=2.9
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:aqua/Navbar/navbar.dart' as navbar;
import 'package:rflutter_alert/rflutter_alert.dart';

class CartIcon extends StatefulWidget {
  final int counter;
  final bool isFromHome;
  final bool isFromWishList;
  final GlobalKey<_CartIconState> newKey;

  CartIcon(
      {Key key,
      @required this.counter,
      this.newKey,
      this.isFromHome,
      this.isFromWishList})
      : super(key: key);

  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new IconButton(
          icon: Icon(
            Icons.shopping_basket,
            size: 25,
            color: AppColors.BLACK_COLOR,
          ),
          onPressed: () {
            if (widget.isFromHome == null) {
              if (widget.isFromWishList != null) {
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context, true);
                Navigator.pop(context, true);
              }
            } else {
              Navigator.pop(context, true);
            }
            //      widget.newKey.currentState.
            //     Constants.pageController.jumpToPage(3);
          },
        ),
        widget.counter != 0
            ? Positioned(
                right: 8,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    '${widget.counter}',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : new Container()
      ],
    );
  }
}
