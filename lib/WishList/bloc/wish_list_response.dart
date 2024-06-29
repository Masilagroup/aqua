// @dart=2.9
import 'dart:convert';

import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';

class WishListResponse {
  WishListResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  List<ProdItemData> data;

  factory WishListResponse.fromJson(Map<String, dynamic> json) =>
      WishListResponse(
        status: json["status"],
        message: json["message"] ?? '',
        info: json["info"] ?? '',
        data: List<ProdItemData>.from(
            (json["data"] ?? []).map((x) => ProdItemData.fromJson(x))),
      );
}

class WishListAddDelete {
  WishListAddDelete({
    this.status,
    this.message,
    this.info,
    this.wishListData,
  });

  int status;
  String message;
  String info;
  WishListData wishListData;

  factory WishListAddDelete.fromRawJson(String str) =>
      WishListAddDelete.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishListAddDelete.fromJson(Map<String, dynamic> json) =>
      WishListAddDelete(
        status: json["status"],
        message: json["message"],
        info: json["info"],
        wishListData: WishListData.fromJson(json["data"] ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": wishListData.toJson(),
      };
}

class WishListData {
  WishListData({
    this.wishStatus,
  });

  int wishStatus;

  factory WishListData.fromRawJson(String str) =>
      WishListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory WishListData.fromJson(Map<String, dynamic> json) => WishListData(
        wishStatus: json["wish_status"],
      );

  Map<String, dynamic> toJson() => {
        "wish_status": wishStatus,
      };
}
