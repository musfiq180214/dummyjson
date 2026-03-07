import 'dart:async';
import 'dart:math';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final headingProvider = StreamProvider.autoDispose<HeadingState>((ref) {
  final stream = FlutterCompass.events;

  if (stream == null) {
    return Stream.value(
      HeadingState(
        heading: 0,
        hasSensor: false,
      ),
    );
  }

  return stream.map((event) {
    final heading = event.heading;

    return HeadingState(
      heading: heading ?? 0,
      hasSensor: heading != null,
    );
  });
});

class HeadingState {
  final double? heading;
  final bool hasSensor;

  HeadingState({
    required this.heading,
    required this.hasSensor,
  });
}

final directionProvider =
StateNotifierProvider<DirectionNotifier, DirectionState>((ref) {
  return DirectionNotifier();
});

class DirectionState {
  final double? bearing;
  final double? distance;
  final bool hasError;

  DirectionState({
    this.bearing,
    this.distance,
    this.hasError = false,
  });

  DirectionState copyWith({
    double? bearing,
    double? distance,
    bool? hasError,
  }) {
    return DirectionState(
      bearing: bearing ?? this.bearing,
      distance: distance ?? this.distance,
      hasError: hasError ?? this.hasError,
    );
  }
}

class DirectionNotifier extends StateNotifier<DirectionState> {
  DirectionNotifier() : super(DirectionState()) {
    _init();
  }

  final double targetLat = 21.4225; // Kaaba
  final double targetLng = 39.8262;

  Future<void> _init() async {
    final hasPermission = await _handlePermissions();
    if (!hasPermission) {
      state = state.copyWith(hasError: true);
      return;
    }

    Geolocator.getPositionStream().listen((position) {
      final bearing = _calculateBearing(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );
      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        targetLat,
        targetLng,
      );

      state = state.copyWith(
        bearing: bearing,
        distance: distance,
        hasError: false,
      );
    });
  }

  Future<bool> _handlePermissions() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  double _calculateBearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRadians(lon2 - lon1);
    final y = sin(dLon) * cos(_toRadians(lat2));
    final x = cos(_toRadians(lat1)) * sin(_toRadians(lat2)) -
        sin(_toRadians(lat1)) * cos(_toRadians(lat2)) * cos(dLon);
    final bearing = atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double deg) => deg * pi / 180;
  double _toDegrees(double rad) => rad * 180 / pi;
}
