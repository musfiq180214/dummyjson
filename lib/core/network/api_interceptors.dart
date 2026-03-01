import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/user_type_provider.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/logger.dart';

class ApiInterceptor extends Interceptor {
  final Ref ref;

  ApiInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
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

    final accessTokenService = ref.read(accessTokenServiceProvider);
    final token = await accessTokenService.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final hiveService = ref.read(hiveServiceProvider);
    final areaId = hiveService.getSelectedAreaId();
    if (areaId != null) {
      options.headers['area-id'] = areaId.toString();
    }

    if (kDebugMode) {
      final logBuffer = StringBuffer()
        ..writeln('🔹 REQUEST → ${options.method.toUpperCase()} ${options.uri}')
        ..writeln('Headers: ${jsonEncode(options.headers)}');
      if (options.data != null) {
        logBuffer.writeln('Body: ${_prettifyJson(options.data)}');
      }
      AppLogger.i(logBuffer.toString());
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      AppLogger.d(
        'RESPONSE ← [${response.statusCode}] ${response.requestOptions.uri}\n'
        '${_prettifyJson(response.data)}',
      );
    }
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      final logMsg = StringBuffer()
        ..writeln(
          'ERROR ← [${err.response?.statusCode}] ${err.requestOptions.uri}',
        )
        ..writeln('Type: ${err.type}')
        ..writeln('Message: ${err.message}');
      if (err.response?.data != null) {
        logMsg.writeln('Error Response: ${_prettifyJson(err.response?.data)}');
      }
      AppLogger.e(logMsg.toString());
    }

    if (err.response?.statusCode == 401) {
      final accessTokenService = ref.read(accessTokenServiceProvider);
      final refreshTokenService = ref.read(refreshTokenServiceProvider);

      await accessTokenService.deleteToken();
      await refreshTokenService.deleteToken();
      ref.read(userTypeProvider.notifier).state = UserType.guest;

      AppNavigator.goTo(RouteNames.login);
    }
    return handler.next(err);
  }
}

String _prettifyJson(dynamic data) {
  try {
    final jsonData = data is String ? jsonDecode(data) : data;
    return JsonEncoder.withIndent(' ').convert(jsonData);
  } catch (_) {
    return data.toString();
  }
}
