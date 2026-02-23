import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:dummyjson/features/auth/presentation/login.dart';
import 'package:dummyjson/features/error_screen/no_internet.dart';
import 'package:dummyjson/features/guest_home/presentation/guest_home_screen.dart';
import 'package:dummyjson/features/landing/presentation/landing_screen.dart';
import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
import 'package:dummyjson/splash.dart';
import 'package:flutter/material.dart';

abstract class RouteNames {
  RouteNames._();

  static const String login = '/login';
  static const String resetPinInfo = '/reset-pin-info';
  static const String noInternet = '/no-internet';
  static const String splash = '/splash';
  static const String landing = '/landing';
  static const String profile = '/profile';
  static const String guestHome = '/guest-home';
}

abstract class AppNavigator {
  AppNavigator._();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> generateRoutes(RouteSettings settings) {
    AppLogger.i("Current Route==>> ${settings.name}");

    switch (settings.name) {
      case RouteNames.login:
        final cangoBack = settings.arguments as bool? ?? false;

        return MaterialPageRoute(
          builder: (_) => LoginScreen(cangoBack: cangoBack),
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

      case RouteNames.profile:
        final user = settings.arguments as LoginResponse?;
        if (user == null) {
          return MaterialPageRoute(
            builder: (_) =>
                Scaffold(body: Center(child: Text("No user data passed!"))),
            settings: settings,
          );
        }
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(user: user),
          settings: settings,
        );

      case RouteNames.guestHome:
        return MaterialPageRoute(
          builder: (_) => GuestHomeScreen(),
          settings: settings,
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
