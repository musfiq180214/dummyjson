import 'package:dummyjson/core/utils/enums.dart';

class PermissionStatusModel {
  final Map<AppPermission, bool> status;

  PermissionStatusModel({required this.status});

  PermissionStatusModel.initial()
    : status = {
        AppPermission.location: false,
        AppPermission.storage: false,
        AppPermission.phone: false,
      };

  PermissionStatusModel copyWith({Map<AppPermission, bool>? status}) {
    return PermissionStatusModel(status: status ?? this.status);
  }
}
