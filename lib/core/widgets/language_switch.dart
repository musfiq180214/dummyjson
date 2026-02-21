import 'package:dummyjson/core/provider/language_provider.dart';
import 'package:dummyjson/core/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageSwitcher extends ConsumerWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.paddingHorizontalS.horizontal,
            vertical: AppSpacing.paddingVerticalXS.vertical,
          ),
          value: ref.watch(languageProvider).languageCode,
          isDense: true,
          items: [
            DropdownMenuItem(value: 'en', child: Text('English')),
            DropdownMenuItem(value: 'bn', child: Text('বাংলা')),
          ],
          onChanged: (String? newLang) {
            if (newLang != null) {
              ref.read(languageProvider.notifier).changeLocale(newLang);
            }
          },
        ),
      ),
    );
  }
}
