import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StringDropdownSelector extends ConsumerWidget {
  final String? hint;
  final List<String> options;
  final void Function(String) onChanged;
  final String Function(PreRegistrationForm) selector;

  const StringDropdownSelector({
    super.key,
    required this.options,
    required this.onChanged,
    required this.selector,
    this.hint,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Only watch the specific string field
    final value = ref.watch(preRegistrationFormProvider.select(selector));

    return DropdownButtonFormField<String>(
      initialValue: value.isNotEmpty ? value : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      hint: hint != null
          ? Text(
              hint!,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            )
          : null,
      items: options
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (val) {
        if (val != null) onChanged(val);
      },
    );
  }
}
