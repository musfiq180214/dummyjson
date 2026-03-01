import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:dummyjson/features/auth/domain/login_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  final LoginResponse user;

  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginProvider);
    return Scaffold(
      appBar: GlobalAppBar(
        title: "Profile",
        canGoBack: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.green),
            onSelected: (value) async {
              if (value == 'logout') {
                await _handleLogout(context, ref);
              } else if (value == 'home') {
                AppNavigator.pushTo(RouteNames.landing);
              } else if (value == 'product_list') {
                AppNavigator.pushTo(RouteNames.productList);
              } else if (value == 'product_search') {
                AppNavigator.pushTo(RouteNames.productSearch);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'logout', child: Text('Logout')),
              PopupMenuItem(value: 'home', child: Text('Home')),
              PopupMenuItem(value: 'product_list', child: Text('Product List')),
              PopupMenuItem(
                value: 'product_search',
                child: Text('Product Search'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (user.image != null)
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.image!),
              ),
            const SizedBox(height: 20),
            Text("ID: ${user.id}", style: const TextStyle(fontSize: 16)),
            Text(
              "Username: ${user.username}",
              style: const TextStyle(fontSize: 16),
            ),
            Text("Email: ${user.email}", style: const TextStyle(fontSize: 16)),
            Text(
              "First Name: ${user.firstName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Last Name: ${user.lastName}",
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              "Gender: ${user.gender}",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
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
