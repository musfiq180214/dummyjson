import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestOtherScreen extends ConsumerWidget {
  const GuestOtherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guest Other"),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (value) async {
              if (value == 'login') {
                await _handleLogin(context, ref);
              }
            },
            itemBuilder: (BuildContext context) => const [
              PopupMenuItem<String>(value: 'login', child: Text('Login')),
            ],
          ),
        ],
      ),
      body: const Center(child: Text("Welcome Guest to other Screen")),
    );
  }

  Future<void> _handleLogin(BuildContext context, WidgetRef ref) async {
    Navigator.pushNamed(context, '/login');
  }
}
