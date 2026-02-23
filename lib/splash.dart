import 'dart:async';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _delayedController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late Animation<double> _secondFadeAnimation;
  late Animation<Offset> _secondSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Main animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Delayed animation for second column
    _delayedController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _secondFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _delayedController, curve: Curves.easeIn),
    );

    _secondSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _delayedController, curve: Curves.easeOut),
        );

    // Start delayed animation after main finishes
    Future.delayed(const Duration(milliseconds: 1000), () {
      _delayedController.forward();
    });

    Timer(const Duration(seconds: 3), () {
      AppNavigator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
        RouteNames.landing,
        (route) => false,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _delayedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: green,
      body: Container(
        padding: AppSpacing.paddingL,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/png/splash.png"),
            fit: BoxFit.contain,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _secondFadeAnimation,
                      child: SlideTransition(
                        position: _secondSlideAnimation,
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              "Learn Flutter",
                              style: AppTextStyles.bodyM.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Learn RestAPIs",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
                    Hero(
                      tag: 'appIcon',
                      child: Image.asset(
                        "assets/app_icon/app_icon.png",
                        height: 100,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
