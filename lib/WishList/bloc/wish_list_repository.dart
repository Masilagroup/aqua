// @dart=2.9
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/WishList/bloc/wish_list_response.dart';
import 'package:aqua/utils/constants.dart';

class WishListRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<WishListResponse> getUserWishListData(
      Map<String, dynamic> parameters) async {
    final wishListData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.WISH_LIST_URL, parameters);

    return WishListResponse.fromJson(wishListData);
  }

  Future<WishListAddDelete> addDeleteToWishList(
      Map<String, dynamic> parameters) async {
    final wishAddDelete = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.WISH_ADD_DELETE, parameters);
    return WishListAddDelete.fromJson(wishAddDelete);
  }
}
