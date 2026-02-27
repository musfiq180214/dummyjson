import 'package:dio/dio.dart';
import 'package:dummyjson/core/network/api_interceptors.dart';
import 'package:dummyjson/flavour_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);

class ApiClient {
  final Dio _dio;
  final Ref _ref;

  ApiClient(this._ref)
    : _dio = Dio(BaseOptions(baseUrl: FlavorConfig.instance.baseUrl)) {
    _dio.interceptors.add(ApiInterceptor(_ref));
  }

  Dio get dio => _dio;
}
