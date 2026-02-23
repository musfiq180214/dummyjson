import 'package:dio/dio.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';

abstract class IProductRepository {
  Future<List<ProductResponseModel>> getProducts(int perPage, int pageNumber);
}

class ProductRepository implements IProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  @override
  Future<List<ProductResponseModel>> getProducts(
    int perPage,
    int pageNumber,
  ) async {
    final skip = (pageNumber - 1) * perPage;

    final response = await _dio.get(
      "/products",
      queryParameters: {"limit": perPage, "skip": skip},
    );

    final List<dynamic> data = response.data["products"];

    return productListFromJson(data);
  }
}
