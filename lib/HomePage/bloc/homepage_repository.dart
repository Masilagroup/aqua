// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/global.dart';
import 'package:aqua/utils/constants.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage_response.dart';

class HomePageRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<HomePageData> getHomePageData() async {
    var currency = prefs.getInt("currencyCode");

    Map<String, dynamic> parameters = {
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    };
    if (currency != null) {
      parameters["currency"] = currency;
    }
    final homepageData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.HOMEPAGE_URL, parameters);

    prefs.setString(Constants.aquaHomePageData, json.encode(homepageData));
    return HomePageData.fromJson(homepageData);
  }

  Future<String> getDeviceDetails() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.androidId; //UUID for Android
        final storage = FlutterSecureStorage();
        await storage.write(key: "AQUA_UUID", value: identifier);
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
        final storage = FlutterSecureStorage();
        await storage.write(key: "AQUA_UUID", value: identifier);
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return identifier;
  }

  Future<String> checkDeviceToken() async {
    final storage = FlutterSecureStorage();
    String value = await storage.read(key: "AQUA_UUID");

    print(value);
    if (value == null) {
      return getDeviceDetails();
    } else {
      return value;
    }
  }
}
