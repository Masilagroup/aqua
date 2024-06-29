// @dart=2.9
import 'dart:convert';

import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';

class OrdersListResponse {
  OrdersListResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  List<OrderListData> data;

  factory OrdersListResponse.fromRawJson(String str) =>
      OrdersListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrdersListResponse.fromJson(Map<String, dynamic> json) =>
      OrdersListResponse(
        status: json["status"],
        message: json["message"],
        info: json["info"],
        data: List<OrderListData>.from(
            (json["data"] ?? []).map((x) => OrderListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": List<OrderListData>.from(data.map((x) => x.toJson())),
      };
}

class OrderListData {
  OrderListData({
    this.id,
    this.refId,
    this.invoiceNo,
    this.canCancel,
    this.canReturn,
    this.isCancel,
    this.isReturn,
    this.paymentStatusTxt,
    this.paymentStatus,
    this.orderStatus,
    this.orderStatusTxt,
    this.orderItems,
    this.transactionDetails,
    this.orderTotalQuantity,
    this.orderSubTotal,
    this.orderDiscount,
    this.orderShippingPrice,
    this.orderTotal,
    this.shippingDetails,
    this.orderDate,
  });

  int id;
  int refId;
  int invoiceNo;
  int canCancel;
  int canReturn;
  int isCancel;
  int isReturn;
  String paymentStatusTxt;
  int paymentStatus;
  String orderStatus;
  String orderStatusTxt;
  List<OrderItem> orderItems;
  TransactionDetails transactionDetails;
  ShippingDetails shippingDetails;
  int orderTotalQuantity;
  String orderSubTotal;
  String orderDiscount;
  String orderShippingPrice;
  String orderTotal;
  String orderDate;

  factory OrderListData.fromRawJson(String str) =>
      OrderListData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderListData.fromJson(Map<String, dynamic> json) => OrderListData(
        id: json['id'] ?? 0,
        refId: json["ref_id"] ?? 0,
        invoiceNo: json["invoice_no"] ?? 0,
        isCancel: json["is_cancel"] ?? 0,
        isReturn: json["is_return"] ?? 0,
        paymentStatusTxt: json["payment_status_txt"] ?? 0,
        paymentStatus: json["payment_status"] ?? 0,
        orderStatus: json["order_status"] ?? '',
        orderStatusTxt: json["order_status_txt"] ?? '',
        orderItems: List<OrderItem>.from(
            (json["order_items"] ?? []).map((x) => OrderItem.fromJson(x))),
        transactionDetails:
            TransactionDetails.fromJson(json["transaction_details"] ?? {}),
        shippingDetails:
            ShippingDetails.fromJson(json['shipping_details'] ?? {}),
        orderTotalQuantity: json["order_total_quantity"] ?? 0,
        orderSubTotal: json["order_sub_total"] ?? '',
        orderDiscount: json["order_discount"] ?? '',
        orderShippingPrice: json["order_shipping_price"] ?? '',
        orderTotal: json["order_total"] ?? '',
        canCancel: json['can_cancel'] ?? 0,
        canReturn: json['can_return'] ?? 0,
        orderDate: json['order_date'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ref_id": refId,
        "invoice_no": invoiceNo,
        "payment_status_txt": paymentStatusTxt,
        "payment_status": paymentStatus,
        "order_status": orderStatus,
        "order_status_txt": orderStatusTxt,
        "order_items": List<OrderItem>.from(orderItems.map((x) => x.toJson())),
        "transaction_details": transactionDetails.toJson(),
        "order_total_quantity": orderTotalQuantity,
        "order_sub_total": orderSubTotal,
        "order_discount": orderDiscount,
        "order_shipping_price": orderShippingPrice,
        "order_total": orderTotal,
        "can_cancel": canCancel,
        "can_return": canReturn,
        "order_date": orderDate,
      };
}

class OrderItem {
  OrderItem({
    this.productId,
    this.productItemId,
    this.productSku,
    this.productModel,
    this.productCategoryId,
    this.productCategoryName,
    this.productSubCategoryId,
    this.productSubCategoryName,
    this.productTitle,
    this.productDescription,
    this.productProductSize,
    this.productProductColor,
    this.productPrice,
    this.productQuantity,
    this.productTotalPrice,
    this.productIsCancel,
    this.productisReturn,
    this.productisReturnRequest,
    this.productImage,
  });

  int productId;
  int productItemId;
  String productSku;
  String productModel;
  String productCategoryId;
  String productCategoryName;
  String productSubCategoryId;
  String productSubCategoryName;
  String productTitle;
  String productDescription;
  ProductProductSize productProductSize;
  ProductProductColor productProductColor;
  String productPrice;
  int productQuantity;
  String productTotalPrice;
  int productIsCancel;
  int productisReturn;
  int productisReturnRequest;
  String productImage;

  factory OrderItem.fromRawJson(String str) =>
      OrderItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json["product_id"] ?? 0,
        productItemId: json["product_item_id"] ?? 0,
        productSku: json["product_sku"] ?? '',
        productModel: json["product_model"] ?? '',
        productCategoryId: json["product_category_id"] ?? '',
        productCategoryName: json["product_category_name"] ?? '',
        productSubCategoryId: json["product_sub_category_id"] ?? '',
        productSubCategoryName: json["product_sub_category_name"] ?? '',
        productTitle: json["product_title"] ?? '',
        productDescription: json["product_description"] ?? '',
        productProductSize:
            ProductProductSize.fromJson(json["product_product_size"] ?? {}),
        productProductColor:
            ProductProductColor.fromJson(json["product_product_color"] ?? {}),
        productPrice: json["product_price"] ?? '',
        productQuantity: json["product_quantity"] ?? 0,
        productTotalPrice: json["product_total_price"] ?? '',
        productIsCancel: json["product_is_cancel"] ?? 0,
        productisReturn: json["product_is_return"] ?? 0,
        productisReturnRequest: json["product_return_request"] ?? 0,
        productImage: json['product_image'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "product_sku": productSku,
        "product_model": productModel,
        "product_category_id": productCategoryId,
        "product_category_name": productCategoryName,
        "product_sub_category_id": productSubCategoryId,
        "product_sub_category_name": productSubCategoryName,
        "product_title": productTitle,
        "product_description": productDescription,
        "product_product_size": productProductSize.toJson(),
        "product_product_color": productProductColor.toJson(),
        "product_price": productPrice,
        "product_quantity": productQuantity,
        "product_total_price": productTotalPrice,
        "product_image": productImage,
      };
}

class ProductProductColor {
  ProductProductColor({
    this.colorId,
    this.colorName,
    this.colorCode,
  });

  String colorId;
  String colorName;
  String colorCode;

  factory ProductProductColor.fromRawJson(String str) =>
      ProductProductColor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductProductColor.fromJson(Map<String, dynamic> json) =>
      ProductProductColor(
        colorId: json["color_id"] ?? '',
        colorName: json["color_name"] ?? '',
        colorCode: json["color_code"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "color_id": colorId,
        "color_name": colorName,
        "color_code": colorCode,
      };
}

class ProductProductSize {
  ProductProductSize({
    this.sizeId,
    this.sizeName,
  });

  String sizeId;
  String sizeName;

  factory ProductProductSize.fromRawJson(String str) =>
      ProductProductSize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductProductSize.fromJson(Map<String, dynamic> json) =>
      ProductProductSize(
        sizeId: json["size_id"] ?? '',
        sizeName: json["size_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "size_id": sizeId,
        "size_name": sizeName,
      };
}

class TransactionDetails {
  TransactionDetails({
    this.referenceId,
    this.trackId,
    this.transactionId,
    this.paymentId,
    this.authorizationId,
    this.invoiceValue,
    this.transactionDate,
    this.transactionStatus,
    this.result,
  });

  String referenceId;
  String trackId;
  String transactionId;
  String paymentId;
  String authorizationId;
  String invoiceValue;
  String transactionDate;
  String transactionStatus;
  String result;

  factory TransactionDetails.fromRawJson(String str) =>
      TransactionDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      TransactionDetails(
        referenceId: json["ReferenceId"] ?? '',
        trackId: json["TrackId"] ?? '',
        transactionId: json["TransactionId"] ?? '',
        paymentId: json["PaymentId"] ?? '',
        authorizationId: json["AuthorizationId"] ?? '',
        invoiceValue: json["InvoiceValue"] ?? '',
        transactionDate: json["TransactionDate"] ?? '',
        transactionStatus: json["TransactionStatus"] ?? '',
        result: json["result"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "ReferenceId": referenceId,
        "TrackId": trackId,
        "TransactionId": transactionId,
        "PaymentId": paymentId,
        "AuthorizationId": authorizationId,
        "InvoiceValue": invoiceValue,
        "TransactionDate": transactionDate,
        "TransactionStatus": transactionStatus,
        "result": result,
      };
}

class ShippingDetails {
  ShippingDetails({
    this.shippingName,
    this.shippingEmail,
    this.shippingMobile,
    this.shippingCountry,
    this.shippingArea,
    this.shippingStreet,
    this.shippingFloor,
    this.shippingBlock,
    this.shippingCountryName,
  });

  String shippingName;
  String shippingEmail;
  String shippingMobile;
  String shippingCountry;
  String shippingArea;
  String shippingStreet;
  String shippingFloor;
  String shippingBlock;
  String shippingCountryName;

  factory ShippingDetails.fromRawJson(String str) =>
      ShippingDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ShippingDetails.fromJson(Map<String, dynamic> json) =>
      ShippingDetails(
        shippingName: json["shipping_name"] ?? '',
        shippingEmail: json["shipping_email"] ?? '',
        shippingMobile: json["shipping_mobile"] ?? '',
        shippingCountry: json["shipping_country"] ?? '',
        shippingArea: json["shipping_area"] ?? '',
        shippingStreet: json["shipping_street"] ?? '',
        shippingFloor: json["shipping_floor"] ?? '',
        shippingBlock: json["shipping_block"] ?? '',
        shippingCountryName: json["shipping_country_name"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "shipping_name": shippingName,
        "shipping_email": shippingEmail,
        "shipping_mobile": shippingMobile,
        "shipping_country": shippingCountry,
        "shipping_area": shippingArea,
        "shipping_street": shippingStreet,
        "shipping_floor": shippingFloor,
        "shipping_block": shippingBlock,
        "shipping_country_name": shippingCountryName,
      };
}

class OrderCancelResponse {
  OrderCancelResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  OrderCancelData data;

  factory OrderCancelResponse.fromRawJson(String str) =>
      OrderCancelResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCancelResponse.fromJson(Map<String, dynamic> json) =>
      OrderCancelResponse(
        status: json["status"] ?? 0,
        message: json["message"] ?? '',
        info: json["info"] ?? '',
        data: OrderCancelData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class OrderCancelData {
  OrderCancelData({
    this.cancelInvoiceNo,
    this.orders,
  });

  int cancelInvoiceNo;
  List<OrderListData> orders;

  factory OrderCancelData.fromRawJson(String str) =>
      OrderCancelData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderCancelData.fromJson(Map<String, dynamic> json) =>
      OrderCancelData(
        cancelInvoiceNo: json["cancel_invoice_no"] ?? '',
        orders: List<OrderListData>.from(
            (json["orders"] ?? []).map((x) => OrderListData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cancel_invoice_no": cancelInvoiceNo,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
      };
}
