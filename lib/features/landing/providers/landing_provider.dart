import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/core/service/app_update_service.dart';
import 'package:dummyjson/features/landing/repository/landing_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appUpdateProvider =
    StateNotifierProvider<AppUpdateNotifier, AppUpdateService>((ref) {
      return AppUpdateNotifier(ref);
    });

final appUpdateRepositoryProvider = Provider<ILandingRepository>((ref) {
  final dio = ref.watch(dioProvider); // Your existing Dio provider
  return LandingRepository(dio);
});

final versionProvider = FutureProvider.autoDispose<String?>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
});
