import 'dart:async';
import 'dart:io';

import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
    // Camera
    await Permission.camera.request();

    // Storage / Photos
    if (Platform.isAndroid) {
      await Permission.photos.request();
    }

    // Small delay so system dialogs finish properly
    await Future.delayed(const Duration(milliseconds: 400));

    // Notifications (all cases handled)
    await handleNotificationPermission();
  }

  Future<void> handleNotificationPermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      debugPrint("Android SDK: $sdkInt");

      // 🔹 Android 12 and below
      if (sdkInt < 33) {
        if (!mounted) return;

        showCustomSnackBar(
          context,
          message:
              "Notifications are enabled by default on your device.\n"
              "You can manage them anytime from system settings.",
          type: MessageType.error,
        );

        return;
      }

      // 🔹 Android 13+
      PermissionStatus status = await Permission.notification.status;
      AppLogger.i("Initial notification status: $status");

      if (status.isGranted) {
        AppLogger.i("Notification already granted");
        return;
      }

      if (status.isDenied) {
        final result = await Permission.notification.request();
        AppLogger.i("After request status: $result");

        if (result.isGranted) {
          AppLogger.i("Notification granted");
        } else if (result.isPermanentlyDenied) {
          _showSettingsDialog();
        }
      }

      if (status.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    }

    // 🔹 iOS
    if (Platform.isIOS) {
      final status = await Permission.notification.status;

      if (status.isGranted) {
        AppLogger.i("iOS notification already granted");
        return;
      }

      final result = await Permission.notification.request();

      if (result.isPermanentlyDenied) {
        _showSettingsDialog();
      }
    }
  }

  void _showSettingsDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Notification Permission Required"),
        content: const Text(
          "Notification permission is permanently denied.\n\n"
          "Please enable it manually from app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
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
