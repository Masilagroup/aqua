// @dart=2.9
import 'package:aqua/HomePage/homepage_product_slider_item.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomePageBottomSlider extends StatefulWidget {
  // final List<Img> mediaImg;
  // final List<String> mediaImg;
  final bool isFromHome;
  final List<ProdItemData> sliders;
  final Function gotoCart;

  HomePageBottomSlider({Key key, this.sliders, this.isFromHome, this.gotoCart})
      : super(key: key);

  @override
  _HomePageBottomSliderState createState() => _HomePageBottomSliderState();
}

class _HomePageBottomSliderState extends State<HomePageBottomSlider> {
  List<List<ProdItemData>> newsliders = List<List<ProdItemData>>();
  @override
  void initState() {
    super.initState();
    _changeToSliderData();
  }

  _changeToSliderData() {
    if (widget.sliders.length == 1) {
      newsliders.add([widget.sliders[0], null]);
    } else if (widget.sliders.length == 2) {
      newsliders.add([widget.sliders[0], widget.sliders[1]]);
    } else if (widget.sliders.length == 3) {
      newsliders.add([widget.sliders[0], widget.sliders[1]]);
      newsliders.add([widget.sliders[2], null]);
    } else if (widget.sliders.length == 4) {
      newsliders.add([widget.sliders[0], widget.sliders[1]]);
      newsliders.add([widget.sliders[2], widget.sliders[3]]);
    } else if (widget.sliders.length == 5) {
      newsliders.add([widget.sliders[0], widget.sliders[1]]);
      newsliders.add([widget.sliders[2], widget.sliders[3]]);
      newsliders.add([widget.sliders[4], null]);
    } else if (widget.sliders.length > 5) {
      newsliders.add([widget.sliders[0], widget.sliders[1]]);
      newsliders.add([widget.sliders[2], widget.sliders[3]]);
      newsliders.add([widget.sliders[4], widget.sliders[5]]);
    }
  }

  @override
  Widget build(BuildContext context) {
    //  List<String> keys = widget.imageUrl.keys.toList();
    return Container(
      height: 60,
      child: CarouselSlider(
        // viewportFraction: 1.0,
        // aspectRatio: 16 / 16,
        // autoPlay: true,
        // enlargeCenterPage: true,
        options: CarouselOptions(
          autoPlay: true,
          aspectRatio: 1.0,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
        ),
        items: newsliders.map(
          (singleSlider) {
            return HomeProductScrollItem(
              productItemData1: singleSlider[0],
              productItemData2: singleSlider[1],
              isFromHome: widget.isFromHome,
              gotoCart: widget.gotoCart,
            );
          },
        ).toList(),
      ),
    );
  }
}
