// @dart=2.9
import 'package:aqua/ProductItem/product_info.dart';
import 'package:aqua/WishList/bloc/wish_list_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ProductList/bloc/product_list_response.dart';

class RelateProductItem extends StatefulWidget {
  final ProdItemData prodItemData;

  final int index;

  const RelateProductItem({Key key, this.index, this.prodItemData})
      : super(key: key);

  @override
  _RelateProductItemState createState() => _RelateProductItemState();
}

class _RelateProductItemState extends State<RelateProductItem> {
  WishListBloc _wishListBloc;
  @override
  void initState() {
    super.initState();
    _wishListBloc = WishListBloc();
  }

  @override
  Widget build(BuildContext context) {
    // final String imageName =
    //     'https://www.aquafashion.com/aquatest/uploads/product/0-809328135.jpg';

    return BlocListener<WishListBloc, WishListState>(
      bloc: _wishListBloc,
      listener: (context, state) {
        if (state is WishListInitial) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AquaProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      '${state.loadMessage}',
                      style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.WHITE_BACKGROUND,
            ),
          );
        }
        if (state is WishListAddDeleteState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(milliseconds: 1000),
              content: Text(
                state.infoMessage,
                style: TextStyle(
                  color: AppColors.BLACK_COLOR,
                ),
              ),
              backgroundColor: AppColors.WHITE_BACKGROUND,
            ),
          );
        }
      },
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductInfo(
                //      index: widget.index,
                prodItemData: widget.prodItemData,
              ),
              fullscreenDialog: true,
            ),
          );
        },
        child: Card(
          elevation: 0.0,
          child: Stack(
            fit: StackFit.loose,
            children: <Widget>[
              widget.prodItemData.gallery.length > 0
                  ? SizedBox(
                      width: 150.0,
                      height: 200.0,
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl:
                              '${widget.prodItemData.gallery.first.imageUrl}',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                //fit: BoxFit.fill,
                                fit: BoxFit.cover,
//                    colorFilter: const ColorFilter.mode(
//                      Colors.red,
//                      BlendMode.colorBurn,
//                    ),
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    )
                  // : Image.network(
                  //     imageName,
                  //     fit: BoxFit.cover,
                  //     filterQuality: FilterQuality.low,
                  //   ),
                  : Container(),
              BlocBuilder<WishListBloc, WishListState>(
                bloc: _wishListBloc,
                builder: (context, state) {
                  return Visibility(
                    visible: Constants.isSignIN,
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          customBorder: CircleBorder(),
                          onTap: () {
                            print('Clicked on Settings');
                            _wishListBloc.add(WishListAddDelEvent(
                                productId: widget.prodItemData.productId));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 50,
                            height: 50,
                            child: Icon(
                              _wishlistStatus(state, widget.prodItemData)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: AppColors.BLACK_COLOR,
                              size: 20,
                            ),
                          ),
                          splashColor: AppColors.SPLASH_COLOR,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 20,
                left: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? 5
                    : null,
                right: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? null
                    : 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.WHITE_COLOR.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${widget.prodItemData.productTitle} - ',
                        softWrap: true,
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '${widget.prodItemData.productSku}',
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: Colors.grey),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                left: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? 5
                    : null,
                right: AppLocalizations.of(context).locale.languageCode == 'en'
                    ? null
                    : 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.WHITE_COLOR.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.prodItemData.productPrice}',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _wishlistStatus(WishListState state, ProdItemData prodItemData) {
    if (state is WishListAddDeleteState) {
      print('inside WishlistADDDelte');
      return state.addDelStatus;
    } else {
      if (prodItemData.productIsFav == 0) {
        return false;
      } else {
        return true;
      }
    }
  }
}
