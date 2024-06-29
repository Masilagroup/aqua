// @dart=2.9
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/ProductItem/product_info.dart';
import 'package:aqua/WishList/bloc/wish_list_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'ProductList/bloc/product_list_response.dart';

class ProductItem2 extends StatefulWidget {
  ProdItemData prodItemData;
  final int index;
  bool isBundle;

  ProductItem2({Key key, this.index, this.prodItemData, this.isBundle = false})
      : super(key: key);

  @override
  _ProductItem2State createState() => _ProductItem2State();
}

class _ProductItem2State extends State<ProductItem2> {
  WishListBloc _wishListBloc;
  @override
  void initState() {
    super.initState();
    _wishListBloc = WishListBloc();
    print(widget.prodItemData);

    // _wishListBloc..add(WishProductsFetch());
  }

  @override
  Widget build(BuildContext context) {
    // final String imageName =
    //     'https://www.aquafashion.com/aquatest/uploads/product/0-809328135.jpg';

    return widget.isBundle
        ? GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductInfo(
                    //         index: widget.index,
                    prodItemData: widget.prodItemData,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Container(
              // height: 150.0,width: MediaQuery.of(context).size.width/5,
              child: Card(
                elevation: 0.0,
                child: Stack(
                  children: <Widget>[
                    widget.prodItemData.gallery.length > 0
                        ? CachedNetworkImage(
                            imageUrl: widget
                                .prodItemData.gallery.first.imageMediumUrl,
                            filterQuality: FilterQuality.low,
                            fit: BoxFit.cover,
                            imageBuilder: (context, imageProvider) => Container(
                              height: 302,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Container(),
                    // BlocBuilder<WishListBloc, WishListState>(
                    //   bloc: _wishListBloc,
                    //   builder: (context, state) {
                    //     return Visibility(
                    //       visible: Constants.isSignIN,
                    //       child: Positioned(
                    //         top: 0,
                    //         right: 0,
                    //         child: Material(
                    //           color: Colors.transparent,
                    //           child: InkWell(
                    //             customBorder: CircleBorder(),
                    //             onTap: () {
                    //               print('Clicked on Settings');
                    //               _wishListBloc.add(WishListAddDelEvent(
                    //                   productId: widget.prodItemData.productId));
                    //             },
                    //             child: Container(
                    //               alignment: Alignment.center,
                    //               width: 50,
                    //               height: 50,
                    //               child: Icon(
                    //                 _wishlistStatus(state, widget.prodItemData)
                    //                     ? Icons.favorite
                    //                     : Icons.favorite_border,
                    //                 color: AppColors.BLACK_COLOR,
                    //                 size: 20,
                    //               ),
                    //             ),
                    //             splashColor: AppColors.SPLASH_COLOR,
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    Positioned(
                      bottom: 35,
                      left: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? 5
                          : null,
                      right: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? null
                          : 5,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${widget.prodItemData.productTitle} - ',
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            ' ${widget.prodItemData.productSku}',
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
                    Positioned(
                      bottom: 10,
                      left: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? 5
                          : null,
                      right: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? null
                          : 5,
                      child: _priceBlock(),
                      // Text(
                      //   '${widget.prodItemData.productPrice}',
                      //   textAlign: TextAlign.left,
                      //   style: Theme.of(context).textTheme.subtitle,
                      // ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : BlocListener<WishListBloc, WishListState>(
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
                      //         index: widget.index,
                      prodItemData: widget.prodItemData,
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Card(
                elevation: 0.0,
                child: Stack(
                  children: <Widget>[
                    widget.prodItemData.gallery.length > 0
                        ? Image.network(
                            '${widget.prodItemData.gallery.first.imageMediumUrl}',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.low,
                          )

                        //   CachedNetworkImage(
                        // imageUrl: widget.prodItemData.gallery.first.imageMediumUrl,
                        //     filterQuality: FilterQuality.low,
                        //
                        //   imageBuilder: (context, imageProvider) => Container(
                        //     decoration: BoxDecoration(
                        //       image: DecorationImage(
                        //         image: imageProvider,
                        //         fit:  BoxFit.cover,
                        //       ),
                        //     ),
                        //   ),
                        //   placeholder: (context, url) =>
                        //   const CircularProgressIndicator(),
                        //   errorWidget: (context, url, error) => const Icon(Icons.error),
                        // )

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
                                      productId:
                                          widget.prodItemData.productId));
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
                      bottom: 35,
                      left: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? 5
                          : null,
                      right: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? null
                          : 5,
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${widget.prodItemData.productTitle} - ',
                            softWrap: true,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            ' ${widget.prodItemData.productSku}',
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
                    Positioned(
                      bottom: 10,
                      left: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? 5
                          : null,
                      right: AppLocalizations.of(context).locale.languageCode ==
                              'en'
                          ? null
                          : 5,
                      child: _priceBlock(),
                      // Text(
                      //   '${widget.prodItemData.productPrice}',
                      //   textAlign: TextAlign.left,
                      //   style: Theme.of(context).textTheme.subtitle,
                      // ),
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
          padding: EdgeInsets.only(left: 0, top: 5),
          decoration: BoxDecoration(
            color: AppColors.WHITE_COLOR.withOpacity(0.7),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            '${widget.prodItemData.productPrice}',
            softWrap: true,
            style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontFamily: 'Montserrat',
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
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
            decoration: BoxDecoration(
              color: AppColors.WHITE_COLOR.withOpacity(0.7),
              borderRadius: BorderRadius.circular(2),
            ),
            padding: AppLocalizations.of(context).locale.languageCode == 'en'
                ? EdgeInsets.only(left: 5, top: 5)
                : EdgeInsets.only(right: 5, top: 5),
            child: Text(
              '${widget.prodItemData.productOfferPrice}',
              softWrap: true,
              style: TextStyle(
                color: AppColors.RED_COLOR,
                fontFamily: 'Montserrat',
                fontSize: 12.0,
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
