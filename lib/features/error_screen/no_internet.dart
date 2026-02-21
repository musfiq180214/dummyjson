import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/service/internet_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

class NoInternetScreen extends ConsumerWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration placeholder (use your own asset here)
                SizedBox(
                  height: 250,
                  child: Lottie.asset(
                    'assets/svg/no_internet.json',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Please check your connection and try again.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Check connectivity
                      final connectivity = ref.read(internetStatusProvider);
                      final statuses = connectivity.value ?? [];

                      final hasInternet = statuses.any(
                        (status) =>
                            status != ConnectivityResult.none &&
                            status != ConnectivityResult.other,
                      );

                      if (hasInternet) {
                        // ✅ Internet is back — return to splash or previous page
                        AppNavigator.navigatorKey.currentState!.pop();
                      } else {
                        // ❌ Still offline
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No internet connection. Please try again.',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.blue,
                      elevation: 4,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
