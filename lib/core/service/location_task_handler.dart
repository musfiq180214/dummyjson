import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    AppLogger.i("🚀 Foreground task started at $timestamp");
    await _sendLocationUpdate();
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    AppLogger.i('🔄 Repeat event triggered at: $timestamp');
    await _sendLocationUpdate();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isForegroundService) async {
    AppLogger.i('🛑 Foreground task stopped.');
  }

  @override
  void onButtonPressed(String id) {
    // Optional: Handle notification action button presses.
  }

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp();
  }

  Future<void> _sendLocationUpdate() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      AppLogger.i('❗ Location service is OFF.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      AppLogger.i('❗ Location permission denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    AppLogger.i('📍 Location: ${position.latitude}, ${position.longitude}');

    try {
      final Dio dio = Dio();
      final token = await FlutterForegroundTask.getData(key: "token");
      final userJson = await FlutterForegroundTask.getData(key: "pilgrim");

      if (token == null || userJson == null) {
        AppLogger.e('❗ Token or user data is missing.');
        return;
      }

      final Map<String, dynamic> userMap = jsonDecode(userJson);
      final pilgrimId = userMap['id'];
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      AppLogger.i(
        '📍 Placemark: ${place.street}, ${place.subLocality}, ${place.locality}, '
        '${place.administrativeArea}, ${place.postalCode}, ${place.country}',
      );

      // ✅ Skip update if not in Saudi Arabia
      //TODO :  PRODUCTION CHECK
      if ((place.country?.toLowerCase() ?? '') != 'saudi arabia' ||
          (place.isoCountryCode?.toUpperCase() ?? '') != 'SA') {
        AppLogger.i(
          '🛑 User moved out of Saudi Arabia. Stopping foreground service.',
        );
        await FlutterForegroundTask.stopService();
        return;
      }

      final String baseUrl = kDebugMode
          ? baseUrlDevelopment
          : baseUrlProduction;

      final String url = "$baseUrl${ApiEndpoints.updateLocation}";

      final Map<String, dynamic> data = {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "pilgrim_id": pilgrimId,
        "placemark": {
          "street": place.street,
          "subLocality": place.subLocality,
          "locality": place.locality,
          "administrativeArea": place.administrativeArea,
          "postalCode": place.postalCode,
          "country": place.country,
          "name": place.name,
          "isoCountryCode": place.isoCountryCode,
          "subAdministrativeArea": place.subAdministrativeArea,
          "subThoroughfare": place.subThoroughfare,
          "thoroughfare": place.thoroughfare,
        },
      };

      final headers = {"Authorization": "Bearer $token"};

      AppLogger.i('🌐 [POST] $url');
      AppLogger.i('🔑 Headers: ${jsonEncode(headers)}');
      AppLogger.i('📨 Payload: ${jsonEncode(data)}');

      final response = await dio.post(
        url,
        options: Options(headers: headers),
        data: data,
      );

      AppLogger.i(
        '✅ Response [${response.statusCode}]: ${jsonEncode(response.data)}',
      );
    } on DioException catch (dioError, st) {
      final statusCode = dioError.response?.statusCode;
      final errorData = dioError.response?.data;
      final errorMessage =
          errorData?['error'] ??
          errorData?['message'] ??
          "Upload failed: $statusCode";

      AppLogger.e('❗ Dio error [$statusCode]: ${jsonEncode(errorData)}');
      AppLogger.e(st.toString());
    } catch (e, s) {
      AppLogger.e('❗ Failed to get placemark or send request: $e');
      AppLogger.e(s.toString());
    }
  }
}
