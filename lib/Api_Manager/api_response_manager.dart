// @dart=2.9
// Content Pages Response

import 'dart:convert';

class Content {
  String message;
  String info;
  ContentData data;

  Content({
    this.message,
    this.info,
    this.data,
  });

  Content.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    data = ContentData.fromJson(json["data"] ?? {});
  }
}

class ContentData {
  String title;
  String content;
  String image;

  ContentData({
    this.title,
    this.content,
    this.image,
  });

  ContentData.fromJson(Map<String, dynamic> json) {
    title = json["title"] ?? '';
    content = json["content"] ?? '';
    image = json["image"] ?? '';
  }
}

// Contact Us

class Contactus {
  String message;
  String info;

  Contactus({
    this.message,
    this.info,
  });

  Contactus.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? '';
    info = json["info"] ?? '';
  }
}

// List of Countries
class ListCountries {
  List<Country> results;
  String message;
  String info;
  ListCountries({
    this.message,
    this.results,
    this.info,
  });

  ListCountries.fromJson(Map<String, dynamic> json) {
    message = json['message'] ?? '';
    info = json['info'] ?? '';
    if (json['data'].length != null) {
      results = new List<Country>();
      json['data'].forEach((f) {
        results.add(new Country.fromJson(f));
      });
    }
  }
}

// Get the Country
class Country {
  int countryId;
  String countryName;
  int countryPhonecode;
  String countryIso;
  Country({
    this.countryId,
    this.countryName,
    this.countryPhonecode,
    this.countryIso,
  });
  Country.fromJson(Map<String, dynamic> json) {
    countryId = json["country_id"] ?? '';
    countryName = json["country_name"] ?? '';
    countryPhonecode = json["country_phonecode"] ?? '';
    countryIso = json["country_iso"] ?? '';
  }
}

// Login User

class LogInUser {
  String message;
  String info;
  UserInfo data;

  LogInUser({
    this.message,
    this.info,
    this.data,
  });

  LogInUser.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    data = UserInfo.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}

class UserInfo {
  int userId;
  String userName;
  String userEmail;
  String userMobile;
  int userCountryId;
  String userCountryName;
  dynamic userArea;
  dynamic userHouse;
  dynamic userBlock;
  dynamic userStreet;
  dynamic userAddress;
  int userStatus;
  String userApiAccessToken;
  String userFirstName;
  String userLastName;

  UserInfo({
    this.userId,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.userCountryId,
    this.userCountryName,
    this.userArea,
    this.userHouse,
    this.userBlock,
    this.userStreet,
    this.userAddress,
    this.userStatus,
    this.userApiAccessToken,
    this.userFirstName,
    this.userLastName,
  });

  UserInfo.fromJson(Map<String, dynamic> json) {
    userFirstName = json['user_first_name'] ?? '';
    userLastName = json['user_last_name'] ?? '';
    userId = json["user_id"] ?? 0;
    userName = json["user_name"] ?? '';
    userEmail = json["user_email"] ?? '';
    userMobile = json["user_mobile"] ?? '';
    userCountryId = json["user_country_id"] ?? 0;
    userCountryName = json["user_country_name"] ?? '';
    userArea = json["user_area"] ?? '';
    userHouse = json["user_house"] ?? '';
    userBlock = json["user_block"] ?? '';
    userStreet = json["user_street"] ?? '';
    userAddress = json["user_address"] ?? '';
    userStatus = json["user_status"] ?? 0;
    userApiAccessToken = json["user_api_access_token"] ?? '';
  }

  Map<String, dynamic> toJson() => {
        "user_first_name": userFirstName,
        "user_last_name": userLastName,
        "user_id": userId,
        "user_name": userName,
        "user_email": userEmail,
        "user_mobile": userMobile,
        "user_country_id": userCountryId,
        "user_country_name": userCountryName,
        "user_area": userArea,
        "user_house": userHouse,
        "user_block": userBlock,
        "user_street": userStreet,
        "user_address": userAddress,
        "user_status": userStatus,
        "user_api_access_token": userApiAccessToken,
      };
}

// Register User

class RegisterUser {
  String message;
  String info;
  UserInfo data;

  RegisterUser({
    this.message,
    this.info,
    this.data,
  });

  RegisterUser.fromJson(Map<String, dynamic> json) {
    message = json["message"] ?? '';
    info = json["info"] ?? '';
    data = UserInfo.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "info": info,
        "data": data.toJson(),
      };
}
