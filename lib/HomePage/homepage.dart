// @dart=2.9
import 'dart:io';

import 'package:aqua/Account/SelectCurrency/bloc/currency_bloc.dart';
import 'package:aqua/Account/SignIn/bloc/user_repository.dart';
import 'package:aqua/Cart/bloc/cart_repository.dart';
import 'package:aqua/HomePage/bloc/homepage_bloc.dart';
import 'package:aqua/HomePage/bloc/homepage_repository.dart';
import 'package:aqua/HomePage/bloc/homepage_response.dart';
import 'package:aqua/HomePage/header_image_slider.dart';
import 'package:aqua/HomePage/homepage_bottom_slider.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
import 'package:aqua/notifications/notifications.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../global.dart';
import 'home_page_gridItem.dart';

class HomePage extends StatefulWidget {
  final Function gotoCart;

  HomePage({Key key, this.gotoCart}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  var banners = [
    'assets/banners/banner1.jpg',
    'assets/banners/banner2.jpg',
  ];
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;
  HomepageBloc _homepageBloc;

  final UserRepository _userRepository = UserRepository();
  final HomePageRepository _homePageRepository = HomePageRepository();

  @override
  void initState() {
    super.initState();
    _homepageBloc = HomepageBloc()..add(Fetch());

    _userRepository.isSignedIn().then((value) {
      Constants.isSignIN = value;
    });

    CartRepository _cartRepository = CartRepository();
    _cartRepository.removeCoupon();
  }

  displayAlert(url) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Container(
              width: 220.0,
              height: 220.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: url,
                    imageBuilder: (context, imageProvider) => Container(
                      //   color: Colors.amber,
                      width: 220.0,
                      height: 220.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.close)))
                ],
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    //  Constants.selectedLang = AppLocalizations.of(context).locale.languageCode;
    return Scaffold(
      backgroundColor: AppColors.WHITE_COLOR,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        //   brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Image.asset(
          'assets/images/aqua-big_medium.png',
          height: 30,
          fit: BoxFit.contain,
          color: Colors.black,
        ),
        actions: [
          IconButton(
              icon: ImageIcon(
                AssetImage("assets/bell.png"),
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (_) => new Notifications()));
              })
        ],
      ),
      body: BlocBuilder<HomepageBloc, HomepageState>(
        bloc: _homepageBloc,
        builder: (context, state) {
          if (state is HomepageInitial) {
            return Center(child: AquaProgressIndicator()

//              SpinKitCubeGrid(
//                color: Colors.black87,
//                size: 30,
//              ),
                );
          }
          if (state is HomepageError) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.refresh,
                  //   ),
                  //   onPressed: () {
                  //     _homepageBloc..add(Fetch());
                  //   },
                  // ),
                  Text(
                    '${state.errorMessage}',
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            );
          }
          if (state is HomepageLoaded) {
            if (Constants.isLanguageChanged) {
              _homepageBloc..add(Fetch());
              Constants.isLanguageChanged = false;
            }
            if ((state.homepageData.data?.popup?.image != null &&
                    state.homepageData.data?.popup?.image != '') &&
                isBannerDisplayed == false) {
              SchedulerBinding.instance.addPostFrameCallback((_) =>
                  displayAlert(state.homepageData.data.popup.image ?? ""));
              isBannerDisplayed = true;
            }
            return RefreshIndicator(
              onRefresh: () {
                _homepageBloc..add(Fetch());
              },
              child: LoadedData(
                homePageData: state.homepageData,
                gotoCart: widget.gotoCart,
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
                  _homepageBloc..add(Fetch());
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
              ),
              Text(
                AppLocalizations.of(context).translate('reload'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LoadedData extends StatelessWidget {
  final HomePageData homePageData;
  final Function gotoCart;

  const LoadedData({Key key, this.homePageData, this.gotoCart})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double globalMediaWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: globalMediaWidth * 0.65,
              width: globalMediaWidth,
              child: HeaderSlider(
                //   mediaImg: banners,
                sliders: homePageData.data.sliders,
                gotoCart: gotoCart,
              ),
            ),
            _mainCategories(homePageData, globalMediaWidth),
            // Container(
            //   margin: const EdgeInsets.only(top: 5),
            //   height: globalMediaWidth * 0.65,
            //   //     width: globalMediaWidth * 0.95,
            //   child: BlocProvider<CurrencyBloc>(
            //     create: (context) => CurrencyBloc()..add(CurrencyRetrive()),
            //     child: HomeBottomBanner(
            //       bottomBannerImage: homePageData.data.banner[0].image,
            //       title: homePageData.data.banner[0].title.toUpperCase(),
            //       gotoCart: gotoCart,
            //     ),
            //   ),
            // ),
            //    _subCategories(homePageData, globalMediaWidth),
            Padding(padding: const EdgeInsets.all(1.5)),

            if ((homePageData.data.newCollection ?? []).isNotEmpty)
              InkWell(
                child: Container(
                  //    height: 25,
                  alignment:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //    color: Colors.transparent.withOpacity(0.7),

                  child: Text(
                    //  'New Collection',
                    homePageData.data.newCollectionTitle.toUpperCase(),

                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        fontFamily:
                            AppLocalizations.of(context).locale.countryCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  Map<String, dynamic> parameters = new Map<String, dynamic>();
                  parameters['cat_id'] =
                      homePageData.data.newCollection.first.productCategoryId;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                            searchParameters: parameters,
                            title: homePageData.data.newCollectionTitle
                                .toUpperCase()),
                        fullscreenDialog: true),
                  ).then((value) => {
//                  if (value != null)
//                    {
//                      if (value == true) {widget.gotoCart(3)}
//                    }
                      });
                },
              ),
            if ((homePageData.data.newCollection ?? []).isNotEmpty)
              Container(
                height: globalMediaWidth / 1.2,
                width: globalMediaWidth - 10,
                child: HomePageBottomSlider(
                  sliders: homePageData.data.newCollection,
                  isFromHome: true,
                  gotoCart: gotoCart,
                ),
              ),
            if ((homePageData.data.laurenCollection ?? []).isNotEmpty)
              InkWell(
                child: Container(
                  //    height: 25,
                  alignment:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //    color: Colors.transparent.withOpacity(0.7),

                  child: Text(
                    //  'New Collection',
                    homePageData.data.laurenCollectionTitle.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        fontFamily:
                            AppLocalizations.of(context).locale.countryCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  Map<String, dynamic> parameters = new Map<String, dynamic>();
                  parameters['cat_id'] = homePageData
                      .data.laurenCollection.first.productCategoryId;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                              searchParameters: parameters,
                              title: homePageData.data.laurenCollectionTitle
                                  .toUpperCase(),
                            ),
                        fullscreenDialog: true),
                  ).then((value) => {
//                  if (value != null)
//                    {
//                      if (value == true) {widget.gotoCart(3)}
//                    }
                      });
                },
              ),
            if ((homePageData.data.laurenCollection ?? []).isNotEmpty)
              Container(
                height: globalMediaWidth / 1.2,
                width: globalMediaWidth - 10,
                child: HomePageBottomSlider(
                  sliders: homePageData.data.laurenCollection ?? [],
                  isFromHome: true,
                  gotoCart: gotoCart,
                ),
              ),

            if ((homePageData.data.girlCollection ?? []).isNotEmpty)
              InkWell(
                child: Container(
                  //    height: 25,
                  alignment:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //    color: Colors.transparent.withOpacity(0.7),

                  child: Text(
                    //  'New Collection',
                    homePageData.data.girlTitle.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        fontFamily:
                            AppLocalizations.of(context).locale.countryCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  Map<String, dynamic> parameters = new Map<String, dynamic>();
                  parameters['cat_id'] =
                      homePageData.data.girlCollection.first.productCategoryId;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                              searchParameters: parameters,
                              title: homePageData.data.girlTitle.toUpperCase(),
                            ),
                        fullscreenDialog: true),
                  ).then((value) => {
//                  if (value != null)
//                    {
//                      if (value == true) {widget.gotoCart(3)}
//                    }
                      });
                },
              ),
            if ((homePageData.data.girlCollection ?? []).isNotEmpty)
              Container(
                height: globalMediaWidth / 1.2,
                width: globalMediaWidth - 10,
                child: HomePageBottomSlider(
                  sliders: homePageData.data.girlCollection ?? [],
                  isFromHome: true,
                  gotoCart: gotoCart,
                ),
              ),
            if ((homePageData.data.saleCollection ?? []).isNotEmpty)
              InkWell(
                child: Container(
                  //    height: 25,
                  alignment:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                  padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //    color: Colors.transparent.withOpacity(0.7),

                  child: Text(
                    //  'New Collection',
                    homePageData.data.saleTitle.toUpperCase(),
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        fontFamily:
                            AppLocalizations.of(context).locale.countryCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () {
                  Map<String, dynamic> parameters = new Map<String, dynamic>();
//                parameters['cat_id'] = homePageData.data.saleCollection.first.productCategoryId;
                  parameters['is_offer'] = 1;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                              searchParameters: parameters,
                              title: homePageData.data.saleTitle.toUpperCase(),
                            ),
                        fullscreenDialog: true),
                  ).then((value) => {
//                  if (value != null)
//                    {
//                      if (value == true) {widget.gotoCart(3)}
//                    }
                      });
                },
              ),
            homePageData.data.saleCollection.length > 0
                ? Container(
                    height: globalMediaWidth / 1.2,
                    width: globalMediaWidth - 10,
                    child: HomePageBottomSlider(
                      sliders: homePageData.data.saleCollection,
                      isFromHome: true,
                      gotoCart: gotoCart,
                    ),
                  )
                : IgnorePointer(),

            Padding(padding: const EdgeInsets.all(10)),
          ],
        ),
      ),
    );
  }

  Widget _mainCategories(HomePageData homePageData, double width) {
    List listOfCategory = [true, false, false, true, false, false, false];
    return BlocProvider<CurrencyBloc>(
      create: (context) => CurrencyBloc()..add(CurrencyRetrive()),
      child: Container(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            height:
                (((width * 0.65) - 2.5) * homePageData.data.category.length) +
                    (5 * homePageData.data.category.length),
            child: ListView.builder(
                itemCount: homePageData.data.category.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Container(
                        width: (width) - 10,
                        height: (width * 0.65) - 2.5,
                        child: HomePageGridItem(
                          imageName: homePageData.data.category[index].image,
                          catId: homePageData.data.category[index].id,
                          title: homePageData.data.category[index].name,
                          position: index < 6 ? listOfCategory[index] : false,
                          optionalParams:
                              homePageData.data.category[index].buttonUrl,
                          gotoCart: gotoCart,
                        ),
                      ),
                      Padding(padding: const EdgeInsets.all(5)),
                    ],
                  );
                }),
          )),
    );
  }

  // Widget _subCategories(HomePageData homePageData, double width) {
  //   return BlocProvider<CurrencyBloc>(
  //     create: (context) => CurrencyBloc()..add(CurrencyRetrive()),
  //     child: Container(
  //         padding: const EdgeInsets.only(top: 2),
  //         child: Column(
  //           children: <Widget>[
  //             Row(
  //               children: <Widget>[
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[0].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[0].id,
  //                     title: homePageData.data.category[0].subcat[0].name
  //                         .toUpperCase(),
  //                     position: true,
  //                   ),
  //                 ),
  //                 Padding(padding: const EdgeInsets.all(1)),
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[1].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[1].id,
  //                     title: homePageData.data.category[0].subcat[1].name
  //                         .toUpperCase(),
  //                     position: false,
  //                   ),
  //                 )
  //               ],
  //             ),

  //             // Second Row
  //             Padding(padding: const EdgeInsets.all(1)),

  //             Row(
  //               children: <Widget>[
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[2].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[2].id,
  //                     title: homePageData.data.category[0].subcat[2].name
  //                         .toUpperCase(),
  //                     position: true,
  //                   ),
  //                 ),
  //                 Padding(padding: const EdgeInsets.all(1)),
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[3].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[3].id,
  //                     title: homePageData.data.category[0].subcat[3].name
  //                         .toUpperCase(),
  //                     position: false,
  //                   ),
  //                 )
  //               ],
  //             ),

  //             // Third Row
  //             Padding(padding: const EdgeInsets.all(1)),

  //             Row(
  //               children: <Widget>[
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[4].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[4].id,
  //                     title: homePageData.data.category[0].subcat[4].name
  //                         .toUpperCase(),
  //                     position: true,
  //                     gotoCart: gotoCart,
  //                   ),
  //                 ),
  //                 Padding(padding: const EdgeInsets.all(1)),
  //                 Container(
  //                   width: (width / 2) - 2.5,
  //                   height: ((width / 2) * 1.36) - 2.5,
  //                   child: HomePageGridItem(
  //                     imageName:
  //                         '${homePageData.data.category[0].subcat[5].imageMedium}',
  //                     catId: int.parse(Constants.catWOMEN),
  //                     subCatId: homePageData.data.category[0].subcat[5].id,
  //                     title: homePageData.data.category[0].subcat[5].name
  //                         .toUpperCase(),
  //                     position: false,
  //                     gotoCart: gotoCart,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         )),
  //   );
  // }
}
