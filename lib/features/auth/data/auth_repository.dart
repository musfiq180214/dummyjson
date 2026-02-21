import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login({required String username, required String pass});
}

class AuthRepository implements IAuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  @override
  Future<LoginResponse> login({
    required String username,
    required String pass,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {"username": username, 'password': pass},
    );
    return LoginResponse.fromJson(response.data);
  }
}
