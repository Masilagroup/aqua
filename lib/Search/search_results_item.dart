// @dart=2.9
import 'package:aqua/ProductItem/product_info.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:flutter/material.dart';

class SearchItem extends StatefulWidget {
  final String imageName;
  final int index;
  final double width;
  final double height;

  const SearchItem(
      {Key key, this.imageName, this.index, this.width, this.height})
      : super(key: key);

  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Clicked on ${widget.index}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfo(),
            fullscreenDialog: true,
          ),
        );
      },
      child: Card(
        elevation: 0.0,
        child: Stack(
          children: <Widget>[
            Image.asset(
              widget.imageName,
              fit: BoxFit.cover,
              width: widget.width,
              height: widget.height,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                iconSize: 20.0,
                icon: Icon(
                  Icons.favorite_border,
                  color: AppColors.BLACK_COLOR,
                ),
                splashColor: AppColors.SPLASH_COLOR,
                onPressed: () {
                  print('Icon Pressed');
                },
              ),
            ),
            Positioned(
              bottom: 30,
              child: Text(
                'SHIRT BUTTONED',
                softWrap: true,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.left,
              ),
            ),
            Positioned(
              bottom: 10,
              child: Text(
                '49.5 KWD',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
