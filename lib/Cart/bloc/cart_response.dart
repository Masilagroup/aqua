// @dart=2.9
import 'dart:convert';

import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';

class CartListResponse {
  CartListResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  CartData data;

  factory CartListResponse.fromRawJson(String str) =>
      CartListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartListResponse.fromJson(Map<String, dynamic> json) =>
      CartListResponse(
        status: json["status"],
        message: json["message"] ?? '',
        info: json["info"] ?? '',
        data: CartData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class CartData {
  CartData({
    this.sessionId,
    this.cartItems,
    this.cartTotalQuantity,
    this.cartSubTotal,
    this.cartDiscount,
    this.cartShippingPrice,
    this.cartTotal,
    this.cartProductId,
  });

  String sessionId;
  List<CartItemData> cartItems;
  int cartTotalQuantity;
  String cartSubTotal;
  String cartDiscount;
  String cartShippingPrice;
  String cartTotal;
  int cartProductId;

  factory CartData.fromRawJson(String str) =>
      CartData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        sessionId: json["session_id"] ?? '',
        cartItems: List<CartItemData>.from(
            (json["cart_items"] ?? []).map((x) => CartItemData.fromJson(x))),
        cartTotalQuantity: json["cart_total_quantity"] ?? 0,
        cartSubTotal: json["cart_sub_total"] ?? '',
        cartDiscount: json["cart_discount"] ?? '',
        cartShippingPrice: json["cart_shipping_price"] ?? '',
        cartTotal: json["cart_total"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "cart_items": List<CartItemData>.from(cartItems.map((x) => x.toJson())),
        "cart_total_quantity": cartTotalQuantity,
        "cart_sub_total": cartSubTotal,
        "cart_discount": cartDiscount,
        "cart_shipping_price": cartShippingPrice,
        "cart_total": cartTotal,
      };
}

class CartItemData {
  CartItemData({
    this.cartId,
    this.cartImage,
    this.cartSku,
    this.cartModel,
    this.cartTitle,
    this.cartPrice,
    this.cartQuantity,
    this.cartProductTotalPrice,
    this.size,
    this.color,
    this.cartProductId,
  });

  int cartId;
  String cartImage;
  String cartSku;
  String cartModel;
  String cartTitle;
  String cartPrice;
  int cartQuantity;
  String cartProductTotalPrice;
  int cartProductId;
  Sizes size;
  Color color;

  factory CartItemData.fromRawJson(String str) =>
      CartItemData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartItemData.fromJson(Map<String, dynamic> json) => CartItemData(
        cartId: json["cart_id"] ?? 0,
        cartImage: json["cart_image"] ?? '',
        cartSku: json["cart_sku"] ?? '',
        cartModel: json["cart_model"] ?? '',
        cartTitle: json["cart_title"] ?? '',
        cartPrice: json["cart_price"] ?? '',
        cartQuantity: json["cart_quantity"] ?? '',
        cartProductTotalPrice: json["cart_product_total_price"] ?? '',
        size: Sizes.fromJson(json["cart_product_size"] ?? {}) ?? {},
        color: Color.fromJson(json["cart_product_color"] ?? {}) ?? {},
        cartProductId: json['cart_product_id'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "cart_id": cartId,
        "cart_image": cartImage,
        "cart_sku": cartSku,
        "cart_model": cartModel,
        "cart_title": cartTitle,
        "cart_price": cartPrice,
        "cart_quantity": cartQuantity,
        "cart_product_total_price": cartProductTotalPrice,
        "cart_product_size": size,
        "cart_product_color": color
      };
}

class CouponResponse {
  CouponResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  CouponData data;

  factory CouponResponse.fromRawJson(String str) =>
      CouponResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CouponResponse.fromJson(Map<String, dynamic> json) => CouponResponse(
        status: json["status"],
        message: json["message"] ?? '',
        info: json["info"] ?? '',
        data: CouponData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class CouponData {
  CouponData({
    this.sessionId,
    this.cartTotalQuantity,
    this.cartSubTotal,
    this.cartDiscount,
    this.cartCouponCode,
    this.cartCouponId,
    this.cartShippingPrice,
    this.cartTotal,
  });

  String sessionId;
  int cartTotalQuantity;
  String cartSubTotal;
  String cartDiscount;
  String cartCouponCode;
  String cartCouponId;
  String cartShippingPrice;
  String cartTotal;

  factory CouponData.fromRawJson(String str) =>
      CouponData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CouponData.fromJson(Map<String, dynamic> json) => CouponData(
        sessionId: json["session_id"],
        cartTotalQuantity: json["cart_total_quantity"],
        cartSubTotal: json["cart_sub_total"],
        cartDiscount: json["cart_discount"],
        cartCouponCode: json["cart_coupon_code"],
        cartCouponId: json["cart_coupon_id"],
        cartShippingPrice: json["cart_shipping_price"],
        cartTotal: json["cart_total"],
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "cart_total_quantity": cartTotalQuantity,
        "cart_sub_total": cartSubTotal,
        "cart_discount": cartDiscount,
        "cart_coupon_code": cartCouponCode,
        "cart_coupon_id": cartCouponId,
        "cart_shipping_price": cartShippingPrice,
        "cart_total": cartTotal,
      };
}
