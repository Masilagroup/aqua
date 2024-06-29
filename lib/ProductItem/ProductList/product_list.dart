// @dart=2.9
import 'package:aqua/ProductItem/ProductList/bloc/product_list_bloc.dart';
import 'package:aqua/ProductItem/productItem_model1.dart';
import 'package:aqua/ProductItem/produtItem_model2.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'bloc/product_list_response.dart';

class ProductsList extends StatefulWidget {
  final Map<String, dynamic> searchParameters;
  final String categoryID;
  final String title;

  ProductsList({Key key, this.categoryID, this.title, this.searchParameters})
      : super(key: key);

  @override
  _ProductsListState createState() => _ProductsListState();
}

var filterSize;
bool loadPage = false;

class _ProductsListState extends State<ProductsList> {
  ProductListBloc _productListBloc;
  int offsetValue = 0;
  bool sortingValue;
  bool isLoading = true;

  List<FilterSize> filterSizes = [];
  @override
  void initState() {
    super.initState();

    _productListBloc = ProductListBloc()
      ..add(ProductsFetch(
        parameters: widget.searchParameters,
        offset: offsetValue,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        brightness: Brightness.light,
        elevation: 1.0,
        titleSpacing: 30.0,
        actionsIconTheme: Theme.of(context).iconTheme,
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: AppColors.WHITE_COLOR,
        title: Text(
          widget.title.toUpperCase(),
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              sortingValue == null
                  ? FontAwesomeIcons.sortAmountDownAlt
                  : (sortingValue == true
                      ? FontAwesomeIcons.sortAmountUp
                      : FontAwesomeIcons.sortAmountDown),
              size: 20,
              color: sortingValue == null
                  ? AppColors.DEEP_LIGHT_GRAY
                  : AppColors.BLACK_COLOR,
            ),
            onPressed: () {
              if ((sortingValue == null) || (sortingValue == true)) {
                setState(() {
                  sortingValue = false;
                });
                Constants.sortString = 'price_desc';
              } else {
                setState(() {
                  sortingValue = true;
                });
                Constants.sortString = 'price_asc';
              }
              _productListBloc = ProductListBloc()
                ..add(ProductsFetch(
                    parameters: widget.searchParameters,
                    offset: 0,
                    filteredSize: filterSize));
            },
          ),
          BlocBuilder<ProductListBloc, ProductListState>(
              bloc: _productListBloc,
              builder: (context, state) {
                return IgnorePointer(
                  ignoring: filterSizes.length > 0 ? false : true,
                  child: PopupMenuButton<FilterSize>(
                    onSelected: (var selectedFilter) {
                      filterSize = selectedFilter.id;
                      _productListBloc.add(ProductsFetch(
                          parameters: widget.searchParameters,
                          offset: 0,
                          filteredSize: filterSize,
                          isRemoveOldData: true));
                    },
                    icon: Icon(Icons.location_disabled,
                        color: filterSizes.length > 0
                            ? Colors.black
                            : Colors.grey),
                    itemBuilder: (BuildContext context) {
                      return filterSizes.map((FilterSize choice) {
                        return PopupMenuItem<FilterSize>(
                          value: choice,
                          child: Text(
                            choice.name,
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      }).toList();
                    },
                  ),
                );
              })
        ],
      ),
      body:

          // loadPage
          //     ? Center(
          //         child: AquaProgressIndicator(),
          //       )
          //     :
          BlocBuilder<ProductListBloc, ProductListState>(
        bloc: _productListBloc,
        builder: (context, state) {
          if (state is ProductListInitial || state is ProductListLoading) {
            return Center(
              child: AquaProgressIndicator(),
            );
          }
          if (state is ProductListError) {
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
                  //     _productListBloc
                  //       ..add(ProductsFetch(
                  //         parameters: widget.searchParameters,
                  //         offset: offsetValue,
                  //       ));
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
          if (state is ProductListLoaded) {
            filterSizes = state.filterSizes;

            if (state.productsList.length <= 0) {
              return Center(
                child: Text(
                  AppLocalizations.of(context).translate('noItemsFound'),
                ),
              );
            } else {
              isLoading = false;
              return PItemsLoaded(
                  productListBloc: _productListBloc,
                  productItemsData: state.productsList,
                  searchParameters: widget.searchParameters,
                  offsetValue: state.productsList.length,
                  isLoading: isLoading);
            }
          }
          return Center(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    _productListBloc
                      ..add(ProductsFetch(
                          parameters: widget.searchParameters,
                          offset: offsetValue,
                          filteredSize: filterSize ?? ""));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                ),
                Text(
                  AppLocalizations.of(context).translate('reload'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class PItemsLoaded extends StatefulWidget {
  final List<ProdItemData> productItemsData;
  final Map<String, dynamic> searchParameters;
  final ProductListBloc productListBloc;
  final int offsetValue;
  bool isLoading;
  PItemsLoaded(
      {Key key,
      this.productItemsData,
      this.searchParameters,
      this.productListBloc,
      this.offsetValue,
      this.isLoading})
      : super(key: key);

  @override
  _PItemsLoadedState createState() => _PItemsLoadedState();
}

class _PItemsLoadedState extends State<PItemsLoaded> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  bool showLoadMore = false;
  bool isLoading;
  @override
  void initState() {
    super.initState();
    // isLoading = widget.isLoading;
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // _sc.position.pixels ==
  // _sc.position.maxScrollExtent

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // maxScroll  ==currentScroll
    // if ((maxScroll - currentScroll == _scrollThreshold) &&
    //     (widget.offsetValue % 20 == 0)) {
    if ((maxScroll == currentScroll) &&
        (widget.offsetValue % 20 == 0) &&
        (widget.isLoading == false)) {
      setState(() {
        showLoadMore = true;
      });

      // setState(() {
      //   widget.isLoading = true;
      // });
      // widget.productListBloc.add(ProductsFetch(
      //     parameters: widget.searchParameters,
      //     offset: widget.offsetValue,
      //     filteredSize: filterSize));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //  padding: const EdgeInsets.only(bottom: 50),
      margin: EdgeInsets.only(
        top: 4.0,
      ),
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            height:
                // widget.isLoading
                //     ? MediaQuery.of(context).size.height -
                //         (Scaffold.of(context).appBarMaxHeight + 100)
                //     : MediaQuery.of(context).size.height -
                //         Scaffold.of(context).appBarMaxHeight,

                widget.isLoading
                    ? MediaQuery.of(context).size.height -
                        (Scaffold.of(context).appBarMaxHeight + 100)
                    : showLoadMore == true
                        ? MediaQuery.of(context).size.height -
                            Scaffold.of(context).appBarMaxHeight -
                            50
                        : MediaQuery.of(context).size.height -
                            Scaffold.of(context).appBarMaxHeight,
            child: GridView.count(
              childAspectRatio: 0.55,
              //   controller: _scrollController,
              crossAxisCount: 2,
//               staggeredTiles:
//                   List.generate(widget.productItemsData.length, (index) {
// //          if (index % 3 == 0) {
// //            return StaggeredTile.count(3, 1.5);
// //          } else {
//                 return StaggeredTile.count(1, 1.8);
//                 //  }
//               }),
              children: List.generate(widget.productItemsData.length, (index) {
//          if (index % 3 == 0) {
//            return ProductItem1(
//              index: index,
//              prodItemData: widget.productItemsData[index],
//              // imageName: 'assets/demoImages/AquaHor1.jpg',
//            );
//          }

                // if (index % 3 == 1) {
                return ProductItem2(
                  prodItemData: widget.productItemsData[index],
                  index: index,
                );
//          } else {
//            return ProductItem2(
//              index: index,
//              prodItemData: widget.productItemsData[index],
//            );
//          }
              }),
              // padding: const EdgeInsets.only(
              //   left: 2.0,
              //   right: 2.0,
              // ),
            ),
          ),
          showLoadMore == true
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.isLoading = true;
                        showLoadMore = false;
                      });
                      widget.productListBloc.add(ProductsFetch(
                          parameters: widget.searchParameters,
                          offset: widget.offsetValue,
                          filteredSize: filterSize));
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      color: Colors.blueAccent,
                      child: Center(
                        child: Text(
                          'Load more',
                          style:
                              TextStyle(color: Colors.white, letterSpacing: 4),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Center(
            child: widget.isLoading
                ? Container(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                      ],
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}
