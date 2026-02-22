import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/language_switch.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool cangoBack;
  final Function? onBackPress;
  final PreferredSizeWidget? bottom;
  final List<Widget>? actions; // for second row actions

  const GlobalAppBar({
    super.key,
    required this.title,
    required this.cangoBack,
    this.bottom,
    this.onBackPress,
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
            // First row: LanguageSwitcher, taller
            Container(
              height: kToolbarHeight * 0.8, // increased height
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LanguageSwitcher(),
            ),

            // Second row: back button, title, actions
            Container(
              height: kToolbarHeight, // standard toolbar height
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  if (cangoBack)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.green,
                      ),
                      onPressed: () => onBackPress != null
                          ? onBackPress!()
                          : Navigator.of(context).pop(),
                    ),
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
          ],
        ),
      ),
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight * 1.8 + (bottom?.preferredSize.height ?? 0),
  ); // adjusted for taller first row
}
