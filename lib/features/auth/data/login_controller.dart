import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dummyjson/features/auth/data/auth_repository.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/logger.dart';

class LoginController extends AutoDisposeAsyncNotifier<dynamic> {
  late final IAuthRepository _repo;

  @override
  Future<LoginResponse?> build() async {
    _repo = ref.read(loginRepoProvider);
    return null; // initially nothing
  }

  Future<void> login({required String username, required String pass}) async {
    state = const AsyncLoading();
    try {
      final response = await _repo.login(username: username, pass: pass);
      final accessToken = response.accessToken;
      final refreshToken = response.refreshToken;
      await ref.read(secureStorageProvider).deleteAll();

      // now save the new token & data
      await ref
          .read(secureStorageProvider)
          .write(key: 'accessToken', value: accessToken);

      await ref
          .read(secureStorageProvider)
          .write(key: 'refreshToken', value: refreshToken);

      // then update providers
      ref.read(accessTokenProvider.notifier).state = accessToken;
      ref.read(refreshTokenProvider.notifier).state = refreshToken;
      state = AsyncData(response);
    } on DioException catch (dioError, st) {
      String errorMessage = "Login Failed";

      if (dioError.response != null) {
        final data = dioError.response?.data;
        if (data != null &&
            data['message'] != null &&
            data['message'].toString().isNotEmpty) {
          errorMessage = data['message'];
        }
      }

      state = AsyncError(errorMessage, st);
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      state = AsyncError(e, st);
    }
  }
}
