import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/theme/colors.dart';
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
    await ref.read(secureStorageProvider).deleteAll();
    AppLogger.i("Logging Out");

    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.login,
      (route) => false,
    );
  }

  void _handleOthers() {
    AppLogger.i("Others clicked");
  }
}
