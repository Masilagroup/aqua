// @dart=2.9
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'app_exceptions.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(url);
      responseJson = returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api get recieved!');
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    var responseJson;
    print(url);
    print(body);
    try {
      final response = await http.post(url, body: json.encode(body), headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      });
      print(response.body);
      responseJson = returnResponse(response);
    } on SocketException {
      print('No net');
      throw FetchDataException('No Internet connection');
    }
    print('api Post recieved!');
    return responseJson;
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
