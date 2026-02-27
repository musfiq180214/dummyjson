import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// INTERNET CONNECTIVITY HANDLER
final internetStatusProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

class InternetHandler {
  final BuildContext context;
  final WidgetRef ref;

  InternetHandler({required this.context, required this.ref});

  void init() {
    ref.listen<AsyncValue<List<ConnectivityResult>>>(internetStatusProvider, (
      previous,
      next,
    ) {
      next.whenData((statuses) {
        final hasInternet = statuses.any(
          (status) =>
              status != ConnectivityResult.none &&
              status != ConnectivityResult.other,
        );

        final currentRoute =
            AppNavigator.navigatorKey.currentState?.context != null
            ? ModalRoute.of(
                AppNavigator.navigatorKey.currentState!.context!,
              )?.settings.name
            : null;

        if (!hasInternet) {
          if (currentRoute != RouteNames.noInternet) {
            AppNavigator.navigatorKey.currentState!.pushNamed(
              RouteNames.noInternet,
            );
          }
        } else {
          if (currentRoute == RouteNames.noInternet) {
            AppNavigator.navigatorKey.currentState!.pop();
          }
        }
      });
    });
  }
}
