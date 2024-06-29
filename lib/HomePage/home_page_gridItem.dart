// @dart=2.9
import 'package:aqua/Account/SelectCurrency/bloc/currency_bloc.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
import 'package:aqua/translation/app_localizations.dart';
import 'package:aqua/utils/app_colors.dart';
import 'package:aqua/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageGridItem extends StatelessWidget {
  final Function gotoCart;

  final String imageName;
  final int catId;
  final int subCatId;
  final String title;
  final bool position;
  final Map<String, dynamic> parameters;
  String optionalParams;
  HomePageGridItem({
    Key key,
    this.imageName,
    this.catId,
    this.title,
    this.position,
    this.subCatId,
    this.parameters,
    this.optionalParams,
    this.gotoCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            int currencyId = 114;
            if (state is CurrencyRetriveState) {
              print(state.currencyData.currencyName);
              currencyId = state.currencyData.currencyId;
            }
            Map<String, dynamic> parameters = new Map<String, dynamic>();
            parameters['currency'] = currencyId;
            parameters['cat_id'] = catId;
            parameters['sub_cat_id'] = subCatId;
            if (optionalParams != '') {
              var x = optionalParams.split("=");
              parameters[x.first] = x.last;
              parameters.remove('cat_id');
              parameters.remove('sub_cat_id');
            }
            Constants.sortString = '';
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductsList(
                        searchParameters: parameters,
                        title: title,
                      ),
                  fullscreenDialog: true),
            ).then((value) => {
                  if (value != null)
                    {
                      if (value == true) {gotoCart(3)}
                    }
                });
          },
          child: Stack(
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: imageName,
                imageBuilder: (context, imageProvider) => Container(
                  width: 1000.0,
                  height: 1000.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Container(),
              ),

              // Positioned(
              //   bottom: 40,
              //   left: position ? 20 : null,
              //   right: position ? null : 20,

              Container(
                //    height: 25,
                padding: const EdgeInsets.fromLTRB(15, 2.5, 15, 2.5),
                //    color: Colors.transparent.withOpacity(0.7),
                alignment:
                    position ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                      color: AppColors.BLACK_COLOR,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500,
                      fontFamily:
                          AppLocalizations.of(context).locale.countryCode ==
                                  'en'
                              ? 'Montserrat'
                              : 'Almarai',
                      fontStyle: FontStyle.normal),
                ),
              ),
              //   ),
            ],
          ),
        );
      },
    );
  }
}
