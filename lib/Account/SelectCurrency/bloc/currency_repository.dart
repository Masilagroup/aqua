// @dart=2.9
import 'dart:io';

import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_response.dart';

class CurrencyRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<CurrencyList> getCurrenciesData() async {
    final listCurrencies = await apiBaseHelper
        .post(Constants.BASE_URL + Constants.CURRENCYLIST_URL, {
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    });
    //  filterCurrency(CurrencyList.fromJson(listCurrencies).currencyData);
    return CurrencyList.fromJson(listCurrencies);
  }

  setCurrency(CurrencyData currencyData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(Constants.aquacurrencyData, currencyData.toRawJson());
  }

  Future<CurrencyData> retriveCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tmpData = CurrencyData(
      currencyId: 114,
      currencyName: 'Kuwait',
      currencyCode: 'KWD',
      currencyIso: 'KWT',
    );
    var currencyData = CurrencyData.fromRawJson(
        prefs.getString(Constants.aquacurrencyData) ?? tmpData.toRawJson());
    //  print(currencyData.currencyName);

    Constants.selectedCurrency = currencyData.currencyId;
    Constants.selectedCurrencyString = currencyData.currencyCode;
    return currencyData;
  }

  filterCurrency(List<CurrencyData> currencyData) {
    var filterList = currencyData
        .where((x) => (x.currencyId == Constants.selectedCurrency))
        .toList();
    if (filterList.length > 0) {
      Constants.selectedCurrency = filterList.first.currencyId;
      Constants.selectedCurrencyString = filterList.first.currencyCode;
    } else {
      Constants.selectedCurrency = 114;
      Constants.selectedCurrencyString = "KWD";
    }
  }
}
