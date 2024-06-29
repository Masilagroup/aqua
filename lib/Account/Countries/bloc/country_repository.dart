// @dart=2.9
import 'dart:io';

import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/Api_Manager/api_response_manager.dart';
import 'package:aqua/utils/constants.dart';

class CountryRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<ListCountries> getCountriesData() async {
    final listCountriesData = await apiBaseHelper
        .post(Constants.BASE_URL + Constants.COUNTRYLIST_URL, {
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    });
    return ListCountries.fromJson(listCountriesData);
  }
}
