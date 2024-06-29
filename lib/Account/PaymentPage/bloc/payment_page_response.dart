// @dart=2.9
import 'dart:convert';

class PaymentCheckStatusResponse {
  PaymentCheckStatusResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  PaymentCheckData data;

  factory PaymentCheckStatusResponse.fromRawJson(String str) =>
      PaymentCheckStatusResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentCheckStatusResponse.fromJson(Map<String, dynamic> json) =>
      PaymentCheckStatusResponse(
        status: json["status"],
        message: json["message"] ?? '',
        info: json["info"] ?? '',
        data: PaymentCheckData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class PaymentCheckData {
  PaymentCheckData(
      {this.sessionId,
      this.cartItems,
      this.cartTotalQuantity,
      this.cartSubTotal,
      this.cartDiscount,
      this.cartCouponCode,
      this.cartCouponId,
      this.cartShippingPrice,
      this.cartTotal,
      this.notes});

  String sessionId;
  List<PaymentcheckCartItem> cartItems;
  int cartTotalQuantity;
  String cartSubTotal;
  String cartDiscount;
  String cartCouponCode;
  String cartCouponId;
  String cartShippingPrice;
  String cartTotal;
  String notes;

  factory PaymentCheckData.fromRawJson(String str) =>
      PaymentCheckData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentCheckData.fromJson(Map<String, dynamic> json) =>
      PaymentCheckData(
          sessionId: json["session_id"] ?? '',
          cartItems: List<PaymentcheckCartItem>.from((json["cart_items"] ?? [])
              .map((x) => PaymentcheckCartItem.fromJson(x))),
          cartTotalQuantity: json["cart_total_quantity"] ?? 0,
          cartSubTotal: json["cart_sub_total"] ?? '',
          cartDiscount: json["cart_discount"] ?? '',
          cartCouponCode: json["cart_coupon_code"] ?? '',
          cartCouponId: json["cart_coupon_id"] ?? '',
          cartShippingPrice: json["cart_shipping_price"] ?? '',
          cartTotal: json["cart_total"] ?? '',
          notes: json["notes"] ?? '');

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "cart_items": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "cart_total_quantity": cartTotalQuantity,
        "cart_sub_total": cartSubTotal,
        "cart_discount": cartDiscount,
        "cart_coupon_code": cartCouponCode,
        "cart_coupon_id": cartCouponId,
        "cart_shipping_price": cartShippingPrice,
        "cart_total": cartTotal,
        "notes": notes
      };
}

class PaymentcheckCartItem {
  PaymentcheckCartItem({
    this.cartId,
    this.cartImage,
    this.cartSku,
    this.cartModel,
    this.cartTitle,
    this.cartPrice,
    this.cartQuantity,
    this.cartProductTotalPrice,
  });

  int cartId;
  String cartImage;
  String cartSku;
  String cartModel;
  String cartTitle;
  String cartPrice;
  int cartQuantity;
  String cartProductTotalPrice;

  factory PaymentcheckCartItem.fromRawJson(String str) =>
      PaymentcheckCartItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentcheckCartItem.fromJson(Map<String, dynamic> json) =>
      PaymentcheckCartItem(
        cartId: json["cart_id"] ?? 0,
        cartImage: json["cart_image"] ?? '',
        cartSku: json["cart_sku"] ?? '',
        cartModel: json["cart_model"] ?? '',
        cartTitle: json["cart_title"] ?? '',
        cartPrice: json["cart_price"] ?? '',
        cartQuantity: json["cart_quantity"] ?? 0,
        cartProductTotalPrice: json["cart_product_total_price"] ?? '',
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
      };
}

class OrderConfirmResponse {
  OrderConfirmResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  OrderConfirmData data;

  factory OrderConfirmResponse.fromRawJson(String str) =>
      OrderConfirmResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderConfirmResponse.fromJson(Map<String, dynamic> json) =>
      OrderConfirmResponse(
        status: json["status"],
        message: json["message"],
        info: json["info"],
        data: OrderConfirmData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class OrderConfirmData {
  OrderConfirmData({
    this.sessionId,
    this.refId,
    this.orderId,
    this.grandTotal,
    this.invoiceId,
  });

  String sessionId;
  String refId;
  String orderId;
  String grandTotal;
  String invoiceId;

  factory OrderConfirmData.fromRawJson(String str) =>
      OrderConfirmData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderConfirmData.fromJson(Map<String, dynamic> json) =>
      OrderConfirmData(
        sessionId: json["session_id"] ?? '',
        refId: json["ref_id"] ?? '',
        orderId: json["order_id"] ?? '',
        grandTotal: json["grand_total"] ?? "",
        invoiceId:
            json["invoice_no"] != null ? json["invoice_no"].toString() : "",
      );

  Map<String, dynamic> toJson() => {
        "session_id": sessionId,
        "ref_id": refId,
        "order_id": orderId,
        "grand_total": grandTotal,
      };
}

// To parse this JSON data, do
//
//     final orderPlacedResponse = orderPlacedResponseFromJson(jsonString);

class OrderPlacedResponse {
  OrderPlacedResponse({
    this.status,
    this.message,
    this.info,
    this.data,
  });

  int status;
  String message;
  String info;
  OrderPlacedData data;

  factory OrderPlacedResponse.fromRawJson(String str) =>
      OrderPlacedResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderPlacedResponse.fromJson(Map<String, dynamic> json) =>
      OrderPlacedResponse(
        status: json["status"],
        message: json["message"],
        info: json["info"],
        data: OrderPlacedData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class OrderPlacedData {
  OrderPlacedData({
    this.invoiceId,
    this.invoiceReference,
    this.createdDate,
    this.expireDate,
    this.invoiceValue,
    this.comments,
    this.transactionDate,
    this.paymentGateway,
    this.referenceId,
    this.trackId,
    this.transactionId,
    this.paymentId,
    this.authorizationId,
    this.orderIds,
    this.transactionStatus,
    this.error,
    this.paidCurrency,
    this.paidCurrencyValue,
    this.transationValue,
    this.customerServiceCharge,
    this.dueValue,
    this.currency,
    this.invoiceDisplayValue,
    this.postDate,
    this.result,
    this.responseMessage,
    this.responseCode,
  });

  int invoiceId;
  String invoiceReference;
  String createdDate;
  String expireDate;
  double invoiceValue;
  String comments;
  String transactionDate;
  String paymentGateway;
  String referenceId;
  String trackId;
  String transactionId;
  String paymentId;
  String authorizationId;
  String orderIds;
  String transactionStatus;
  dynamic error;
  String paidCurrency;
  String paidCurrencyValue;
  String transationValue;
  String customerServiceCharge;
  String dueValue;
  String currency;
  dynamic invoiceDisplayValue;
  String postDate;
  String result;
  String responseMessage;
  int responseCode;

  factory OrderPlacedData.fromRawJson(String str) =>
      OrderPlacedData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderPlacedData.fromJson(Map<String, dynamic> json) =>
      OrderPlacedData(
        invoiceId: json["InvoiceId"] ?? 0,
        invoiceReference: json["InvoiceReference"] ?? '',
        createdDate: json["CreatedDate"] ?? '',
        expireDate: json["ExpireDate"] ?? '',
        invoiceValue: json["InvoiceValue"].toDouble() ?? 0.00,
        comments: json["Comments"] ?? '',
        transactionDate: json["TransactionDate"] ?? '',
        paymentGateway: json["PaymentGateway"] ?? '',
        referenceId: json["ReferenceId"] ?? '',
        trackId: json["TrackId"] ?? '',
        transactionId: json["TransactionId"] ?? '',
        paymentId: json["PaymentId"] ?? '',
        authorizationId: json["AuthorizationId"] ?? '',
        orderIds: json["OrderIds"] ?? '',
        transactionStatus: json["TransactionStatus"] ?? '',
        error: json["Error"] ?? '',
        paidCurrency: json["PaidCurrency"] ?? '',
        paidCurrencyValue: json["PaidCurrencyValue"] ?? '',
        transationValue: json["TransationValue"] ?? '',
        customerServiceCharge: json["CustomerServiceCharge"] ?? '',
        dueValue: json["DueValue"] ?? '',
        currency: json["Currency"] ?? '',
        invoiceDisplayValue: json["InvoiceDisplayValue"] ?? '',
        postDate: json["PostDate"] ?? '',
        result: json["result"] ?? '',
        responseMessage: json["ResponseMessage"] ?? '',
        responseCode: json["ResponseCode"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "InvoiceId": invoiceId,
        "InvoiceReference": invoiceReference,
        "CreatedDate": createdDate,
        "ExpireDate": expireDate,
        "InvoiceValue": invoiceValue,
        "Comments": comments,
        "TransactionDate": transactionDate,
        "PaymentGateway": paymentGateway,
        "ReferenceId": referenceId,
        "TrackId": trackId,
        "TransactionId": transactionId,
        "PaymentId": paymentId,
        "AuthorizationId": authorizationId,
        "OrderIds": orderIds,
        "TransactionStatus": transactionStatus,
        "Error": error,
        "PaidCurrency": paidCurrency,
        "PaidCurrencyValue": paidCurrencyValue,
        "TransationValue": transationValue,
        "CustomerServiceCharge": customerServiceCharge,
        "DueValue": dueValue,
        "Currency": currency,
        "InvoiceDisplayValue": invoiceDisplayValue,
        "PostDate": postDate,
        "result": result,
        "ResponseMessage": responseMessage,
        "ResponseCode": responseCode,
      };
}
