// @dart=2.9
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/utils/constants.dart';

class RelateProductsRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<ProductItemResponse> getRelatedProductsData(
      Map<String, dynamic> parameters) async {
    final wishListData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.RELATED_PRODUCTS_LIST, parameters);
    return ProductItemResponse.fromJson(wishListData);
  }
}
