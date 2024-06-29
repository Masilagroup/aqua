// @dart=2.9
import 'package:aqua/Api_Manager/api_helper.dart';
import 'package:aqua/ProductItem/ProductList/bloc/product_list_response.dart';
import 'package:aqua/utils/constants.dart';

class ProductListRepository {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  Future<ProductItemResponse> getProductsListData(
      Map<String, dynamic> parameters) async {
    final productListData = await apiBaseHelper.post(
        Constants.BASE_URL + Constants.PRODUCTS_LIST, parameters);
    return ProductItemResponse.fromJson(productListData);
  }
}
