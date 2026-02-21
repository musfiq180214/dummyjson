// location_tracking_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:dummyjson/core/service/location_task_handler.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  // final token = ref.watch(authTokenProvider);
  // final user = ref.watch(userProvider);
  return LocationService();
});

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationService {
  LocationService();

  Future<void> start() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      AppLogger.i('❗ Location permission denied.');
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks.first;

    AppLogger.i(
      '📍 Placemark: ${place.street}, ${place.subLocality}, ${place.locality}, '
      '${place.administrativeArea}, ${place.postalCode}, ${place.country}',
    );

    // ✅ Check if inside Saudi Arabia
    //TODO :  PRODUCTION CHECK
    if ((place.country?.toLowerCase() ?? '') != 'saudi arabia' ||
        (place.isoCountryCode?.toUpperCase() ?? '') != 'SA') {
      AppLogger.i(
        '🛑 User moved out of Saudi Arabia. Stopping foreground service.',
      );
      await FlutterForegroundTask.stopService();
      return;
    }

    // ✅ Start the foreground service
    await FlutterForegroundTask.saveData(key: "token", value: "");
    await FlutterForegroundTask.saveData(
      key: "pilgrim",
      value: Null,
      // value: jsonEncode(user!.toJson()),
    );
    await FlutterForegroundTask.startService(
      notificationIcon: NotificationIcon(metaDataName: 'ic_launcher'),
      notificationTitle: 'Tracking Location',
      notificationText:
          'Labbaik is tracking your location to make sure you are safe.',
      callback: startCallback,
    );

    AppLogger.i('✅ Foreground task started.');
  }

  Future<void> stop() async {
    await FlutterForegroundTask.stopService();
  }
}
