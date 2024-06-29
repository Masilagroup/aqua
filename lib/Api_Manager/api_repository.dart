// @dart=2.9
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/utils/constants.dart';

import 'api_response_manager.dart';

class APIRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

// Get Content Pages

  Future<Content> fetchContentPage(Map<String, dynamic> body) async {
    final response = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.CONTENT_URL, body);
    return Content.fromJson(response);
  }

// Get Contact US
  Future<Contactus> fetchContactUsPage(Map<String, dynamic> body) async {
    final response = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.CONTACTUS_URL, body);
    return Contactus.fromJson(response);
  }

// Get Countries List

  Future<ListCountries> fetchCountries(Map<String, dynamic> body) async {
    final response = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.COUNTRYLIST_URL, body);
    return ListCountries.fromJson(response);
  }

// Login User
  Future<LogInUser> logInWith(Map<String, dynamic> body) async {
    final response = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.LOGIN_URL, body);
    return LogInUser.fromJson(response);
  }

  // Register User
  Future<RegisterUser> registerWith(Map<String, dynamic> body) async {
    final response = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.REGISTER_URL, body);
    return RegisterUser.fromJson(response);
  }
}

//
