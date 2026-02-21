import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/features/auth/data/auth_repository.dart';
import 'package:dummyjson/features/auth/data/login_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final loginProvider =
    AsyncNotifierProvider.autoDispose<LoginController, dynamic>(
      () => LoginController(),
    );

final loginRepoProvider = Provider.autoDispose<IAuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider)),
);
final accessTokenProvider = StateProvider<String?>((ref) => null);
final refreshTokenProvider = StateProvider<String?>((ref) => null);
final isResetPinTappedProvider = StateProvider<bool>((ref) => false);
