// @dart=2.9
import 'dart:convert';

import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';

class HomePageData {
  String message;
  String info;
  HomeData data;

  HomePageData({
    this.message,
    this.info,
    this.data,
  });

  HomePageData.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    data = HomeData.fromJson(json["data"] ?? {});
  }
}

class HomeData {
  List<Category> category;
  List<PageSlider> sliders;
  List<Banner> banner;
  List<ProdItemData> newCollection;
  List<ProdItemData> laurenCollection;
  List<ProdItemData> saleCollection;
  List<ProdItemData> girlCollection;
  List<Section> sections;

  String newCollectionTitle;
  String laurenCollectionTitle;

  String saleTitle;
  String girlTitle;
  Popup popup;

  HomeData(
      {this.category,
      this.sliders,
      this.banner,
      this.newCollection,
      this.newCollectionTitle,
      this.sections,
      this.laurenCollectionTitle,
      this.laurenCollection,
      this.saleTitle,
      this.saleCollection,
      this.girlTitle,
      this.girlCollection,
      this.popup});
  HomeData.fromJson(Map<String, dynamic> json) {
    category = List<Category>.from(
        (json["category"] ?? []).map((x) => Category.fromJson(x)));
    sliders = List<PageSlider>.from(
        (json["sliders"] ?? []).map((x) => PageSlider.fromJson(x)));
    banner = List<Banner>.from(
        (json["banner"] ?? []).map((x) => Banner.fromJson(x)));
    newCollection = List<ProdItemData>.from(
        (json["new_collection"] ?? []).map((x) => ProdItemData.fromJson(x)));
    sections = List<Section>.from(
        (json["sections"] ?? []).map((x) => Section.fromJson(x)));

    newCollectionTitle = json['new_collection_title'] ?? '';
    laurenCollectionTitle = json['lauren_title'] ?? '';
    saleTitle = json['special_offer_title'] ?? '';

    laurenCollection = List<ProdItemData>.from(
        (json["lauren_items"] ?? []).map((x) => ProdItemData.fromJson(x)));
    saleCollection = List<ProdItemData>.from((json["special_offer_items"] ?? [])
        .map((x) => ProdItemData.fromJson(x)));

    girlTitle = json['girl_item_title'] ?? '';
    girlCollection = List<ProdItemData>.from(
        (json["girls_items"] ?? []).map((x) => ProdItemData.fromJson(x)));
    popup = Popup.fromJson(json["popup"]);
  }
}

class Popup {
  Popup({
    this.image,
    this.content,
  });

  String image;
  String content;

  factory Popup.fromJson(Map<String, dynamic> json) => Popup(
        image: json["image"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "image": image,
        "content": content,
      };
}

class Category {
  int id;
  String name;
  List<Subcat> subcat;
  String image;
  String buttonUrl;

  Category({this.id, this.name, this.image, this.subcat, this.buttonUrl});

  Category.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? '';
    image = json['image'] ?? '';
    subcat = List<Subcat>.from(
        (json["subcat"] ?? []).map((x) => Subcat.fromJson(x)));
    buttonUrl = json['button_url'] ?? '';
  }
}

class Subcat {
  int id;
  String name;
  int pid;
  String imageMedium;
  String imageThumb;

  Subcat({
    this.id,
    this.name,
    this.pid,
    this.imageMedium,
    this.imageThumb,
  });

  Subcat.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    name = json["name"] ?? '';
    pid = json["pid"] ?? 0;
    imageMedium = json["image_medium"] ?? '';
    imageThumb = json["image_thumb"] ?? '';
  }
}

class PageSlider {
  int id;
  String type;
  String title;
  String subTitle;
  String buttonText;
  String buttonUrl;
  String image;

  PageSlider({
    this.id,
    this.type,
    this.title,
    this.subTitle,
    this.buttonText,
    this.buttonUrl,
    this.image,
  });

  PageSlider.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    type = json["type"] ?? '';
    title = json["title"] ?? '';
    subTitle = json["sub_title"] ?? '';
    buttonText = json["button_text"] ?? '';
    buttonUrl = json["button_url"] ?? '';
    image = json["image"] ?? '';
  }
}

class Banner {
  Banner({
    this.title,
    this.image,
  });

  String title;
  String image;

  factory Banner.fromJson(Map<String, dynamic> json) => Banner(
        title: json["title"] ?? '',
        image: json["image"] ?? '',
      );
}

class Section {
  Section({
    this.title,
    this.type,
    this.buttonUrl,
  });

  String title;
  String type;
  String buttonUrl;

  factory Section.fromRawJson(String str) => Section.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        title: json["title"] ?? '',
        type: json["type"] ?? '',
        buttonUrl: json["button_url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "button_url": buttonUrl,
      };
}
