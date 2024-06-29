// @dart=2.9
import 'package:aqua/Account/SelectCurrency/bloc/currency_bloc.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
import 'package:aqua/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBottomBanner extends StatelessWidget {
  final String bottomBannerImage;
  final String title;
  final Function gotoCart;
  const HomeBottomBanner(
      {Key key, this.bottomBannerImage, this.title, this.gotoCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrencyBloc, CurrencyState>(
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            InkWell(
              onTap: () {
                int currencyId = 114;
                if (state is CurrencyRetriveState) {
                  print(state.currencyData.currencyName);
                  currencyId = state.currencyData.currencyId;
                }
                Map<String, dynamic> parameters = new Map<String, dynamic>();
                parameters['currency'] = currencyId;
                parameters['is_vidal'] = 1;
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
              child: Image.network(
                '$bottomBannerImage',
                fit: BoxFit.fill,
                width: 1000.0,
                height: 1000.0,
              ),
            ),
            // Container(
            //   alignment: Alignment.center,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: <Widget>[
            //       Container(
            //         margin: const EdgeInsets.only(bottom: 20),
            //         height: 40,
            //         child: RaisedButton(
            //           onPressed: () {
            //             int currencyId = 114;
            //             if (state is CurrencyRetriveState) {
            //               print(state.currencyData.currencyName);
            //               currencyId = state.currencyData.currencyId;
            //             }
            //             Map<String, dynamic> parameters =
            //                 new Map<String, dynamic>();
            //             parameters['currency'] = currencyId;
            //             parameters['cat_id'] = Constants.catWOMEN;
            //             parameters['lang'] = 'en';
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ProductsList(
            //                         searchParameters: parameters,
            //                         title: 'WOMEN',
            //                       ),
            //                   fullscreenDialog: true),
            //             );
            //           },
            //           color: Colors.transparent.withOpacity(0.4),
            //           child: Text(
            //             'WOMEN',
            //             style: Theme.of(context).textTheme.display4,
            //           ),
            //           shape: new RoundedRectangleBorder(
            //             //   borderRadius: BorderRadius.circular(10),
            //             side: BorderSide(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //       Container(
            //         height: 40,
            //         margin: const EdgeInsets.only(bottom: 20, left: 20),
            //         child: RaisedButton(
            //           onPressed: () {
            //             Map<String, dynamic> parameters =
            //                 new Map<String, dynamic>();
            //             parameters['cat_id'] = Constants.catGIRLS;
            //             parameters['lang'] = 'en';
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => ProductsList(
            //                         searchParameters: parameters,
            //                         //    categoryID: Constants.catGIRLS,
            //                         title: 'GIRLS',
            //                       ),
            //                   fullscreenDialog: true),
            //             );
            //           },
            //           color: Colors.transparent.withOpacity(0.4),
            //           child: Text(
            //             'GIRLS',
            //             style: Theme.of(context).textTheme.display4,
            //           ),
            //           shape: new RoundedRectangleBorder(
            //             //  borderRadius: BorderRadius.circular(20),
            //             side: BorderSide(
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
