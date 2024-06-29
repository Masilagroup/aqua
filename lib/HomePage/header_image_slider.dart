// @dart=2.9
import 'package:aqua/HomePage/bloc/homepage_response.dart';
import 'package:aqua/ProductItem/ProductList/product_list.dart';
import 'package:aqua/utils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HeaderSlider extends StatefulWidget {
  // final List<Img> mediaImg;
  // final List<String> mediaImg;
  final List<PageSlider> sliders;
  final Function gotoCart;

  HeaderSlider({Key key, this.sliders, this.gotoCart}) : super(key: key);

  @override
  _HeaderSliderState createState() => _HeaderSliderState();
}

class _HeaderSliderState extends State<HeaderSlider> {
  @override
  Widget build(BuildContext context) {
    //  List<String> keys = widget.imageUrl.keys.toList();
    return CarouselSlider(
      // viewportFraction: 1.0,
      // aspectRatio: 16 / 16,
      // autoPlay: true,
      // enlargeCenterPage: true,
      options: CarouselOptions(
        aspectRatio: 16 / 16,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),

      items: widget.sliders.map(
        (singleSlider) {
          return InkWell(
            onTap: () {
              Map<String, dynamic> parameters = new Map<String, dynamic>();
              if (singleSlider.type == 'general') {
                parameters[singleSlider.buttonUrl] = 1;
              } else {
                parameters['cat_id'] = singleSlider.buttonUrl;
              }
              parameters['currency'] = Constants.selectedCurrency;
              Constants.sortString = '';
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductsList(
                          searchParameters: parameters,
                          title: singleSlider.type == 'general'
                              ? singleSlider.title
                              : singleSlider.title,
                        ),
                    fullscreenDialog: true),
              ).then((value) => {
                    if (value != null)
                      {
                        if (value == true) {widget.gotoCart(3)}
                      }
                  });
            },
            child: Stack(
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: singleSlider.image ??
                      "https://www.aquafashion.com/assets/images/icon/aqua_logo_new_ar.png",
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
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(bottom: 30, right: 10),
                  child: Text(
                    // 'Welcome to AquaFashion',
                    singleSlider.title,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 30, right: 10),
                  child: Text(
                    // 'WOMEN FASHION',
                    singleSlider.subTitle,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
