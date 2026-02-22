import 'package:dummyjson/core/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dummyjson/core/widgets/global_appbar.dart';

class GuestOtherScreen extends ConsumerWidget {
  const GuestOtherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: GlobalAppBar(
        title: context.t.guest_other,
        cangoBack: false, // enable back if navigated from another screen
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
      body: Center(child: Text(context.t.welcome_guest_another)),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    Navigator.pushNamed(context, '/login');
  }
}
