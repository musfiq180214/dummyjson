// import 'package:dummyjson/core/navigation/route_names.dart';
// import 'package:dummyjson/core/utils/logger.dart';
// import 'package:dummyjson/features/auth/domain/login_response.dart';
// import 'package:dummyjson/features/auth/presentation/login.dart';
// import 'package:dummyjson/features/error_screen/no_internet.dart';
// import 'package:dummyjson/features/guest_home/presentation/guest_home_screen.dart';
// import 'package:dummyjson/features/landing/presentation/landing_screen.dart';
// import 'package:dummyjson/features/product_list/domain/product_response_model.dart';
// import 'package:dummyjson/features/product_list/presentation/product_detail_screen.dart';
// import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
// import 'package:dummyjson/splash.dart';
// import 'package:flutter/material.dart';

// abstract class AppNavigator {
//   AppNavigator._();
//   static final navigatorKey = GlobalKey<NavigatorState>();
//   static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

//   static Route<dynamic> generateRoutes(RouteSettings settings) {
//     AppLogger.i("Current Route==>> ${settings.name}");

//     switch (settings.name) {
//       case RouteNames.login:
//         final cangoBack = settings.arguments as bool? ?? false;

//         return MaterialPageRoute(
//           builder: (_) => LoginScreen(cangoBack: cangoBack),
//           settings: RouteSettings(name: RouteNames.login),
//         );

//       case RouteNames.noInternet:
//         return MaterialPageRoute(
//           builder: (_) => NoInternetScreen(),
//           settings: RouteSettings(name: RouteNames.noInternet),
//         );

//       case RouteNames.splash:
//         return MaterialPageRoute(
//           builder: (_) => SplashScreen(),
//           settings: RouteSettings(name: RouteNames.splash),
//         );

//       case RouteNames.landing:
//         return MaterialPageRoute(
//           builder: (_) => LandingScreen(),
//           settings: RouteSettings(name: RouteNames.landing),
//         );

//       case RouteNames.profile:
//         final user = settings.arguments as LoginResponse?;
//         if (user == null) {
//           return MaterialPageRoute(
//             builder: (_) =>
//                 Scaffold(body: Center(child: Text("No user data passed!"))),
//             settings: settings,
//           );
//         }
//         return MaterialPageRoute(
//           builder: (_) => ProfileScreen(user: user),
//           settings: settings,
//         );

//       case RouteNames.guestHome:
//         return MaterialPageRoute(
//           builder: (_) => GuestHomeScreen(),
//           settings: settings,
//         );

//       case RouteNames.productDetails:
//         final product = settings.arguments as Product?;

//         if (product == null) {
//           return MaterialPageRoute(
//             builder: (_) =>
//                 Scaffold(body: Center(child: Text("No product data passed!"))),
//           );
//         }

//         return MaterialPageRoute(
//           builder: (_) => ProductDetails(product: product),
//           settings: settings,
//         );
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//           settings: RouteSettings(name: settings.name),
//         );
//     }
//   }
// }

// import 'package:amar_shodai_delivery/core/navigation/route_names.dart';
// import 'package:amar_shodai_delivery/core/utils/logger.dart';
// import 'package:amar_shodai_delivery/features/home/presentation/order_details.dart';
// import 'package:amar_shodai_delivery/features/home/presentation/order_page.dart';
// import 'package:amar_shodai_delivery/features/login/presentation/login_screen.dart';
// import 'package:flutter/material.dart';

// abstract class AppNavigator {
//   AppNavigator._();
//   static final navigatorKey = GlobalKey<NavigatorState>();
//   static final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
//   static Route<dynamic> generateRoutes(RouteSettings settings) {
//     AppLogger.i("Current Route==>> ${settings.name}");
//     switch (settings.name) {
//       case RouteNames.root:
//         return MaterialPageRoute(
//           settings: const RouteSettings(name: RouteNames.root),
//           builder: (_) => const RootDecider(),
//         );

//       case RouteNames.login:
//         return MaterialPageRoute(
//           settings: const RouteSettings(name: RouteNames.login),
//           builder: (_) => const LoginScreen(),
//         );

//       case RouteNames.home:
//         return MaterialPageRoute(
//           settings: const RouteSettings(name: RouteNames.home),
//           builder: (_) => const HomePage(),
//         );

//       case RouteNames.orderDetails:
//         final args = settings.arguments;
//         if (args is! OrderDetailsArgs) {
//           // If someone navigates incorrectly, show an error screen
//           return MaterialPageRoute(
//             builder: (_) => Scaffold(
//               body: Center(
//                 child: Text('Order details arguments missing or invalid'),
//               ),
//             ),
//           );
//         }

//         return MaterialPageRoute(
//           builder: (_) => OrderDetailsPage(
//             orderId: args.orderId,
//             status2: args.status2,
//             Name: args.Name,
//             address_line: args.address_line,
//             note: args.note,
//           ),
//         );

//       default:
//         return MaterialPageRoute(
//           settings: RouteSettings(name: 'Unknown-${settings.name}'),
//           builder: (_) => Scaffold(
//             body: Center(child: Text('No route defined for ${settings.name}')),
//           ),
//         );
//     }
//   }
// }

import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/features/auth/presentation/login.dart';
import 'package:dummyjson/features/guest_home/presentation/guest_home_screen.dart';
import 'package:dummyjson/features/landing/presentation/landing_screen.dart';
import 'package:dummyjson/features/onboarding/presentation/splash_page.dart';
import 'package:dummyjson/features/product_list/domain/product_response_model.dart';
import 'package:dummyjson/features/product_list/presentation/product_detail_screen.dart';
import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
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
    path: RouteNames.guestHome,
    builder: (context, state) => const GuestHomeScreen(),
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
