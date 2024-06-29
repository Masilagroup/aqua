// @dart=2.9
class ProductItemResponse {
  int status;
  String message;
  String info;
  List<ProdItemData> productItemData;
  List<FilterSize> filterSizes;

  ProductItemResponse({
    this.status,
    this.message,
    this.info,
    this.productItemData,
    this.filterSizes,
  });

  ProductItemResponse.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    productItemData = json["data"] != null
        ? List<ProdItemData>.from(
            (json["data"] ?? []).map((x) => ProdItemData.fromJson(x)))
        : [];
    filterSizes = json["filter_sizes"] != null
        ? List<FilterSize>.from(
            (json["filter_sizes"] ?? []).map((x) => FilterSize.fromJson(x)))
        : [];
  }
}

class FilterSize {
  FilterSize({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory FilterSize.fromJson(Map<String, dynamic> json) => FilterSize(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class ProdItemData {
  int productId;
  String productSku;
  String productModel;
  String productCategoryId;
  String productCategoryName;
  String productSubCategoryId;
  String productSubCategoryName;
  String productTitle;
  String productDescription;
  String productPrice;
  String productOfferPrice;
  int productIsOffer;
  int productIsFav;
  int productOutofStock;
  int productQuantity;
  List<Gallery> gallery;
  List<Sizes> sizes;
  List<Color> colors;
  List<ProdItemData> bundles;
  String sizeChart;
  String sizeChartDescription;

  ProdItemData({
    this.productId,
    this.productSku,
    this.productModel,
    this.productCategoryId,
    this.productCategoryName,
    this.productSubCategoryId,
    this.productSubCategoryName,
    this.productTitle,
    this.productDescription,
    this.productPrice,
    this.productOfferPrice,
    this.productIsOffer,
    this.gallery,
    this.sizes,
    this.colors,
    this.bundles,
    this.productIsFav,
    this.productOutofStock,
    this.productQuantity,
    this.sizeChart,
    this.sizeChartDescription,
  });

  ProdItemData.fromJson(Map<String, dynamic> json) {
    productId = json["product_id"] ?? 0;
    productSku = json["product_sku"] ?? '';
    productModel = json["product_model"] ?? '';
    productCategoryId = json["product_category_id"] ?? '';
    productCategoryName = json["product_category_name"] ?? '';
    productSubCategoryId = json["product_sub_category_id"] ?? '';
    productSubCategoryName = json["product_sub_category_name"] ?? '';
    productTitle = json["product_title"] ?? '';
    productDescription = json["product_description"] ?? '';
    productPrice = json["product_price"] ?? '';
    productOfferPrice = json["product_offer_price"] ?? '';
    productIsOffer = json["product_is_offer"] ?? 0;
    productIsFav = json['product_is_fav'] ?? 0;
    productOutofStock = json['product_out_of_stock'] ?? 0;
    productQuantity = json['product_quantity'] ?? 0;

    gallery = List<Gallery>.from(
            json["gallery"].map((x) => Gallery.fromJson(x) ?? {})) ??
        [];
    sizes = List<Sizes>.from(json["sizes"].map((x) => Sizes.fromJson(x) ?? {}));
    colors =
        List<Color>.from(json["colors"].map((x) => Color.fromJson(x) ?? {}));
    bundles = json["bundles"] != null
        ? List<ProdItemData>.from(
            json["bundles"].map((x) => ProdItemData.fromJson(x) ?? {}))
        : [];
    sizeChart = json['size_chart'] ?? "";
    sizeChartDescription = json['size_chart_desc'] ?? "";
  }
}

class Color {
  String colorId;
  String colorName;
  String colorCode;

  Color({
    this.colorId,
    this.colorName,
    this.colorCode,
  });

  Color.fromJson(Map<String, dynamic> json) {
    colorId = json["color_id"] ?? '';
    colorName = json["color_name"] ?? '';
    colorCode = json["color_code"] ?? '';
  }
}

class Gallery {
  int id;
  String image;
  String imageUrl;
  String imageMediumUrl;
  String imageThumbUrl;

  Gallery({
    this.id,
    this.image,
    this.imageUrl,
    this.imageMediumUrl,
    this.imageThumbUrl,
  });

  Gallery.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    image = json["image"] ?? '';
    imageUrl = json["image_url"] ?? '';
    imageMediumUrl = json["image_medium_url"] ?? '';
    imageThumbUrl = json["image_thumb_url"] ?? '';
  }
}

class Sizes {
  String sizeId;
  String sizeName;

  Sizes({
    this.sizeId,
    this.sizeName,
  });

  Sizes.fromJson(Map<String, dynamic> json) {
    sizeId = json["size_id"] ?? '';
    sizeName = json["size_name"] ?? '';
  }
}

enum ProductCategoryName { GIRLS, LADIES }

final productCategoryNameValues = EnumValues({
  "Girls": ProductCategoryName.GIRLS,
  "Ladies": ProductCategoryName.LADIES,
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
