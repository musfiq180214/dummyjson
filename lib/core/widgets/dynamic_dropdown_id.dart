// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:labbayk/core/utils/helper.dart';
// import 'package:labbayk/features/pre_registration/domain/pre_registration_model.dart';
// import 'package:labbayk/features/pre_registration/providers/drop_down_provider.dart';
// import 'package:labbayk/features/pre_registration/providers/pre_registration_provider.dart';

// class DynamicDropdownID extends ConsumerWidget {
//   final String hint;
//   final int? Function(PreRegistrationForm) selector;
//   final void Function(PreRegistrationFormNotifier notifier, int id, String name,
//       String? serviceType) onUpdate;
//   final DropdownRequest request;

//   const DynamicDropdownID({
//     super.key,
//     required this.hint,
//     required this.selector,
//     required this.onUpdate,
//     required this.request,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final value = ref.watch(
//       preRegistrationFormProvider.select(selector),
//     );
//     final notifier = ref.read(preRegistrationFormProvider.notifier);
//     final asyncDropdown = ref.watch(dropdownDataProvider(request));

//     return asyncDropdown.when(
//       data: (data) => DropdownButtonFormField<int>(
//         isExpanded: true,
//         decoration: InputDecoration(
//           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//         ),
//         initialValue: value,
//         hint: Text(hint, style: TextStyle(fontSize: 14, color: Colors.grey)),
//         items: data
//             .map((e) => DropdownMenuItem<int>(
//                   value: e['id'] as int,
//                   child: Text(getLocalizedText(
//                     context: context,
//                     en: e['title'],
//                     bn: e['title_bn'],
//                   )),
//                 ))
//             .toList(),
//         onChanged: (val) {
//           if (val == null) return;
//           final selected = data.firstWhere((e) => e['id'] == val);
//           final name = getLocalizedText(
//             context: context,
//             en: selected['title'],
//             bn: selected['title_bn'],
//           );
//           onUpdate(notifier, val, name, selected['service_type'] ?? "");
//           if (FocusManager.instance.primaryFocus != null &&
//               FocusManager.instance.primaryFocus!.hasFocus) {
//             FocusManager.instance.primaryFocus!.unfocus();
//           }
//         },
//       ),
//       error: (err, _) => Text(err.toString()),
//       loading: () => const Center(child: CircularProgressIndicator()),
//     );
//   }
// }

import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynamicDropdownID extends ConsumerWidget {
  final String hint;
  final int? Function(OrderForm) selector;
  final void Function(
    OrderFormNotifier notifier,
    int id,
    String name,
    String? serviceType,
  )
  onUpdate;
  final DropdownRequest request;

  const DynamicDropdownID({
    super.key,
    required this.hint,
    required this.selector,
    required this.onUpdate,
    required this.request,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedValue = ref.watch(orderFormProvider.select(selector));
    final notifier = ref.read(orderFormProvider.notifier);
    final asyncDropdown = ref.watch(dropdownDataProvider(request));

    return asyncDropdown.when(
      data: (data) {
        // Ensure initial value exists in the dropdown items
        final preselectedValue = data.any((e) => e['id'] == selectedValue)
            ? selectedValue
            : null;

        return DropdownButtonFormField<int>(
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: Text(hint, style: TextStyle(fontSize: 14, color: Colors.grey)),
          value: preselectedValue,
          items: data
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
            final selected = data.firstWhere((e) => e['id'] == val);
            final name = getLocalizedText(
              context: context,
              en: selected['title'],
              bn: selected['title_bn'],
            );
            onUpdate(notifier, val, name, selected['service_type'] ?? "");
            // Unfocus after selection
            if (FocusManager.instance.primaryFocus?.hasFocus ?? false) {
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text(err.toString()),
    );
  }
}
