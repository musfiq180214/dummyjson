import 'dart:async';
import 'dart:io';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

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

    // --- Animations ---
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

    Future.delayed(const Duration(milliseconds: 1000), () {
      _delayedController.forward();
    });

    // --- Request permissions ---
    requestAllPermissions();

    // --- Navigate after delay ---
    Future.delayed(const Duration(seconds: 3), () {
      _navigateNext();
    });
  }

  void _navigateNext() {
    final accessToken = ref.read(accessTokenProvider) ?? "";
    final refreshToken = ref.read(refreshTokenProvider) ?? "";

    AppNavigator.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      RouteNames.landing,
      (route) => false,
    );

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      ref.read(userTypeProvider.notifier).state = UserType.loggedIN;
    } else {
      ref.read(userTypeProvider.notifier).state = UserType.guest;
    }
  }

  Future<void> requestAllPermissions() async {
    // 1️⃣ Camera permission
    final cameraStatus = await Permission.camera.request();
    if (cameraStatus.isGranted) {
      print("Camera granted");
    }

    // 2️⃣ Storage permission (handle scoped storage on Android 10+)
    final storageStatus = await Permission.storage.request();
    if (storageStatus.isGranted) {
      print("Storage granted");
    }

    // 3️⃣ Notification permission
    if (Platform.isAndroid) {
      // Android 13+ (API 33+) → request notification permission
      if (await Permission.notification.isDenied) {
        final notifStatus = await Permission.notification.request();
        if (notifStatus.isGranted) {
          print("Notification granted");
        }
      } else {
        // Android 10–12 → show info dialog
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Notifications"),
            content: const Text(
              "Notifications are enabled by default on your device. "
              "To change settings, go to system settings.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }

    // 4️⃣ iOS → request normally
    if (Platform.isIOS) {
      final notifStatus = await Permission.notification.request();
      if (notifStatus.isGranted) print("Notification granted");
    }
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
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
                            Text(
                              "Dummy JSON APP",
                              style: AppTextStyles.bodyM.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Learn Flutter",
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 100),
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
