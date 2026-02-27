import 'dart:async';

import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/service/hive_service.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    final token = await ref.read(tokenServiceProvider).getToken();
    final onboardingComplete = ref
        .read(hiveServiceProvider)
        .isOnboardingComplete();

    debugPrint("TOKEN: $token");
    debugPrint("ONBOARDING: $onboardingComplete");

    if (!onboardingComplete || token == null || token.isEmpty) {
      AppNavigator.goTo(RouteNames.login);
    } else {
      AppNavigator.goTo(RouteNames.landing);
    }
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
