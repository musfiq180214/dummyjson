import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/language_switch.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool canGoBack;
  final VoidCallback? onBackPress;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.canGoBack = true, // default true
    this.onBackPress,
    this.bottom,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      elevation: 2,
      flexibleSpace: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // First row: LanguageSwitcher
            // First row: LanguageSwitcher, full width
            SizedBox(
              height: kToolbarHeight * 0.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerRight, // keep button on right
                  child: LanguageSwitcher(),
                ),
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ), // 👈 left & right padding
                child: Row(
                  children: [
                    if (canGoBack)
                      IconButton(
                        padding: const EdgeInsets.only(
                          left: 4,
                        ), // 👈 small inner spacing
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.green,
                        ),
                        onPressed:
                            onBackPress ?? () => Navigator.of(context).pop(),
                      ),

                    const SizedBox(width: 4), // 👈 space between icon and title

                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.bodyM.copyWith(
                          color: Colors.green,
                          fontSize: 18,
                        ),
                      ),
                    ),

                    if (actions != null) ...actions!,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight * 1.8 + (bottom?.preferredSize.height ?? 0),
  );
}
