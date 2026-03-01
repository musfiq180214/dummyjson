import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/provider/language_provider.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/theme/app_theme.dart';
import 'package:dummyjson/core/theme/theme_provider.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/flavour_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // <- S class

import 'core/navigation/app_navigator.dart';

Future<void> dummyJSON() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox(HiveService.settingsBox);
  await Hive.openBox(HiveService.cartBox);
  await Hive.openBox(HiveService.ordersBox);
  await Hive.openBox(HiveService.locationBox);

  AppLogger.i('🚀 Dummy JSON Delivery App started');

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('bn')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(languageProvider);
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: FlavorConfig.instance.appTitle,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: const [
        S.delegate, // <- THIS IS THE KEY
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, widget) {
        Widget error = const Text('...rendering error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(body: Center(child: error));
        }
        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) return widget;
        throw StateError('widget is null');
      },
    );
  }
}

void main() async {
  FlavorConfig.instantiate(
    flavor: Flavor.staging,
    baseUrl: baseUrlDevelopment,
    appTitle: "Dummy JSON (Staging)",
  );

  await dummyJSON();
}


/*
 valid user: {username: emilys, password: emilyspass}
 to generate translation: change intl_bn.arb and intl_en.arb and run: dart run intl_utils:generate
  to generate app icon and replace default app icon: 
  update directory of app icon in pubspec.yaml
  In Terminal:
  flutter pub run flutter_launcher_icons:main
*/