// @dart=2.9
import 'package:aqua/HomePage/homepage_bottom_subItem.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:flutter/material.dart';

class HomeProductScrollItem extends StatefulWidget {
  final bool isFromHome;
  final ProdItemData productItemData1;
  final ProdItemData productItemData2;
  final Function gotoCart;
  HomeProductScrollItem(
      {Key key,
      this.productItemData1,
      this.productItemData2,
      this.isFromHome,
      this.gotoCart})
      : super(key: key);

  @override
  _HomeProductScrollItemState createState() => _HomeProductScrollItemState();
}

class _HomeProductScrollItemState extends State<HomeProductScrollItem> {
  @override
  Widget build(BuildContext context) {
    double globalMediaWidth = MediaQuery.of(context).size.width;

    return Row(
      children: <Widget>[
        Container(
          width: (globalMediaWidth / 2) - 5,
          child: HomePageBottomSubItem(
            prodItemData: widget.productItemData1,
            isFromHome: widget.isFromHome,
            gotoCart: widget.gotoCart,
          ),
        ),
        if (widget.productItemData2 != null)
          Container(
            width: (globalMediaWidth / 2) - 5,
            child: HomePageBottomSubItem(
              prodItemData: widget.productItemData2,
              isFromHome: widget.isFromHome,
              gotoCart: widget.gotoCart,
            ),
          ),
      ],
    );
  }
}
