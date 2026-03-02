import 'package:dio/dio.dart';
import 'package:dummyjson/core/utils/logger.dart';

abstract class IDropdownRepository {
  Future<List<Map<String, dynamic>>> fetchDropdown(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  });
}

class DropdownRepository implements IDropdownRepository {
  final Dio _dio;
  DropdownRepository(this._dio);

  @override
  Future<List<Map<String, dynamic>>> fetchDropdown(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          // Ensure each element is a Map<String, dynamic>
          return data.whereType<Map<String, dynamic>>().map((e) => e).toList();
        }
      }
      return [];
    } catch (e, stack) {
      AppLogger.e("Dropdown fetch error: $e\n$stack");
      return [];
    }
  }
}
