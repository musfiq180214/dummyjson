import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/landing/providers/landing_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

final appUpdateServiceProvider =
    StateNotifierProvider<AppUpdateNotifier, AppUpdateService>((ref) {
      return AppUpdateNotifier(ref);
    });

final versionProvider = FutureProvider<String?>((ref) async {
  final packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.buildNumber;
});

class AppUpdateService {
  final bool updateAvailable;
  final bool updateInProgress;
  final bool isMajorUpdate;
  final bool isMinorUpdate;

  AppUpdateService({
    this.updateAvailable = false,
    this.updateInProgress = false,
    this.isMajorUpdate = false,
    this.isMinorUpdate = false,
  });
}

class AppUpdateNotifier extends StateNotifier<AppUpdateService> {
  final Ref ref;

  AppUpdateNotifier(this.ref) : super(AppUpdateService());

  Future<void> checkForUpdate() async {
    try {
      final currentVersion = await ref.read(versionProvider.future) ?? "";
      AppLogger.i("Current version: $currentVersion");

      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        final updateType = await ref
            .read(appUpdateRepositoryProvider)
            .checkUpdateType(int.parse(currentVersion));

        AppLogger.i("Update info from backend: $updateType");

        state = AppUpdateService(
          updateAvailable: true,
          isMajorUpdate: updateType.isMajorUpdate,
        );
      }
    } catch (e, s) {
      AppLogger.e("Update check error", e, s);
    }
  }

  bool _isMajorUpdate(String current, String store) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final storeParts = store.split('.').map(int.parse).toList();

      return storeParts.length >= 3 &&
          currentParts.length >= 3 &&
          storeParts[1] > currentParts[1];
    } catch (_) {
      return false;
    }
  }

  bool _isMinorUpdate(String current, String store) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final storeParts = store.split('.').map(int.parse).toList();

      return storeParts.length >= 3 &&
          currentParts.length >= 3 &&
          storeParts[1] == currentParts[1] &&
          storeParts[2] > currentParts[2];
    } catch (_) {
      return false;
    }
  }

  Future<bool> performImmediateUpdate() async {
    try {
      state = AppUpdateService(
        updateAvailable: state.updateAvailable,
        updateInProgress: true,
        isMajorUpdate: state.isMajorUpdate,
        isMinorUpdate: state.isMinorUpdate,
      );

      final result = await InAppUpdate.performImmediateUpdate();
      return result == AppUpdateResult.success;
    } catch (e, s) {
      AppLogger.e("Update error", e, s);
      return false;
    } finally {
      state = AppUpdateService(); // Reset everything
    }
  }

  Future<bool> performMinorUpdate() async {
    try {
      state = AppUpdateService(
        updateAvailable: state.updateAvailable,
        updateInProgress: true,
        isMajorUpdate: state.isMajorUpdate,
        isMinorUpdate: state.isMinorUpdate,
      );

      final result = await InAppUpdate.startFlexibleUpdate();
      return result == AppUpdateResult.success;
    } catch (e, s) {
      AppLogger.e("Update error", e, s);
      return false;
    } finally {
      state = AppUpdateService(); // Reset everything
    }
  }
}
