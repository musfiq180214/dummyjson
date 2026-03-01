import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic errorData;

  ApiException({required this.message, this.statusCode, this.errorData});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException()
    : super(message: 'No internet connection. Please check your network.');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({super.errorData})
    : super(message: 'Session expired. Please login again.', statusCode: 401);
}

class ServerException extends ApiException {
  ServerException({super.statusCode, super.errorData})
    : super(message: 'Server error. Please try again later.');
}

class ValidationException extends ApiException {
  ValidationException({super.errorData})
    : super(message: 'Validation failed.', statusCode: 422);
}

class ApiExceptionHandler {
  static ApiException handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        String message = 'Something went wrong';
        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        if (statusCode == 401) {
          return UnauthorizedException(errorData: data);
        } else if (statusCode == 422) {
          return ValidationException(errorData: data);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(statusCode: statusCode, errorData: data);
        }
        return ApiException(
          message: message,
          statusCode: statusCode,
          errorData: data,
        );
      default:
        return ApiException(message: 'An unexpected error occurred.');
    }
  }
}
