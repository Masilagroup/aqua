// @dart=2.9
import 'package:aqua/WishList/bloc/wish_list_bloc.dart';
import 'package:aqua/WishList/bloc/wish_list_response.dart';
import 'package:aqua/WishList/wishlist_item.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class WishList extends StatefulWidget {
  final Function gotoCart;

  WishList({Key key, this.gotoCart}) : super(key: key);

  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  WishListBloc _wishListBloc;
  @override
  Widget build(BuildContext context) {
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
        title: Text(
          AppLocalizations.of(context).translate('wishList'),
          style: Theme.of(context).textTheme.headline1,
        ),
        // actions: <Widget>[
        //   CartIcon(counter: 3),
        // ],
      ),
      body: BlocProvider(
        create: (BuildContext context) {
          return WishListBloc()..add(WishProductsFetch());
        },
        child: BlocBuilder<WishListBloc, WishListState>(
          builder: (context, state) {
            if (state is WishListInitial) {
              return Center(child: AquaProgressIndicator());
            }
            if (state is WishListError) {
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
                        _wishListBloc..add(WishProductsFetch());
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
            }
            if (state is WishListLoaded) {
              return _wishList(
                state.wishListResponse,
              );
            }
            if (state is WishListDeleteState) {
              return _wishList(
                state.wishListResponse,
              );
            }
            return Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    _wishListBloc..add(WishProductsFetch());
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
      ),
    );
  }

  Widget _wishList(WishListResponse wishListResponse) {
    return Container(
      margin: AppLocalizations.of(context).locale.languageCode == 'en'
          ? EdgeInsets.only(left: 10, top: 10, right: 10)
          : EdgeInsets.only(right: 10, top: 10, left: 10),
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        childAspectRatio: 0.55,
        shrinkWrap: true,
        crossAxisCount: 2,
        // staggeredTiles: List.generate(wishListResponse.data.length, (index) {
        //   return StaggeredTile.count(1, 1.8);
        // }),
        children: List.generate(wishListResponse.data.length, (index) {
          return WishListItem(
            gotoCart: widget.gotoCart,
            prodItemData: wishListResponse.data[index],
            // imageName: 'assets/demoImages/AquaDemo1.jpg',
            count: index,
            //   prodItemData: ,
          );
        }),
      ),
    );
  }
}
