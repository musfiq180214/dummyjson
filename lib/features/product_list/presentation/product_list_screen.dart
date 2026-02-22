import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';

import 'package:dummyjson/features/product_list/providers/product_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productListProvider);
    final loginState = ref.watch(loginProvider);

    return Scaffold(
      appBar: GlobalAppBar(
        title: context.t.product_list,
        cangoBack: false,
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
                      AppNavigator.navigatorKey.currentState!.pushNamed(
                        RouteNames.profile,
                        arguments: user,
                      );
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
              } else if (value == 'others') {
                AppLogger.i("Others clicked");
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
              PopupMenuItem(value: 'profile', child: Text('Profile')),
              PopupMenuItem(value: 'others', child: Text('Others')),
            ],
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text("Error: ${error.toString()}")),
        data: (products) {
          if (products.isEmpty) {
            return const Center(child: Text("No Products Found"));
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index].product;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(product?.title ?? "No Title"),
                  subtitle: Text(product?.description ?? "No Description"),
                  leading: CircleAvatar(
                    child: Text(product?.id?.toString() ?? ""),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    await ref.read(secureStorageProvider).deleteAll();
    AppLogger.i("Logging Out");

    // Example: Navigate to login screen
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
