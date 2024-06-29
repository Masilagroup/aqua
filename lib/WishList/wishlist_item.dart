// @dart=2.9
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/ProductItem/product_info.dart';
import 'package:aqua/WishList/bloc/wish_list_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WishListItem extends StatefulWidget {
  final Function gotoCart;

  final ProdItemData prodItemData;
  final int count;

  const WishListItem({Key key, this.prodItemData, this.count, this.gotoCart})
      : super(key: key);

  @override
  _WishListItemState createState() => _WishListItemState();
}

class _WishListItemState extends State<WishListItem> {
  // final String imageName =
  //     'https://www.aquafashion.com/aquatest/uploads/product/0-809328135.jpg';
  @override
  Widget build(BuildContext context) {
    print('itemNo: ${widget.prodItemData.productId}');
    return BlocListener<WishListBloc, WishListState>(
      listener: (context, state) {
        if ((state is WishListDeleteState) && (widget.count <= 0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)
                    .translate('itemDeletedFromWishList'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: InkWell(
        onTap: () {
          // print('Clicked on ${widget.index}');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductInfo(
                isFromWishList: true,
                prodItemData: widget.prodItemData,
              ),
              fullscreenDialog: true,
            ),
          ).then((value) => {
                if (value != null)
                  {
                    if (value == true) {widget.gotoCart(3)}
                  }
              });
        },
        child: Card(
          elevation: 0.0,
          child: Stack(
            children: <Widget>[
              widget.prodItemData.gallery.length > 0
                  ?
                  // Image.network(
                  //             '${widget.prodItemData.gallery.first.imageMediumUrl}',
                  //             fit: BoxFit.cover,
                  //             filterQuality: FilterQuality.low,
                  //           )

                  CachedNetworkImage(
                      imageUrl:
                          widget.prodItemData.gallery.first.imageMediumUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          Center(child: const CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Center(child: const Icon(Icons.error)),
                    )
                  // : Image.network(
                  //     imageName,
                  //     fit: BoxFit.cover,
                  //     filterQuality: FilterQuality.low,
                  //   ),
                  : Container(),
              Positioned(
                top: 5,
                left: 5,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      print('Clicked on Settings');
                      BlocProvider.of<WishListBloc>(context)
                        ..add(WishListDelete(widget.prodItemData.productId));
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.WHITE_COLOR.withOpacity(0.4),
                      ),
                      child: Icon(
                        Icons.close,
                        color: AppColors.BLACK_COLOR,
                        size: 20,
                      ),
                    ),
                    splashColor: AppColors.SPLASH_COLOR,
                  ),
                ),
              ),
              // Positioned(
              //   top: 5,
              //   right: 5,
              //   child: Material(
              //     color: Colors.transparent,
              //     child: InkWell(
              //       customBorder: CircleBorder(),
              //       onTap: () {
              //         print('Clicked on Settings');
              //       },
              //       child: Container(
              //         width: 30,
              //         height: 30,
              //         decoration: BoxDecoration(
              //           shape: BoxShape.circle,
              //           color: AppColors.WHITE_COLOR.withOpacity(0.4),
              //         ),
              //         child: Icon(
              //           Icons.shopping_basket,
              //           color: AppColors.BLACK_COLOR,
              //           size: 25,
              //         ),
              //       ),
              //       splashColor: AppColors.SPLASH_COLOR,
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 30,
                child: Text(
                  widget.prodItemData.productTitle,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.left,
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   child: Text(
              //     '49.5 KWD',
              //     textAlign: TextAlign.left,
              //     style: Theme.of(context).textTheme.subtitle,
              //   ),
              // ),
              Positioned(
                bottom: 10,
                child: _priceBlock(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceBlock() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 0, top: 5),
          child: Text(
            '${widget.prodItemData.productPrice}',
            softWrap: true,
            style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontFamily: 'Montserrat',
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              decoration: checkOfferPrice()
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Visibility(
          visible: checkOfferPrice(),
          child: Container(
            padding: AppLocalizations.of(context).locale.languageCode == 'en'
                ? EdgeInsets.only(left: 5, top: 5)
                : EdgeInsets.only(right: 5, top: 5),
            child: Text(
              '${widget.prodItemData.productOfferPrice}',
              softWrap: true,
              style: TextStyle(
                color: AppColors.RED_COLOR,
                fontFamily: 'Montserrat',
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  bool checkOfferPrice() {
    String offerPrice = widget.prodItemData.productOfferPrice;
    String offerPriceValue;
    offerPriceValue =
        offerPrice.replaceAll(new RegExp(r'[^0-9]', dotAll: true), ''); // '23'

    if (double.parse(offerPriceValue) > 0) {
      return true;
    } else {
      return false;
    }
  }
}
