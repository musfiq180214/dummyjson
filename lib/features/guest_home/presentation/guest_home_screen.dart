import 'package:device_info_plus/device_info_plus.dart';
import 'package:dummyjson/core/navigation/app_navigator.dart';
import 'package:dummyjson/core/navigation/route_names.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class GuestHomeScreen extends ConsumerWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: GlobalAppBar(
        title: "context.t.",
        canGoBack: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.green),
            onSelected: (value) async {
              if (value == 'login') {
                await _handleLogin(context, ref);
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'login',
                child: Text(context.t.sign_in),
              ),
            ],
          ),
        ],
      ),
      body: Center(child: Text(context.t.guest_home)),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    Navigator.pushNamed(context, RouteNames.login, arguments: true);
  }
}
