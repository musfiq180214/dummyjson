import '../domain/namaz_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';

abstract class INamazRepository {
  Future<NamazModel> getNamazTimes();
}

class NamazRepository implements INamazRepository {
  final Dio _dio;

  NamazRepository(this._dio);

  @override
  Future<NamazModel> getNamazTimes() async {

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    double lat = position.latitude;
    double lon = position.longitude;

    List<Placemark> placemarks =
    await placemarkFromCoordinates(lat, lon);

    String district =
        placemarks.first.subAdministrativeArea ??
            placemarks.first.locality ??
            "Unknown";

    final response = await _dio.get(
      "https://api.aladhan.com/v1/timings?latitude=$lat&longitude=$lon&method=3",
    );

    final data = response.data;

    return NamazModel.fromJson(data, district);
  }
}