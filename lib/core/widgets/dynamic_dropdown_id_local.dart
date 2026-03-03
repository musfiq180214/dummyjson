import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicDropdownIDLocal extends ConsumerWidget {
  final String hint;
  final int? Function(OrderForm) selector;
  final void Function(
    OrderFormNotifier notifier,
    int id,
    String name,
    String? serviceType,
  )
  onUpdate;

  final List<Map<String, dynamic>> items;

  const DynamicDropdownIDLocal({
    super.key,
    required this.hint,
    required this.selector,
    required this.onUpdate,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedValue = ref.watch(orderFormProvider.select(selector));
    final notifier = ref.read(orderFormProvider.notifier);

    final preselectedValue = items.any((e) => e['id'] == selectedValue)
        ? selectedValue
        : null;

    return DropdownButtonFormField<int>(
      isExpanded: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      hint: Text(
        hint,
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      value: preselectedValue,
      items: items
          .map(
            (e) => DropdownMenuItem<int>(
              value: e['id'] as int,
              child: Text(
                getLocalizedText(
                  context: context,
                  en: e['title'],
                  bn: e['title_bn'],
                ),
              ),
            ),
          )
          .toList(),
      onChanged: (val) {
        if (val == null) return;

        final selected = items.firstWhere((e) => e['id'] == val);

        final name = getLocalizedText(
          context: context,
          en: selected['title'],
          bn: selected['title_bn'],
        );

        onUpdate(notifier, val, name, selected['service_type'] ?? "");

        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}
