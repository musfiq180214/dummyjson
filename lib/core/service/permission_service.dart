import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/permission.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionNotifierProvider =
    StateNotifierProvider<PermissionNotifier, PermissionStatusModel>(
      (ref) => PermissionNotifier(),
    );

class PermissionNotifier extends StateNotifier<PermissionStatusModel> {
  PermissionNotifier() : super(PermissionStatusModel.initial());

  Future<void> request(AppPermission permission) async {
    final alreadyGranted = await _checkIfGranted(permission);
    if (alreadyGranted) {
      _updatePermissionState(permission, true);
      return;
    }

    late PermissionStatus result;
    switch (permission) {
      case AppPermission.location:
        result = await Permission.location.request();
        break;
      case AppPermission.storage:
        result = await Permission.storage.request();
        break;
      case AppPermission.phone:
        result = await Permission.phone.request();
        break;
      case AppPermission.camera:
        result = await Permission.phone.request();
        break;
    }

    _updatePermissionState(permission, result.isGranted);
  }

  Future<void> requestAll() async {
    for (final permission in AppPermission.values) {
      final isAlreadyGranted = await _checkIfGranted(permission);
      if (!isAlreadyGranted) {
        await request(permission);
      } else {
        _updatePermissionState(permission, true);
      }
    }
  }

  Future<bool> _checkIfGranted(AppPermission permission) async {
    switch (permission) {
      case AppPermission.location:
        return await Permission.location.isGranted;
      case AppPermission.storage:
        return await Permission.storage.isGranted;
      case AppPermission.phone:
        return await Permission.phone.isGranted;
      case AppPermission.camera:
        return await Permission.camera.isGranted;
    }
  }

  void _updatePermissionState(AppPermission permission, bool granted) {
    state = state.copyWith(status: {...state.status, permission: granted});
  }

  bool isGranted(AppPermission permission) => state.status[permission] ?? false;
}
