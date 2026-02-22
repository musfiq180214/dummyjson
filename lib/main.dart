import 'dart:convert';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/provider/language_provider.dart';
import 'package:dummyjson/core/theme/app_theme.dart';
import 'package:dummyjson/core/theme/theme_provider.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterForegroundTask.initCommunicationPort();
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'foreground_service',
      channelName: 'Foreground Service Notification',
      channelDescription:
          'This notification appears when the foreground service is running.',
      channelImportance: NotificationChannelImportance.HIGH,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: false,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: kDebugMode
          ? ForegroundTaskEventAction.repeat(5000)
          : ForegroundTaskEventAction.repeat(600000),
      autoRunOnBoot: true,
      autoRunOnMyPackageReplaced: true,
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
  final container = ProviderContainer();
  await initializeToken(container);

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

Future<void> initializeToken(ProviderContainer container) async {
  /*  await container
      .read(secureStorageProvider)
      .deleteAll(); */ // Only if needed and While on DEV mode and testing
  final accessToken =
      await container.read(secureStorageProvider).read(key: 'accessToken') ??
      "";

  AppLogger.i("Access Token Fetched from secureStorage: $accessToken");

  if (accessToken.isNotEmpty) {
    container.read(accessTokenProvider.notifier).state = accessToken;
  }

  final refreshToken =
      await container.read(secureStorageProvider).read(key: 'refreshToken') ??
      "";

  AppLogger.i("Refresh Token Fetched from secureStorage: $refreshToken");

  if (refreshToken.isNotEmpty) {
    container.read(refreshTokenProvider.notifier).state = refreshToken;
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(languageProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: RouteNames.splash,
      themeMode: themeMode,
      onGenerateRoute: AppNavigator.generateRoutes,
      scaffoldMessengerKey: AppNavigator.scaffoldMessengerKey,
      navigatorKey: AppNavigator.navigatorKey,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: locale,
    );
  }
}


/*
 valid user: {username: emilys, password: emilyspass}
*/