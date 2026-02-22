import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';

import '../../../core/utils/logger.dart';

abstract class IProductRepository {
  Future<List<ProductResponseModel>> getProducts();
}

class ProductRepository implements IProductRepository {
  final Dio _dio;

  ProductRepository(this._dio);

  @override
  Future<List<ProductResponseModel>> getProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.products);

      final List<dynamic> data = response.data['products'];

      return flightListFromJson(data);
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Failed to get products data!";
      throw Exception(errorMessage);
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      throw Exception('Failed to load products');
    }
  }
}
