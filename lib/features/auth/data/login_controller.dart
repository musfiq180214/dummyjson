// import 'dart:convert';

// import 'package:dio/dio.dart';
// import 'package:dummyjson/core/utils/enums.dart';
// import 'package:dummyjson/features/auth/data/auth_repository.dart';
// import 'package:dummyjson/features/auth/domain/login_response.dart';
// import 'package:dummyjson/features/auth/providers/login_provider.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../../core/utils/logger.dart';

// class LoginController extends AutoDisposeAsyncNotifier<LoginResponse?> {
//   late final IAuthRepository _repo;

//   @override
//   Future<LoginResponse?> build() async {
//     _repo = ref.read(loginRepoProvider);
//     return null;
//   }

//   Future<void> login({required String username, required String pass}) async {
//     state = const AsyncLoading();
//     try {
//       final response = await _repo.login(username: username, pass: pass);

//       final accessToken = response.accessToken;
//       final refreshToken = response.refreshToken;

//       await ref.read(secureStorageProvider).deleteAll();

//       await ref
//           .read(secureStorageProvider)
//           .write(key: 'accessToken', value: accessToken);
//       await ref
//           .read(secureStorageProvider)
//           .write(key: 'refreshToken', value: refreshToken);

//       ref.read(accessTokenProvider.notifier).state = accessToken;
//       ref.read(refreshTokenProvider.notifier).state = refreshToken;
//       ref.read(userTypeProvider.notifier).state = UserType.loggedIN;

//       state = AsyncData(response); // ✅ properly typed
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }
// }
