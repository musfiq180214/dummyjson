// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import '../service/hive_service.dart';
// import '../utils/logger.dart';
// import '../provider/user_type_provider.dart';
// import '../utils/enums.dart';

// Future<void> updateUserTypeOnStart(WidgetRef ref) async {
//   final settingsBox = Hive.box(HiveService.settingsBox);
//   final String? accessToken = settingsBox.get('accessToken');

//   if (accessToken != null && accessToken.isNotEmpty) {
//     ref.read(userTypeProvider.notifier).state = UserType.loggedIn;
//   } else {
//     ref.read(userTypeProvider.notifier).state = UserType.guest;
//   }

//   AppLogger.i('UserType updated: ${ref.read(userTypeProvider)}');
// }
