import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_details.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_response.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/pilgrim.dart';

import '../../../core/utils/logger.dart';

abstract class IPreRegistrationRepository {
  Future<PreRegResponse> preRegistration({
    required OrderForm form,
    required bool edit,
    required String applicationID,
  });

  Future<List<Pilgrim>> getPreRegistrationList();

  Future<Map> verifyPhone({required String phone});

  Future<Map> verifyGuardian({required String trackingNumber});

  Future<PilgrimDetailsResponse> getPilgrimDetails({required int id});
}

class PreRegistrationRepository implements IPreRegistrationRepository {
  final Dio _dio;

  PreRegistrationRepository(this._dio);

  @override
  Future<Map> verifyGuardian({required String trackingNumber}) async {
    try {
      final response = await _dio.get(
        "ApiEndpoints.verifyGuardian",
        queryParameters: {"tracking_no": trackingNumber},
      );
      return response.data;
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Registration failed";

      return {'valid': false, 'message': errorMessage};
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      return {"valid": false, "message": "Registration failed"};
    }
  }

  @override
  Future<Map> verifyPhone({required String phone}) async {
    try {
      final response = await _dio.get(
        "ApiEndpoints.verifyPhone",
        queryParameters: {"phone": phone},
      );
      return response.data;
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Registration failed";

      return {'valid': false, 'message': errorMessage};
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      return {"valid": false, "message": "Registration failed"};
    }
  }

  @override
  Future<PreRegResponse> preRegistration({
    required OrderForm form,
    required bool edit,
    required String applicationID,
  }) async {
    final formData = await form.toFormData();

    // Log text fields
    final Map<String, dynamic> fieldsMap = {
      for (var field in formData.fields) field.key: field.value,
    };
    AppLogger.i("=== PreRegistration Form Fields ===");
    AppLogger.i(jsonEncode(fieldsMap));

    final response = edit
        ? await _dio.put(
            "/v2/user/application/$applicationID/pre_registration",
            data: await form.toFormData(),
            options: Options(headers: {"Content-Type": "multipart/form-data"}),
          )
        : await _dio.post(
            "ApiEndpoints.preRegistration",
            data: await form.toFormData(),
            options: Options(headers: {"Content-Type": "multipart/form-data"}),
          );
    return PreRegResponse.fromJson(response.data);
  }

  @override
  Future<List<Pilgrim>> getPreRegistrationList() async {
    try {
      final response = await _dio.get(
        "ApiEndpoints.preRegistrationList",
        queryParameters: {"refresh": true},
      );
      if (response.statusCode == 200) {
        return (response.data as List).map((e) => Pilgrim.fromJson(e)).toList();
      } else {
        return [];
      }
    } on DioException catch (dioError) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Registration failed";

      return [];
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      return [];
    }
  }

  @override
  Future<PilgrimDetailsResponse> getPilgrimDetails({required int id}) async {
    try {
      final response = await _dio.get(
        '${"ApiEndpoints.pilgrimDetails"}/$id/pre_registration_details',
      );

      if (response.statusCode == 200) {
        return PilgrimDetailsResponse.fromJson(response.data);
      } else {
        return PilgrimDetailsResponse();
      }
    } on DioException catch (dioError) {
      if (dioError.response?.statusCode == 500) {
        throw Exception("Internal server error");
      } else {
        final errorMessage =
            dioError.response?.data['error'] ??
            dioError.response?.data['message'] ??
            "RefundDetailsResponse failed";
        throw Exception(errorMessage);
      }
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      throw Exception(e.toString());
    }
  }
}
