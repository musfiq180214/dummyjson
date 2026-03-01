import 'dart:convert';

import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/features/auth/data/auth_repository.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final loginProvider = AsyncNotifierProvider<LoginController, LoginResponse?>(
  () => LoginController(),
);

class LoginController extends AsyncNotifier<LoginResponse?> {
  @override
  Future<LoginResponse?> build() async {
    final storage = ref.read(secureStorageProvider);
    final userJson = await storage.read(key: 'userData');

    if (userJson != null) {
      final user = LoginResponse.fromJson(jsonDecode(userJson));

      // ref.read(userTypeProvider.notifier).state = UserType.loggedIn;
      // ref.read(accessTokenProvider.notifier).state = user.accessToken;
      ref.read(refreshTokenProvider.notifier).state = user.refreshToken;

      return user;
    }

    return null;
  }

  Future<void> login({required String username, required String pass}) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(loginRepoProvider); // ✅ read here

      final response = await repo.login(username: username, pass: pass);

      await ref
          .read(secureStorageProvider)
          .write(key: 'userData', value: jsonEncode(response.toJson()));

      await ref
          .read(accessTokenServiceProvider)
          .saveToken(response.accessToken!);

      await ref
          .read(refreshTokenServiceProvider)
          .saveToken(response.refreshToken!);

      await ref
          .read(secureStorageProvider)
          .write(key: 'accessToken', value: response.accessToken);

      await ref
          .read(secureStorageProvider)
          .write(key: 'refreshToken', value: response.refreshToken);

      ref.read(accessTokenProvider.notifier).state = response.accessToken;
      ref.read(refreshTokenProvider.notifier).state = response.refreshToken;
      // ref.read(userTypeProvider.notifier).state = UserType.loggedIn;

      await ref.read(hiveServiceProvider).setOnboardingComplete(true);

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

// final userTypeProvider = StateProvider<UserType>((ref) => UserType.guest);
