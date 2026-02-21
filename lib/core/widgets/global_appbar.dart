import 'package:dummyjson/core/utils/sizes.dart';
import 'package:dummyjson/core/widgets/language_switch.dart';
import 'package:flutter/material.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool cangoBack;
  final Function? onBackPress;
  final PreferredSizeWidget? bottom;

  const GlobalAppBar({
    super.key,
    required this.title,
    required this.cangoBack,
    this.bottom,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: AppTextStyles.bodyM.copyWith(color: Colors.green),
      ),
      backgroundColor: Colors.white,
      centerTitle: false,
      actions: [LanguageSwitcher()],
      bottom: bottom,
      leading: cangoBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.green),
              onPressed: () => onBackPress != null
                  ? onBackPress!()
                  : Navigator.of(context).pop(),
            )
          : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
