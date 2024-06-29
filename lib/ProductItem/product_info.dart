// @dart=2.9
import 'dart:ui';

import 'package:aqua/Cart/bloc/cart_bloc.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/ProductItem/RelatedProducts/bloc/related_products_bloc.dart';
import 'package:aqua/ProductItem/cart_Icon.dart';
import 'package:aqua/ProductItem/productItem_model3.dart';
import 'package:aqua/ProductItem/produtItem_model2.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinch_zoom_image_last/pinch_zoom_image_last.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProductInfo extends StatefulWidget {
  // final int index;
  final bool isFromHome;
  final bool isFromWishList;
  final ProdItemData prodItemData;
  ProductInfo(
      {Key key, this.prodItemData, this.isFromHome, this.isFromWishList})
      : super(key: key);

  @override
  _ProductInfoState createState() => _ProductInfoState();
}

class _ProductInfoState extends State<ProductInfo> {
  double _panelHeightOpen;
  double _panelHeightClosed = 150.0;
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;

  PanelController _pc = new PanelController();
  PageController pageController = PageController();
  int finalIndex = 0;
  double _currentPosition = 0.0;
  var _totalDots = 0.0;
  bool isPanelHide = false;
  int isColorSelected;
  int isSizeSelected;
  bool isTouchHideControls = true;
  CartBloc _cartBloc;
  int tmpCartCount = 0;
  PanelState currentPannelState = PanelState.OPEN;
  @override
  void initState() {
    super.initState();

    print('count:${widget.prodItemData}');
    _totalDots = widget.prodItemData.gallery.length.toDouble();
    _cartBloc = CartBloc();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * 0.75;
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocProvider<CartBloc>(
        create: (context) => CartBloc()..add(CartListFetch()),
        child: BlocListener<CartBloc, CartState>(
          listener: (context, state) async {
            if (state is CartAddLoading) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.greenAccent,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AquaProgressIndicator(),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('addingItemtoCart'),
                          style: TextStyle(
                            color: AppColors.BLACK_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is CartAddError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(milliseconds: 2000),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          '${state.errorMessage}',
                          style: TextStyle(
                            color: AppColors.WHITE_COLOR,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: AppColors.RED_COLOR,
                ),
              );
            }
            if (state is CartAddLoaded) {
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => SimpleDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate('itemAddedtoCart'),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  contentPadding:
                      EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  children: <Widget>[
                    ElevatedButton(
                      // color: Colors.black,
                      child: Text(
                        AppLocalizations.of(context).translate('viewCart'),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   side: BorderSide(
                        //     color: AppColors.BLACK_COLOR,
                        //   ),
                        // )
                      ),
                      onPressed: () {
                        print(widget.isFromHome);
//                      if(  (widget.isFromHome?? false)) {
//                        Navigator.pop(context, true);
//                      }
//                        Navigator.pop(context, true);
//                        Navigator.pop(context, true);

                        if (widget.isFromWishList ?? false) {
                          Navigator.pop(context, true);
                          Navigator.pop(context, true);
                        } else {
                          if (widget.isFromHome == true) {
                            // Navigator.pop(context, true);
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          } else {
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                            Navigator.pop(context, true);
                          }
                        }
                      },
                    ),
                    ElevatedButton(
                      // color: Colors.black,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        //   side: BorderSide(
                        //     color: AppColors.BLACK_COLOR,
                        //   ),
                        // )
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate('continueShopping'),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              );
            }
          },
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                SlidingUpPanel(
                  maxHeight: _panelHeightOpen,
                  minHeight: _panelHeightClosed,
                  parallaxEnabled: false,
                  controller: _pc,
                  parallaxOffset: .5,
                  body: _productImagesSlider1(),
                  panelBuilder: (sc) => _itemInfoDetails(sc),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  onPanelSlide: (double pos) => setState(() {
                    print(pos);
                    pos > 0.2 ? isPanelHide = true : isPanelHide = false;
                  }),
                  onPanelOpened: () {
                    //     isPanelHide = true;
                  },
                  onPanelClosed: () {
                    //   isPanelHide = false;
                  },
                  //     defaultPanelState: currentPannelState,
                ),
                widget.prodItemData.bundles.length > 0
                    ? Visibility(
                        visible: !isPanelHide,
                        child: _totalDots > 0.0
                            ? Positioned(
                                bottom: 220,
                                right: 20,
                                child: Container(
                                    child: ElevatedButton(
                                  onPressed: () {
                                    // print(widget.prodItemData.bundles);
                                    _viewTheLook(
                                        context, widget.prodItemData.bundles);
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 10),
                                          child: Text(
                                            AppLocalizations.of(context)
                                                .translate('view_the_look'),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600),
                                          )),
                                      ImageIcon(
                                        AssetImage('assets/images/hanger.png'),
                                        size: 25,
                                      )
                                    ],
                                  ),
                                )
                                    // IconButton(
                                    //   iconSize: 25.0,
                                    //   icon: Icon(
                                    //     Icons.close,
                                    //     color: AppColors.BLACK_COLOR,
                                    //   ),
                                    //   splashColor: AppColors.SPLASH_COLOR,
                                    //   onPressed: () {
                                    //     Navigator.of(context).pop();
                                    //   },
                                    // ),
                                    ),
                              )
                            : Container())
                    : Container(),
                // Text("dfhgfh"),
                Visibility(
                  visible: !isPanelHide,
                  child: _totalDots > 0.0
                      ? Positioned(
                          bottom: 180,
                          left: 0,
                          right: 0,
                          child: _buildRow([
                            DotsIndicator(
                              dotsCount: _totalDots.floor(),
                              position: _currentPosition,
                              axis: Axis.horizontal,
                              decorator: DotsDecorator(
                                activeColor: AppColors.APP_PRIMARY,
                                size: const Size.square(6.0),
                                activeSize: const Size(6.0, 9.0),
                                activeShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3.0)),
                              ),
                            ),
                          ]))
                      : Align(),
                ),
                Positioned(
                  top: 60,
                  left: 10,
                  child: Container(
                    child: IconButton(
                      iconSize: 25.0,
                      icon: Icon(
                        Icons.close,
                        color: AppColors.BLACK_COLOR,
                      ),
                      splashColor: AppColors.SPLASH_COLOR,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final _scrollController = ScrollController();
  void _viewTheLook(context, bundles) {
    print(bundles.length);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              child:
                  // ListView.builder(
                  //     itemCount: bundles.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //   return
                  //ProductLook();//Text("qeqweqw");
                  GridView.count(
            controller: _scrollController,
            childAspectRatio: 0.55,
            crossAxisCount: 2,
//                   staggeredTiles:
//                   List.generate(bundles.length, (index) {
// //          if (index % 3 == 0) {
// //            return StaggeredTile.count(3, 1.5);
// //          } else {
//                     return StaggeredTile.count(1, 1.8);
//                     //  }
//                   }),
            children: List.generate(bundles.length, (index) {
//          if (index % 3 == 0) {
//            return ProductItem1(
//              index: index,
//              prodItemData: widget.productItemsData[index],
//              // imageName: 'assets/demoImages/AquaHor1.jpg',
//            );
//          }
              // if (index % 3 == 1) {
              return ProductItem2(
                index: index,
                prodItemData: bundles[index],
                isBundle: true,
              );
//          } else {
//            return ProductItem2(
//              index: index,
//              prodItemData: widget.productItemsData[index],
//            );
//          }
            }),
            padding: const EdgeInsets.only(
              left: 2.0,
              right: 2.0,
            ),
          )

              //   ProductItem2(
              //   index: index,prodItemData: bundles[index],isBundle: true,
              // );

              // })

              // ListView.builder(
              //   //cacheExtent: 10000,
              //   itemCount: bundles.length,
              //   shrinkWrap: true,
              //   // scrollDirection: Axis.horizontal,
              //   itemBuilder: (BuildContext context, int index) {
              //     return Text("werwer");
              //
              //
              //     //   ProductItem2(
              //     //   index: index,prodItemData: bundles[index],isBundle: true,
              //     // );
              //   },
              // ),
              );
        });
  }

  Widget _buildRow(List<Widget> widgets) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgets,
    );
  }

  Widget _productImagesSlider1() {
    return GestureDetector(
      onTap: () {
        if (isTouchHideControls) {
          _pc.hide();
          setState(() {
            //   isPanelHide = true;
            isTouchHideControls = false;
          });
        } else {
          _pc.show();
          setState(() {
            //   isPanelHide = false;

            isTouchHideControls = true;
          });
        }
      },
      child: Container(
        width: globalMediaWidth,
        height: globalMediaHeight,
        child: NotificationListener(
            onNotification: (ScrollNotification overscroll) {
              print(overscroll);
              if (overscroll is OverscrollNotification &&
                  overscroll.metrics.pixels >=
                      overscroll.metrics.maxScrollExtent &&
                  overscroll.dragDetails != null) {
                print('Inside');
                _pc.open();
              }
              if (overscroll is OverscrollNotification &&
                  overscroll.metrics.pixels <=
                      overscroll.metrics.minScrollExtent &&
                  overscroll.dragDetails != null) {
                print('onExit');
                Navigator.of(context).pop();
              }
            },
            child: PageView(
              children: widget.prodItemData.gallery.map(
                (galaryData) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: PinchZoomImage(
                      image: Container(
                        child: CachedNetworkImage(
                          imageUrl: galaryData.imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1000,
                            // color: Colors.yellow,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              Center(child: const CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              Center(child: const Icon(Icons.error)),
                        ),
                      ),
                      zoomedBackgroundColor: Colors.transparent,
                      hideStatusBarWhileZooming: true,
                      onZoomStart: () {
                        print('Zoom started');
                      },
                      onZoomEnd: () {
                        print('Zoom finished');
                      },
                    ),
                  );
                },
              ).toList(),
              onPageChanged: (val) {
                _updatePosition(val);
                setState(() {
                  finalIndex = val;
                });
              },
            )
            // CarouselSlider(
            //   scrollPhysics: ClampingScrollPhysics(),
            //   scrollDirection: Axis.vertical,
            //   viewportFraction: 0.9,
            //   enableInfiniteScroll: false,
            //   aspectRatio: 16 / 9,
            //   autoPlay: false,
            //   enlargeCenterPage: true,
            //   items: widget.prodItemData.gallery.map(
            //     (galaryData) {
            //       return
            //         ClipRRect(
            //         borderRadius: BorderRadius.circular(20.0),
            //         child:
            //         PinchZoomImage(
            //           image: Container(
            //             child: CachedNetworkImage(
            //               imageUrl: galaryData.imageUrl,
            //               imageBuilder: (context, imageProvider) => Container(
            //                 width: MediaQuery.of(context).size.width,
            //                  height: 1000,
            //                 // color: Colors.yellow,
            //                 decoration: BoxDecoration(
            //                   image: DecorationImage(
            //                     image: imageProvider,
            //                   ),
            //                 ),
            //               ),
            //               placeholder: (context, url) =>
            //                   Center(child: const CircularProgressIndicator()),
            //               errorWidget: (context, url, error) =>
            //                   Center(child: const Icon(Icons.error)),
            //             ),
            //           ),
            //           zoomedBackgroundColor: Colors.transparent,
            //           hideStatusBarWhileZooming: true,
            //           onZoomStart: () {
            //             print('Zoom started');
            //           },
            //           onZoomEnd: () {
            //             print('Zoom finished');
            //           },
            //         ),
            //       );
            //     },
            //   ).toList(),
            //   onPageChanged: (val) {
            //     _updatePosition(val);
            //     setState(() {
            //       finalIndex = val;
            //     });
            //   },
            // ),
            ),
      ),
    );
  }

  void _updatePosition(int position) {
    setState(() => _currentPosition = _validPosition(position.toDouble()));
  }

  double _validPosition(double position) {
    if (position >= _totalDots) return 0.0;
    if (position < 0) return _totalDots - 1.0;
    return position;
  }

  Widget _itemInfoDetails(ScrollController sc) {
    // return MediaQuery.removePadding(
    //   context: context,
    //   removeTop: true,
    print(widget.prodItemData.sizeChart);
    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        controller: sc,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? EdgeInsets.only(left: 20, top: 20)
                          : EdgeInsets.only(right: 20, top: 20),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${widget.prodItemData.productTitle} - ',
                        softWrap: true,
                        style: Theme.of(context).textTheme.headline3,
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        '${widget.prodItemData.productSku}',
                        softWrap: true,
                        style: Theme.of(context)
                            .textTheme
                            .headline3
                            .copyWith(color: Colors.grey),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    _cartBloc = BlocProvider.of<CartBloc>(context);
                    if (state is CartListLoaded) {
                      print(widget.prodItemData.sizeChartDescription);
                      print('inside CartLoaded');
                      tmpCartCount =
                          state.cartListResponse.data.cartTotalQuantity;
                      return Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 10, right: 20),
                        child: CartIcon(
                          isFromHome: widget.isFromHome,
                          isFromWishList: widget.isFromWishList,
                          counter:
                              state.cartListResponse.data.cartTotalQuantity,
                        ),
                      );
                    }
                    if (state is CartAddLoaded) {
                      print('inside CartAddLoaded');
                      tmpCartCount =
                          state.cartListResponse.data.cartTotalQuantity;

                      return Container(
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(top: 10, right: 20),
                        child: CartIcon(
                          isFromHome: widget.isFromHome,
                          isFromWishList: widget.isFromWishList,
                          counter:
                              state.cartListResponse.data.cartTotalQuantity,
                        ),
                      );
                    }
                    if (state is CartAddError) {}
                    return Container(
                      alignment: Alignment.centerRight,
                      margin: const EdgeInsets.only(top: 10, right: 20),
                      child: CartIcon(
                        isFromHome: widget.isFromHome,
                        isFromWishList: widget.isFromWishList,
                        counter: tmpCartCount,
                      ),
                    );
                  },
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? EdgeInsets.only(left: 20, top: 5)
                          : EdgeInsets.only(right: 20, top: 5),
                  child: Text(
                    '${widget.prodItemData.productPrice}',
                    softWrap: true,
                    style: TextStyle(
                      color: AppColors.BLACK_COLOR,
                      fontFamily: 'Montserrat',
                      fontSize: 14.0,
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
                    padding:
                        AppLocalizations.of(context).locale.languageCode == 'en'
                            ? EdgeInsets.only(left: 5, top: 5)
                            : EdgeInsets.only(right: 5, top: 5),
                    child: Text(
                      '${widget.prodItemData.productOfferPrice}',
                      softWrap: true,
                      style: TextStyle(
                        color: AppColors.RED_COLOR,
                        fontFamily: 'Montserrat',
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
            // _colorContainer(),
            // _selectedColorText(),
            Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                initiallyExpanded: true,
                title: Container(
                  margin:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? EdgeInsets.only(top: 0, left: 0)
                          : EdgeInsets.only(top: 20, right: 10),
                  child: Text(
                    '${AppLocalizations.of(context).translate('color_and_size')} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                // expandedCrossAxisAlignment: CrossAxisAlignment.start,
                // expandedAlignment: Alignment.topLeft,
                children: [
                  Container(
                    margin:
                        AppLocalizations.of(context).locale.languageCode == 'en'
                            ? EdgeInsets.only(top: 10, left: 20)
                            : EdgeInsets.only(top: 10, right: 10),
                    child: Text(
                      '${AppLocalizations.of(context).translate('select_color')} ',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      //    style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  _colorContainer(),
                  _selectedColorText(),
                  Container(
                    margin:
                        AppLocalizations.of(context).locale.languageCode == 'en'
                            ? EdgeInsets.only(top: 28, left: 20)
                            : EdgeInsets.only(top: 20, right: 10),
                    child: Text(
                      '${AppLocalizations.of(context).translate('select_size')} ',
                      style: Theme.of(context).textTheme.headline1.copyWith(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      //style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  _selectSize(),
                  Container(
                    width: globalMediaWidth,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _addButton(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              Share.share(
                                '${AppLocalizations.of(context).translate('checkoutthisProduct')} https://www.aquafashion.com/product-${widget.prodItemData.productId}',
                                subject: AppLocalizations.of(context)
                                    .translate('aquaFashionProduct'),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),

                  // Container(
                  //     padding: EdgeInsets.only(left: 20),child: Html(data: widget.prodItemData.sizeChartDescription))
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Container(
                  margin:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? EdgeInsets.only(top: 0, left: 0)
                          : EdgeInsets.only(top: 20, right: 10),
                  child: Text(
                    '${AppLocalizations.of(context).translate('size_and_fit')} ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                    //style: Theme.of(context).textTheme.headline3,
                  ),
                ),
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 20),
                      child:
                          Html(data: widget.prodItemData.sizeChartDescription))
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),
            // Theme(
            //   data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            //   child: ExpansionTile(title:
            //   Container(
            //     margin: AppLocalizations.of(context).locale.languageCode == 'en'
            //         ? EdgeInsets.only(top: 0, left: 0)
            //         : EdgeInsets.only(top: 20, right: 10),
            //     child: Text(
            //       '${AppLocalizations.of(context).translate('selectSize')} ',
            //       style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
            //       //style: Theme.of(context).textTheme.headline3,
            //     ),
            //   ),
            //
            //     children: [
            //       _selectSize(),
            //       Container(
            //         width: globalMediaWidth,
            //         padding: EdgeInsets.symmetric(horizontal: 0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: <Widget>[
            //             _addButton(),
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: IconButton(
            //                 icon: Icon(Icons.share),
            //                 onPressed: () {
            //                   Share.share(
            //                     '${AppLocalizations.of(context).translate('checkoutthisProduct')} https://www.aquafashion.com/product-${widget.prodItemData.productId}',
            //                     subject: AppLocalizations.of(context)
            //                         .translate('aquaFashionProduct'),
            //                   );
            //                 },
            //               ),
            //             )
            //           ],
            //         ),
            //       ),
            //   ],),
            // ),

            // Container(
            //   padding: const EdgeInsets.only(top: 20),
            //   margin: AppLocalizations.of(context).locale.languageCode == 'en'
            //       ? EdgeInsets.only(top: 20, left: 10)
            //       : EdgeInsets.only(top: 20, right: 10),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: <Widget>[
            //       Text(
            //         '${AppLocalizations.of(context).translate('selectSize')} :',
            //         style: Theme.of(context).textTheme.headline3,
            //       ),
            //       Container(
            //           margin: EdgeInsets.only(right: 10.0),
            //           child: InkWell(
            //             child: Text(
            //               AppLocalizations.of(context).translate('sizeChart'),
            //               style: Theme.of(context).textTheme.body2.copyWith(
            //                   color: Colors.blue, fontWeight: FontWeight.w500),
            //             ),
            //             onTap: () async {
            //               await showDialog(
            //                 context: context,
            //                 barrierDismissible: true,
            //                 builder: (_) => Directionality(
            //                   textDirection: TextDirection.ltr,
            //                   child: SimpleDialog(
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(16.0),
            //                     ),
            //                     contentPadding: EdgeInsets.only(
            //                         top: 10.0, left: 10.0, right: 10.0),
            //                     children: <Widget>[
            //                       SizedBox(
            //                         width: 250.0,
            //                         height: 400.0,
            //                         child: Center(
            //                           child: CachedNetworkImage(
            //                             imageUrl: widget.prodItemData.sizeChart,
            //                             imageBuilder:
            //                                 (context, imageProvider) => Center(
            //                               child: Container(
            //                                 decoration: BoxDecoration(
            //                                   image: DecorationImage(
            //                                     image: imageProvider,
            //                                     fit: BoxFit.fill,
            //                                   ),
            //                                 ),
            //                               ),
            //                             ),
            //                             placeholder: (context, url) => Center(
            //                                 child: CircularProgressIndicator()),
            //                             errorWidget: (context, url, error) =>
            //                                 Icon(Icons.error),
            //                           ),
            //                         ),
            //                       ),
            //                       FlatButton(
            //                         child: Text(AppLocalizations.of(context)
            //                             .translate('ok')),
            //                         onPressed: () {
            //                           Navigator.of(context).pop();
            //                         },
            //                       )
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           ))
            //     ],
            //   ),
            // ),
            // _selectSize(),
            // Container(
            //   width: globalMediaWidth,
            //   padding: EdgeInsets.symmetric(horizontal: 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: <Widget>[
            //       _addButton(),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: IconButton(
            //           icon: Icon(Icons.share),
            //           onPressed: () {
            //             Share.share(
            //               '${AppLocalizations.of(context).translate('checkoutthisProduct')} https://www.aquafashion.com/product-${widget.prodItemData.productId}',
            //               subject: AppLocalizations.of(context)
            //                   .translate('aquaFashionProduct'),
            //             );
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // Divider(
            //   thickness: 1,
            //   color: Colors.grey[300],
            // ),
            Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Container(
                  child: Text(
                    '${AppLocalizations.of(context).translate('overView')}',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10, right: 10),
                    width: globalMediaWidth - 40,
                    child: RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.headline1,
                        text: Constants.removeAllHtmlTags(
                            widget.prodItemData.productDescription),
                        //         'Soft and light nida fabric Long loose wide sleeves Contrast sequin details on front Matching Sheila included ',
                      ),
                    ),
                  ),
                  // Container(
                  //     padding: EdgeInsets.only(left: 20),child: Html(data: widget.prodItemData.sizeChartDescription))
                ],
              ),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey[300],
            ),

            // _descBlock(),

            Container(
              padding: const EdgeInsets.only(top: 20),
              margin: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(
                      top: 20,
                      left: 10,
                      bottom: 10,
                    )
                  : EdgeInsets.only(
                      top: 20,
                      right: 10,
                      bottom: 10,
                    ),
              child: Text(
                AppLocalizations.of(context).translate('relatedProducts'),
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),

            _similarproducts(widget.prodItemData),
            Padding(padding: const EdgeInsets.all(20)),
          ],
        ),
      ),
    );
  }

  Widget _selectedColorText() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(top: 10, left: 10)
          : EdgeInsets.only(top: 10, right: 10),
      child: Row(
        children: <Widget>[
          Text(
            '${AppLocalizations.of(context).translate('selectedColor')} : ',
            style: Theme.of(context).textTheme.headline3,
          ),
          Text(
            isColorSelected != null
                ? '${widget.prodItemData.colors[isColorSelected].colorName}'
                : '',
            style: Theme.of(context).textTheme.headline3,
          ),
        ],
      ),
    );
  }

  void _checkColorOrSizeSelected(String msg) {
    Alert(
      context: context,
      title: AppLocalizations.of(context).translate('alert'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            msg,
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

  Widget _addButton() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 20, top: 10)
          : EdgeInsets.only(right: 20, top: 10),
      child: ElevatedButton(
        onPressed: () {
          if (isSizeSelected == null) {
            _checkColorOrSizeSelected(
              AppLocalizations.of(context).translate('pleaseSelectSize'),
            );
          } else if (isColorSelected == null) {
            _checkColorOrSizeSelected(
              AppLocalizations.of(context).translate('pleaseSelectColor'),
            );
          } else {
            _cartBloc.add(
              CartAddEvent(
                widget.prodItemData.productId,
                widget.prodItemData.sizes[isSizeSelected].sizeId,
                widget.prodItemData.colors[isColorSelected].colorId,
                1,
              ),
            );
          }
        },
        // color: AppColors.WHITE_COLOR,
        child: Container(
          alignment: Alignment.center,
          height: 40,
          width: 100,
          child: Text(
            AppLocalizations.of(context).translate('add'),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),

        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.WHITE_COLOR,
            shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: AppColors.BLACK_COLOR,
              ),
            )),
        // shape: new RoundedRectangleBorder(
        //   side: BorderSide(color: AppColors.BLACK_COLOR),
        // ),
      ),
    );
  }

  Widget _colorContainer() {
    print(widget.prodItemData.colors);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 34,
      width: globalMediaWidth,
      alignment: AppLocalizations.of(context).locale.languageCode == 'en'
          ? Alignment.centerLeft
          : Alignment.centerRight,
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 10, top: 20, right: 10)
          : EdgeInsets.only(left: 10, top: 20, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.prodItemData.colors.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  isColorSelected = index;
                });
              },
              child: Container(
                width: 34,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  color: Colors.white,
                  border: isColorSelected == index
                      ? Border.all(
                          color: AppColors.BLACK_COLOR,
                          width: 2,
                        )
                      : Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                ),
                child: Container(
                  width: 26,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(300),
                    color: Constants.hexToColor(
                        widget.prodItemData.colors[index].colorCode),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _selectSize() {
    return Container(
      height: 50,
      width: globalMediaWidth,
      alignment: AppLocalizations.of(context).locale.languageCode == 'en'
          ? Alignment.centerLeft
          : Alignment.centerRight,
      margin: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.prodItemData.sizes.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  isSizeSelected = index;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(300),
                  color: isSizeSelected == index
                      ? AppColors.LIGHT_GRAY_BGCOLOR.withOpacity(0.3)
                      : AppColors.LIGHT_GRAY_BGCOLOR.withOpacity(0.1),
                  border: isSizeSelected == index
                      ? Border.all(
                          color: AppColors.BLACK_COLOR,
                          width: 2,
                        )
                      : Border.all(
                          color: Colors.transparent,
                          width: 2,
                        ),
                ),
                child: Text(
                  '${widget.prodItemData.sizes[index].sizeName}',
                  style: widget.prodItemData.sizes[index].sizeName.length < 3
                      ? Theme.of(context).textTheme.headline3
                      : Theme.of(context).textTheme.headline1,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _descBlock() {
    return Container(
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 10, top: 10)
          : EdgeInsets.only(right: 10, top: 10),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(
                '${AppLocalizations.of(context).translate('overView')} : ',
                style: Theme.of(context).textTheme.headline3),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10),
            width: globalMediaWidth - 40,
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: Theme.of(context).textTheme.headline1,
                text: Constants.removeAllHtmlTags(
                    widget.prodItemData.productDescription),
                //         'Soft and light nida fabric Long loose wide sleeves Contrast sequin details on front Matching Sheila included ',
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool checkOfferPrice() {
    String offerPrice = widget.prodItemData.productOfferPrice;
    String offerPriceValue;
    print(Constants.selectedCurrencyString);

    offerPriceValue =
        offerPrice.replaceAll(new RegExp(r'[^0-9]', dotAll: true), ''); // '23'

    if (double.parse(offerPriceValue) > 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget _similarproducts(ProdItemData prodItemData) {
    return BlocProvider<RelatedProductsBloc>(
      create: (context) {
        Map<String, dynamic> parameters = Map<String, dynamic>();
        parameters['cat_id'] = prodItemData.productCategoryId;
        parameters['sub_cat_id'] = prodItemData.productSubCategoryId;
        return RelatedProductsBloc()
          ..add(RelatedProductsFetch(parameters: parameters));
      },
      child: BlocBuilder<RelatedProductsBloc, RelatedProductsState>(
        builder: (context, state) {
          if (state is RelatedProductsInitial) {
            return Center(
              child: AquaProgressIndicator(),
            );
          }
          if (state is RelatedProductsError) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                    ),
                    onPressed: () {
                      //    _homepageBloc..add(Fetch());
                    },
                  ),
                  Expanded(
                    child: Text(
                      '${state.errorMessage}',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is RelatedProductsLoaded) {
            return Container(
              height: 250,
              margin: AppLocalizations.of(context).locale.languageCode == 'en'
                  ? EdgeInsets.only(left: 10, top: 10)
                  : EdgeInsets.only(right: 10, top: 10),
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                cacheExtent: 10000,
                itemCount: state.productItemResponse.productItemData.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return RelateProductItem(
                    prodItemData:
                        state.productItemResponse.productItemData[index],
                    index: index,
                  );
                },
              ),
            );
          }
          return Row(
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.refresh,
                ),
                onPressed: () {
                  //   _homepageBloc..add(Fetch());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
              ),
              Text(
                AppLocalizations.of(context).translate('girls'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductLook extends StatefulWidget {
  @override
  _ProductLookState createState() => _ProductLookState();
}

class _ProductLookState extends State<ProductLook> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Text("hi"));
  }
}
