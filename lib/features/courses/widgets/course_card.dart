import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String? iconPath; // <-- local image path
  final Color? iconColor; // optional: can tint the image
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.title,
    this.iconPath,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (iconPath != null)
                  Image.asset(
                    iconPath!,
                    width: 40,
                    height: 40,
                    color: iconColor, // optional: tints the image
                  ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}