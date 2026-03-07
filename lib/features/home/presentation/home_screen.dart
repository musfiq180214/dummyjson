import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/service/token_service.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';

import 'package:dummyjson/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: GlobalAppBar(
        title: context.t.home,
        canGoBack: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.green),
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout(context, ref);
              } else if (value == 'profile') {
                loginState.when(
                  data: (user) {
                    if (user != null) {
                      AppNavigator.pushTo(RouteNames.profile, extra: user);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("User data not available"),
                        ),
                      );
                    }
                  },
                  loading: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Loading user data...")),
                    );
                  },
                  error: (err, st) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error fetching user data")),
                    );
                  },
                );
              } else if (value == 'product_list') {
                AppNavigator.pushTo(RouteNames.productList);
              } else if (value == 'multi_screen_order_placement') {
                AppNavigator.pushTo(RouteNames.multiScreenOrderPlacement);
              } else if (value == 'compass') {
                AppNavigator.pushTo(RouteNames.compass);
              }else if (value == 'namaz') {
                AppNavigator.pushTo(RouteNames.namaz);
              } else if (value == 'others') {
                AppLogger.i("Others clicked");
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'product_list', child: Text('Product List')),
              PopupMenuItem(
                value: 'multi_screen_order_placement',
                child: Text('Multi Screen Order Placement'),
              ),
              PopupMenuItem(
                value: 'compass',
                child: Text('Compass'),
              ),
              PopupMenuItem(
                value: 'namaz',
                child: Text('Namaz'),
              ),
              PopupMenuItem(value: 'others', child: Text('Others')),
            ],
          ),
        ],
      ),

      body: loginState.when(
        data: (loginResponse) {
          if (loginResponse == null) {
            return const Center(child: Text("No user data found."));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text("ID: ${loginResponse.id}"),
                Text("Username: ${loginResponse.username}"),
                Text("Email: ${loginResponse.email}"),
                Text("First Name: ${loginResponse.firstName}"),
                Text("Last Name: ${loginResponse.lastName}"),
                Text("Gender: ${loginResponse.gender}"),
                if (loginResponse.image != null)
                  Image.network(loginResponse.image!),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final accessTokenService = ref.read(accessTokenServiceProvider);
    final refreshTokenService = ref.read(refreshTokenServiceProvider);

    await accessTokenService.deleteToken();
    await refreshTokenService.deleteToken();
    // ref.read(userTypeProvider.notifier).state = UserType.guest;
    await ref.read(secureStorageProvider).deleteAll();
    AppNavigator.goTo(RouteNames.login);
  }

  void _handleOthers() {
    AppLogger.i("Others clicked");
  }
}
