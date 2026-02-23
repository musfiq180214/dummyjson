import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  final token = ref.watch(accessTokenProvider);

  return ApiClient(token);
});

final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);

class ApiClient {
  final Dio _dio;

  //TODO :  PRODUCTION CHECK
  ApiClient(String? token)
    : _dio = Dio(
        BaseOptions(
          baseUrl: kDebugMode ? baseUrl : baseUrl,

          headers: token == null ? null : {'Authorization': 'Bearer $token'},

          // making an unauthorized API hit to check fallback redirection to Landing
          // headers: {'Authorization': null},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult == ConnectivityResult.none) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'No internet connection',
                type: DioExceptionType.connectionError,
              ),
            );
          }

          if (kDebugMode) {
            AppLogger.i('🔹 REQUEST: ${options.method} ${options.uri}');
            AppLogger.d('Headers: ${jsonEncode(options.headers)}');

            if (options.data is FormData) {
              final formDataMap = <String, dynamic>{};
              for (var field in (options.data as FormData).fields) {
                formDataMap[field.key] = field.value;
              }
              AppLogger.d(
                'Form Fields:  ${_prettifyJson(jsonEncode(formDataMap))}',
              );

              for (var file in (options.data as FormData).files) {
                AppLogger.d('📎 File: ${file.key} => ${file.value.filename}');
              }
            } else if (options.data != null) {
              AppLogger.d('Body: ${_prettifyJson(options.data.toString())}');
            }
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            AppLogger.i(
              '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
            );
            AppLogger.d('Response Body: ${_prettifyJson(response.data)}');
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (kDebugMode) {
            AppLogger.e(
              '❌ ERROR: ${e.response?.statusCode} ${e.requestOptions.uri}',
            );
            AppLogger.d('Error Message: ${e.message}');
            if (e.response?.data != null) {
              AppLogger.d('Error Response: ${_prettifyJson(e.response?.data)}');
            }
          }

          if (e.response?.statusCode == 401) {
            AppLogger.e('🔒 Unauthorized - Redirecting to login');

            final context = AppNavigator.navigatorKey.currentContext!;
            final container = ProviderScope.containerOf(context, listen: false);

            // ✅ capture all notifiers/services before any `await`
            final authTokenNotifier = container.read(
              accessTokenProvider.notifier,
            );
            final storage = container.read(secureStorageProvider);
            //final userTypeNotifier = container.read(userTypeProvider.notifier);
            // final bottomNavNotifier = container.read(
            //   bottomNavIndexProvider.notifier,
            // );

            // update state immediately
            authTokenNotifier.state = null;
            // userTypeNotifier.state = UserType.guest;
            // bottomNavNotifier.state = 0;

            // async work (no more container.read here)
            await storage.deleteAll();

            if (context.mounted) {
              AppNavigator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
                RouteNames.landing,
                (route) => false,
              );
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  String _prettifyJson(dynamic data) {
    try {
      final jsonData = data is String ? jsonDecode(data) : data;
      return const JsonEncoder.withIndent('  ').convert(jsonData);
    } catch (e) {
      return data.toString();
    }
  }
}
