import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/landing/data/landinng_model.dart';

abstract class ILandingRepository {
  Future<UpdateType> checkUpdateType(int buildNo);
}

class LandingRepository implements ILandingRepository {
  final Dio _dio;

  LandingRepository(this._dio);

  @override
  Future<UpdateType> checkUpdateType(int buildNo) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.checkAppUpdate,
        queryParameters: {
          "app_type": Platform.isAndroid ? "android" : "ios",
          "build_no": buildNo,
        },
      );

      return UpdateType.fromJson(response.data);
    } on DioException catch (dioError, st) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Failed to check update type!";
      AppLogger.e(st.toString());
      throw Exception(errorMessage);
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      return UpdateType(forceUpdate: false, currentBuild: 0, updatedBuild: 0);
    }
  }
}
