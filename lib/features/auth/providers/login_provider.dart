import 'dart:convert';

import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/features/auth/data/auth_repository.dart';
import 'package:dummyjson/features/auth/data/login_controller.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final loginProvider = AsyncNotifierProvider<LoginController, LoginResponse?>(
  () => LoginController(),
);

class LoginController extends AsyncNotifier<LoginResponse?> {
  late final IAuthRepository _repo;

  @override
  Future<LoginResponse?> build() async {
    _repo = ref.read(loginRepoProvider);

    final storage = ref.read(secureStorageProvider);
    final userJson = await storage.read(key: 'userData');

    if (userJson != null) {
      return LoginResponse.fromJson(jsonDecode(userJson));
    }

    return null;
  }

  Future<void> login({required String username, required String pass}) async {
    state = const AsyncLoading();
    try {
      final response = await _repo.login(username: username, pass: pass);

      //save response in securedStorage
      await ref
          .read(secureStorageProvider)
          .write(key: 'userData', value: jsonEncode(response.toJson()));

      // save tokens
      await ref
          .read(secureStorageProvider)
          .write(key: 'accessToken', value: response.accessToken);
      await ref
          .read(secureStorageProvider)
          .write(key: 'refreshToken', value: response.refreshToken);

      ref.read(accessTokenProvider.notifier).state = response.accessToken;
      ref.read(refreshTokenProvider.notifier).state = response.refreshToken;
      ref.read(userTypeProvider.notifier).state = UserType.loggedIN;

      state = AsyncData(response);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

final loginRepoProvider = Provider<IAuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider)),
);

final accessTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);
final isResetPinTappedProvider = StateProvider<bool>((ref) => false);

final userTypeProvider = StateProvider<UserType>((ref) => UserType.guest);
