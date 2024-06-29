// @dart=2.9
import 'dart:io';

import 'package:aqua/HomePage/bloc/homepage_response.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
import 'package:aqua/ProductItem/produtItem_model2.dart';
import 'package:aqua/Search/bloc/search_page_bloc.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends StatefulWidget {
  final Function gotoCart;

  SearchPage({Key key, this.gotoCart}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchQuery = new TextEditingController();
  bool _isVisible = true;
  double globalMediaWidth = 0.0;
  double globalMediaHeight = 0.0;

  SearchPageBloc _searchPageBloc;

  @override
  void initState() {
    super.initState();
    _searchPageBloc = SearchPageBloc()..add(SearchPageFetch());
  }

  @override
  Widget build(BuildContext context) {
    globalMediaWidth = MediaQuery.of(context).size.width;
    globalMediaHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        // leading: !_isVisible
        //     ? IconButton(
        //         iconSize: 25.0,
        //         icon: Icon(
        //           Icons.close,
        //           color: AppColors.BLACK_COLOR,
        //         ),
        //         splashColor: AppColors.SPLASH_COLOR,
        //         onPressed: () {
        //           setState(() {
        //             _isVisible = true;
        //           });
        //         },
        //       )
        //     : null,
        title: Image.asset(
          'assets/images/aqua-big_medium.png',
          height: 30,
          fit: BoxFit.contain,
          color: Colors.black,
        ),
        // actions: <Widget>[
        //   CartIcon(counter: 3),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _buildSearchField(),
            _categoriesList(),
          ],
        ),
      ),
      //     : _searchList(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(20),
      child: TextField(
        controller: _searchQuery,
        style: TextStyle(
            color: AppColors.BLACK_COLOR,
            fontSize: 16,
            fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              if (_searchQuery.text.isNotEmpty) {
                FocusScope.of(context).requestFocus(FocusNode());
                Map<String, dynamic> parameters = new Map<String, dynamic>();
                parameters['search_text'] = _searchQuery.text;
                //    parameters['lang'] = 'en';
                parameters['lang'] = Constants.selectedLang;
                parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
                parameters['device_token'] = Constants.deviceUUID;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductsList(
                            searchParameters: parameters,
                            title: _searchQuery.text.toString().toUpperCase(),
                          ),
                      fullscreenDialog: true),
                ).then((value) => {
                      if (value != null)
                        {
                          if (value == true) {widget.gotoCart(3)}
                        }
                    });
              }
            },
          ),
          labelText: AppLocalizations.of(context).translate('search'),
          hintText: AppLocalizations.of(context).translate('searchByKeyword'),
          labelStyle: TextStyle(
            color: AppColors.LIGHT_GRAY_BGCOLOR,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w300,
            fontSize: 15,
          ),
          hintStyle: TextStyle(
            color: AppColors.LIGHT_GRAY_BGCOLOR,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w300,
            fontSize: 16,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.BLACK_COLOR,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.TEXT_GRAY_COLOR,
              width: 0.1,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  launchWhatsApp(context, String url) async {
    try {
      if (await canLaunch("whatsapp://send?phone=" + url.toString())) {
        await launch("whatsapp://send?phone=" + url.toString());
      } else {
        throw 'Could not launch $url';
      }
    } catch (exception) {
      print(exception);
      // alert(
      //   context,
      //   AppLocalizations.of(context).translate("could_not_launch_whatsapp"),
      // );
    }
  }

  Widget _categoriesList() {
    return BlocBuilder<SearchPageBloc, SearchPageState>(
      bloc: _searchPageBloc,
      builder: (context, state) {
        if (state is SearchPageInitial) {
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Padding(padding: const EdgeInsets.only(left: 10)),
                Text('${state.loadMessage}'),
              ],
            ),
          );
        } else if (state is SearchPageError) {
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
                    _searchPageBloc..add(SearchPageFetch());
                  },
                ),
                Text(
                  '${state.errorMessage}',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          );
        } else if (state is SearchPageLoaded) {
          // return Column(
          //   children: <Widget>[
          //     SearchPageWomenList(
          //       gotoCart: widget.gotoCart,
          //       homepageData: state.homepageData,
          //     ),
          //     Padding(
          //       padding: const EdgeInsets.only(top: 10.0),
          //       child: Divider(
          //         indent: 100,
          //         endIndent: 100,
          //       ),
          //     ),
          //     SearchPageGirlList(
          //       gotoCart: widget.gotoCart,
          //       homepageData: state.homepageData,
          //     ),
          //   ],
          // );

          return Column(
            children: <Widget>[
              ListView.builder(
                  shrinkWrap: true,
                  cacheExtent: 10000,
                  itemCount: state.homepageData.data.category.length,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    print(state.homepageData.data.category[index].name
                        .toUpperCase());
                    return (state.homepageData.data.category[index].name
                                    .toUpperCase() !=
                                "SALE" &&
                            state.homepageData.data.category[index].name
                                    .toUpperCase() !=
                                "تنزيلات")
                        ? SearchPageWomenList(
                            gotoCart: widget.gotoCart,
                            category: state.homepageData.data.category[index],
                          )
                        : Container();
                  }),
              ListView.builder(
                  shrinkWrap: true,
                  cacheExtent: 10000,
                  itemCount: state.homepageData.data.sections.length,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: <Widget>[
                        Padding(padding: const EdgeInsets.only(top: 10)),
                        InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            Map<String, dynamic> parameters =
                                new Map<String, dynamic>();
                            if (state.homepageData.data.sections[index].type ==
                                'general') {
                              parameters[state.homepageData.data.sections[index]
                                  .buttonUrl] = 1;
                            } else {
                              parameters['cat_id'] = state
                                  .homepageData.data.sections[index].buttonUrl;
                              print(parameters['cat_id']);
                            }

                            parameters['lang'] = Constants.selectedLang;
                            parameters['device_type'] =
                                Platform.isIOS ? 'ios' : 'android';
                            parameters['device_token'] = Constants.deviceUUID;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductsList(
                                        searchParameters: parameters,
                                        title: state.homepageData.data
                                            .sections[index].title
                                            .toString()
                                            .toUpperCase(),
                                      ),
                                  fullscreenDialog: true),
                            ).then((value) => {
                                  if (value != null)
                                    {
                                      if (value == true) {widget.gotoCart(3)}
                                    }
                                });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            alignment: Alignment.center,
                            height: 30,
                            child: Text(
                              state.homepageData.data.sections[index].title
                                  .toString()
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: (index !=
                                          state.homepageData.data.sections
                                                  .length -
                                              1)
                                      ? AppColors.BLACK_COLOR
                                      : Colors.red,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppLocalizations.of(context)
                                              .locale
                                              .languageCode ==
                                          'en'
                                      ? 'Montserrat'
                                      : 'Almarai',
                                  fontStyle: FontStyle.normal),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Divider(
                            indent: 100,
                            endIndent: 100,
                          ),
                        ),
                      ],
                    );
                  }),
              Padding(padding: const EdgeInsets.only(top: 10)),
              InkWell(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 30,
                  child: Text(
                    AppLocalizations.of(context).translate('liveChat') ?? ' ',
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 19.0,
                        fontWeight: FontWeight.w600,
                        fontFamily:
                            AppLocalizations.of(context).locale.languageCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
                onTap: () async {
                  var url = '+965 9229 3600';
                  launchWhatsApp(context, '+96592293600');
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Divider(
                  indent: 100,
                  endIndent: 100,
                ),
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _searchList() {
    return Container(
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 10, top: 10, right: 10)
          : EdgeInsets.only(right: 10, top: 10),
      child: GridView.count(
        // physics: AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        childAspectRatio: 0.55,
        crossAxisCount: 2,
        // staggeredTiles: List.generate(10, (index) {
        //   return StaggeredTile.count(1, 1.8);
        // }),
        children: List.generate(10, (index) {
          return ProductItem2(
            // imageName: 'assets/demoImages/AquaDemo1.jpg',
            index: index,
          );
        }),
      ),
    );
  }
}

class SearchPageWomenList extends StatefulWidget {
  final Function gotoCart;

  final Category category;
  const SearchPageWomenList({Key key, this.category, this.gotoCart})
      : super(key: key);

  @override
  _SearchPageWomenListState createState() => _SearchPageWomenListState();
}

class _SearchPageWomenListState extends State<SearchPageWomenList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(5)),
        InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());

            Map<String, dynamic> parameters = new Map<String, dynamic>();
            parameters['cat_id'] = widget.category.id;
            parameters['lang'] = Constants.selectedLang;
            parameters['device_type'] = Platform.isIOS ? 'ios' : 'android';
            parameters['device_token'] = Constants.deviceUUID;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductsList(
                        searchParameters: parameters,
                        title: widget.category.name.toString().toUpperCase(),
                      ),
                  fullscreenDialog: true),
            ).then((value) => {
                  if (value != null)
                    {
                      if (value == true) {widget.gotoCart(3)}
                    }
                });
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            alignment: Alignment.center,
            height: 30,
            child: Text(
              widget.category.name.toString().toUpperCase(),
              style: TextStyle(
                  color: AppColors.BLACK_COLOR,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600,
                  fontFamily:
                      AppLocalizations.of(context).locale.languageCode == 'en'
                          ? 'Montserrat'
                          : 'Almarai',
                  fontStyle: FontStyle.normal),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Divider(
            indent: 100,
            endIndent: 100,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 0),
          child: ListView.builder(
            shrinkWrap: true,
            cacheExtent: 10000,
            itemCount: widget.category.subcat.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  Map<String, dynamic> parameters = new Map<String, dynamic>();
                  parameters['cat_id'] = widget.category.id;
                  parameters['sub_cat_id'] = widget.category.subcat[index].id;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                              searchParameters: parameters,
                              title: widget.category.subcat[index].name
                                  .toString()
                                  .toUpperCase(),
                            ),
                        fullscreenDialog: true),
                  ).then((value) => {
                        if (value != null)
                          {
                            if (value == true) {widget.gotoCart(3)}
                          }
                      });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 30,
                  child: Text(
                    widget.category.subcat[index].name.toString().toUpperCase(),
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        fontFamily:
                            AppLocalizations.of(context).locale.languageCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
              );
            },
          ),
        ),
        widget.category.subcat.length > 0
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Divider(
                  indent: 100,
                  endIndent: 100,
                ),
              )
            : Padding(padding: const EdgeInsets.all(0.1)),
      ],
    );
  }
}

class SearchPageGirlList extends StatefulWidget {
  final Function gotoCart;
  final homepageData;
  const SearchPageGirlList({Key key, this.homepageData, this.gotoCart})
      : super(key: key);

  @override
  _SearchPageGirlListState createState() => _SearchPageGirlListState();
}

class _SearchPageGirlListState extends State<SearchPageGirlList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(padding: const EdgeInsets.all(5)),
        Text(
          AppLocalizations.of(context).translate('girls'),
          style: TextStyle(
              color: AppColors.BLACK_COLOR,
              fontSize: 19.0,
              fontWeight: FontWeight.w600,
              fontFamily:
                  AppLocalizations.of(context).locale.languageCode == 'en'
                      ? 'Montserrat'
                      : 'Almarai',
              fontStyle: FontStyle.normal),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Divider(
            indent: 100,
            endIndent: 100,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 0),
          child: ListView.builder(
            shrinkWrap: true,
            cacheExtent: 10000,
            itemCount: widget.homepageData.data.category[1].subcat.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  Map<String, dynamic> parameters = new Map<String, dynamic>();
                  parameters['cat_id'] = Constants.catGIRLS;
                  parameters['sub_cat_id'] =
                      widget.homepageData.data.category[1].subcat[index].id;
                  parameters['lang'] = Constants.selectedLang;
                  parameters['device_type'] =
                      Platform.isIOS ? 'ios' : 'android';
                  parameters['device_token'] = Constants.deviceUUID;
                  Constants.sortString = '';

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductsList(
                              searchParameters: parameters,
                              title: widget.homepageData.data.category[1]
                                  .subcat[index].name
                                  .toString()
                                  .toUpperCase(),
                            ),
                        fullscreenDialog: true),
                  ).then((value) => {
                        if (value != null)
                          {
                            if (value == true) {widget.gotoCart(3)}
                          }
                      });
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: 30,
                  child: Text(
                    widget.homepageData.data.category[1].subcat[index].name
                        .toString()
                        .toUpperCase(),
                    style: TextStyle(
                        color: AppColors.BLACK_COLOR,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        fontFamily:
                            AppLocalizations.of(context).locale.languageCode ==
                                    'en'
                                ? 'Montserrat'
                                : 'Almarai',
                        fontStyle: FontStyle.normal),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
