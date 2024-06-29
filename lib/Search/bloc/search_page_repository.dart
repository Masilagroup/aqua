// @dart=2.9
import 'dart:convert';

import 'package:aqua/HomePage/bloc/homepage_response.dart';
import 'package:aqua/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageRepository {
  Future<HomePageData> getHomePageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = json.decode(prefs.getString(Constants.aquaHomePageData)) ??
        Map<String, dynamic>();
    return HomePageData.fromJson(userData);
  }
}
