// @dart=2.9
import 'dart:convert';

class CurrencyList {
  CurrencyList({
    this.status,
    this.message,
    this.info,
    this.currencyData,
  });

  int status;
  String message;
  String info;
  List<CurrencyData> currencyData;

  CurrencyList.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    currencyData = List<CurrencyData>.from(
        json["data"].map((x) => CurrencyData.fromJson(x)));
  }
}

class CurrencyData {
  CurrencyData({
    this.currencyId,
    this.currencyName,
    this.currencyCode,
    this.currencyIso,
  });

  int currencyId;
  String currencyName;
  String currencyCode;
  String currencyIso;

  factory CurrencyData.fromRawJson(String str) =>
      CurrencyData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CurrencyData.fromJson(Map<String, dynamic> json) => CurrencyData(
        currencyId: json["currency_id"] ?? 0,
        currencyName: json["currency_name"] ?? '',
        currencyCode: json["currency_code"] ?? '',
        currencyIso: json["currency_iso"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "currency_id": currencyId,
        "currency_name": currencyName,
        "currency_code": currencyCode,
        "currency_iso": currencyIso,
      };
}
