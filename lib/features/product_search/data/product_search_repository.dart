import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/features/product_search/domain/product_search_response.dart';

abstract class IProductSearchRepository {
  Future<ProductSearchResponse> searchProducts(String query);
}

class ProductSearchRepository implements IProductSearchRepository {
  final Dio _dio;

  ProductSearchRepository(this._dio);

  @override
  Future<ProductSearchResponse> searchProducts(String query) async {
    // final response = await dio.get(
    //   'https://dummyjson.com/products/search',
    //   queryParameters: {'q': query},
    // );
    final response = await _dio.get(
      ApiEndpoints.productSearch,
      queryParameters: {'q': query},
    );

    return ProductSearchResponse.fromJson(response.data);
  }
}
