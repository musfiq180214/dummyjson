import 'package:dio/dio.dart';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/features/home/domain/home_models.dart';
import 'package:dummyjson/flavour_config.dart';

abstract class IHomeRepo {
  Future<void> sendLocationUpdate(LocationUpdate update, String token);
}

class HomeRepo implements IHomeRepo {
  final Dio dio;

  HomeRepo({required this.dio});

  @override
  Future<void> sendLocationUpdate(LocationUpdate update, String token) async {
    final url = FlavorConfig.instance.baseUrl + ApiEndpoints.updateLocation;
    await dio.post(
      url,
      data: update.toJson(),
      options: Options(headers: {"Authorization": "Bearer $token"}),
    );
  }
}
