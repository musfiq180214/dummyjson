import 'dart:async';

import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/user_type_provider.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../core/navigation/app_navigator.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = await ref.read(accessTokenServiceProvider).getToken();
    final refreshToken = await ref.read(refreshTokenServiceProvider).getToken();

    final onboardingComplete = ref
        .read(hiveServiceProvider)
        .isOnboardingComplete();

    AppLogger.i("ACCESS TOKEN: $accessToken");
    AppLogger.i("REFRESH TOKEN: $refreshToken");
    AppLogger.i("ONBOARDING: $onboardingComplete");
    // Set user type based on tokens
    final userType =
        (accessToken != null &&
            accessToken.isNotEmpty &&
            refreshToken != null &&
            refreshToken.isNotEmpty)
        ? UserType.loggedIn
        : UserType.guest;

    if (!onboardingComplete || accessToken == null || accessToken.isEmpty) {
      ref.read(userTypeProvider.notifier).state = UserType.guest;
      AppNavigator.goTo(RouteNames.login);
    } else {
      ref.read(userTypeProvider.notifier).state = UserType.loggedIn;
      AppNavigator.goTo(RouteNames.landing);
    }

    AppLogger.i(
      "Splash USER TYPE set to navigate: ${ref.read(userTypeProvider)}",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash/amar_shoday_splash.jpeg'),
            fit: BoxFit.cover, // makes the image cover the whole screen
          ),
        ),
      ),
    );
  }
}
