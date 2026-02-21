import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/presentation/login.dart';
import 'package:dummyjson/features/error_screen/no_internet.dart';
import 'package:dummyjson/features/landing/presentation/landing_screen.dart';
import 'package:dummyjson/splash.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  RouteNames._();

  static const String login = '/login';
  static const String resetPinInfo = '/reset-pin-info';
  static const String noInternet = '/no-internet';
  static const String splash = '/splash';
  static const String landing = '/landing';
}

abstract class AppNavigator {
  AppNavigator._();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    AppLogger.i("Current Route==>> ${settings.name}");

    switch (settings.name) {
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: RouteSettings(name: RouteNames.login),
        );

      case RouteNames.noInternet:
        return MaterialPageRoute(
          builder: (_) => NoInternetScreen(),
          settings: RouteSettings(name: RouteNames.noInternet),
        );

      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: RouteSettings(name: RouteNames.splash),
        );

      case RouteNames.landing:
        return MaterialPageRoute(
          builder: (_) => LandingScreen(),
          settings: RouteSettings(name: RouteNames.landing),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
          settings: RouteSettings(name: settings.name),
        );
    }
  }
}
