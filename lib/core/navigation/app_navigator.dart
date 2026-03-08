import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:dummyjson/features/auth/presentation/login.dart';
import 'package:dummyjson/features/cart/presentation/cart_screen.dart';
import 'package:dummyjson/features/compass/presentation/compass_screen.dart';
import 'package:dummyjson/features/guest_home/presentation/guest_home_screen.dart';
import 'package:dummyjson/features/home/domain/home_models.dart';
import 'package:dummyjson/features/landing/presentation/landing_screen.dart';
import 'package:dummyjson/features/multi_screen_order_placement/presentation/multi_screen_order_placement.dart';
import 'package:dummyjson/features/namaz/presentaion/namaz_screen.dart';
import 'package:dummyjson/features/onboarding/presentation/splash_page.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';
import 'package:dummyjson/features/product_list/presentation/product_detail_screen.dart';
import 'package:dummyjson/features/product_list/presentation/product_list_screen.dart';
import 'package:dummyjson/features/product_search/presentation/product_search_screen.dart';
import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
import 'package:dummyjson/features/suras/presentation/surah_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

abstract class AppNavigator {
  AppNavigator._();
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();

  static void goTo(String route, {Object? extra}) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    GoRouter.of(ctx).go(route, extra: extra);
  }

  static void pushTo(String route, {Object? extra}) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    GoRouter.of(ctx).push(route, extra: extra);
  }

  static void pop([Object? result]) {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    if (GoRouter.of(ctx).canPop()) {
      GoRouter.of(ctx).pop(result);
    } else {
      GoRouter.of(ctx).go(RouteNames.landing);
    }
  }
}

class AppRoute {
  final String path;
  final Widget Function(BuildContext, GoRouterState) builder;

  const AppRoute({required this.path, required this.builder});
}

final List<AppRoute> appRoutes = [
  AppRoute(path: RouteNames.splash, builder: (_, __) => const SplashPage()),
  AppRoute(path: RouteNames.landing, builder: (_, __) => const LandingScreen()),
  AppRoute(
    path: RouteNames.login,
    builder: (context, state) => const LoginScreen(),
  ),
  AppRoute(
    path: RouteNames.profile,
    builder: (context, state) {
      final user = state.extra as LoginResponse?;
      if (user == null) {
        return const Scaffold(body: Center(child: Text("No user data passed")));
      }
      return ProfileScreen(user: user);
    },
  ),
  AppRoute(
    path: RouteNames.productList,
    builder: (context, state) {
      return ProductListScreen();
    },
  ),
  AppRoute(
    path: RouteNames.productDetails,
    builder: (context, state) {
      final product = state.extra as Product?;

      if (product == null) {
        return const Scaffold(
          body: Center(child: Text("No product data passed")),
        );
      }

      return ProductDetails(product: product);
    },
  ),

  AppRoute(
    path: RouteNames.productSearch,
    builder: (context, state) {
      return const ProductSearchScreen();
    },
  ),

  AppRoute(
    path: RouteNames.multiScreenOrderPlacement,
    builder: (context, state) {
      return const MultiStepOrderScreen();
    },
  ),

  AppRoute(
    path: RouteNames.compass,
    builder: (context, state) {
      return const CompassScreen();
    },
  ),

  AppRoute(
    path: RouteNames.namaz,
    builder: (context, state) {
      return const NamazScreen();
    },
  ),

  AppRoute(
    path: RouteNames.cart,
    builder: (context, state) {
      return const CartScreen();
    },
  ),

  AppRoute(
    path: RouteNames.surah_list,
    builder: (context, state) {
      return const SurahListScreen();
    },
  ),




];

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: AppNavigator.navigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    routes: [
      for (final r in appRoutes)
        GoRoute(path: r.path, name: r.path, builder: r.builder),
    ],
  );
});
