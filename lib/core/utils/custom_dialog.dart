import 'package:dummyjson/core/utils/enums.dart';
import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context, {
  required String message,
  required MessageType type,
}) {
  final backgroundColor = switch (type) {
    MessageType.error => Colors.red,
    MessageType.success => Colors.green,
    MessageType.warning => Colors.orange,
    MessageType.info => Colors.blue,
  };

  final icon = switch (type) {
    MessageType.error => Icons.error,
    MessageType.success => Icons.check_circle,
    MessageType.warning => Icons.warning,
    MessageType.info => Icons.info,
  };
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(
            child: Text(message, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
    ),
  );
}

void showCustomDialog(
  BuildContext context, {
  required String title,
  required String message,
  required MessageType type,
  bool showLoading = false,
}) {
  final icon = switch (type) {
    MessageType.error => Icons.error,
    MessageType.success => Icons.check_circle,
    MessageType.warning => Icons.warning,
    MessageType.info => Icons.info,
  };

  final iconColor = switch (type) {
    MessageType.error => Colors.red,
    MessageType.success => Colors.green,
    MessageType.warning => Colors.orange,
    MessageType.info => Colors.blue,
  };

  showDialog(
    context: context, // Prevent closing when loading
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: showLoading
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            )
          : Text(message),
      actions: showLoading
          ? null
          : [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
    ),
  );
}

void closeSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).clearSnackBars();
}
