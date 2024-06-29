// @dart=2.9
import 'dart:io';

import 'package:aqua/Account/ContentPages/bloc/content_page_response.dart';
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/utils/constants.dart';

class ContentPageRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<ContentPageResponse> getContentPageData(
    String keyword,
  ) async {
    final contentPageData =
        await apiBaseHelper.post(Constants.BASE_URL + Constants.CONTENT_URL, {
      'keyword': keyword,
      'lang': Constants.selectedLang,
      'device_type': Platform.isIOS ? 'ios' : 'android',
      'device_token': Constants.deviceUUID,
    });
    return ContentPageResponse.fromJson(contentPageData);
  }
}
