import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_id.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step3Form extends ConsumerWidget {
  const Step3Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(preRegistrationFormProvider.notifier);
    final permanentDistrictId = ref.watch(
      preRegistrationFormProvider.select((state) => state.permanentDistrictId),
    );

    final currentDistrictId = ref.watch(
      preRegistrationFormProvider.select((state) => state.currentDistrictId),
    );

    final sameAsPermanent = ref.watch(
      preRegistrationFormProvider.select((state) => state.sameAsPermanent),
    );

    final districtDropDownRequest = DropdownRequest(
      endpoint: "ApiEndpoints.districtDropdown",
    );
    final pThanaDropDownRequest = DropdownRequest(
      endpoint: "ApiEndpoints.thanaDropdown",
      queryParameters: {'district_id': permanentDistrictId},
    );
    final cThanaDropDownRequest = DropdownRequest(
      endpoint: "ApiEndpoints.thanaDropdown",
      queryParameters: {'district_id': currentDistrictId},
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Permanent Address (In Bangladesh)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 20),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "District", // Your localized text
                  style: TextStyle(
                    color: Colors.black,
                  ), // or your default text color
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          DynamicDropdownID(
            hint: "District",
            selector: (form) => form.permanentDistrictId,
            onUpdate: (notifier, id, name, _) {
              ref.read(preRegistrationFormProvider).permanentThanaId == null;
              notifier.updatePermanentDistrict(id, name);
            },
            request: districtDropDownRequest,
          ),
          SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Police Station", // Your localized text
                  style: TextStyle(
                    color: Colors.black,
                  ), // or your default text color
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          DynamicDropdownID(
            hint: "Police Station",
            selector: (form) => form.permanentThanaId,
            onUpdate: (notifier, id, name, _) =>
                notifier.updatePermanentThana(id, name),
            request: pThanaDropDownRequest,
          ),
          SizedBox(height: 20),

          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Post Code", // Your localized text
                  style: TextStyle(
                    color: Colors.black,
                  ), // or your default text color
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextInputField(
            provider: preRegistrationFormProvider,
            selector: (form) => form.permanentPostCode,
            hintText: "Post Code",
            onChanged: (code) {
              if (code.isNotEmpty) {
                notifier.updatePermanentPostCode(int.tryParse(code)!);
              }
            },
          ),
          SizedBox(height: 20),

          // Gender
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Address", // Your localized text
                  style: TextStyle(
                    color: Colors.black,
                  ), // or your default text color
                ),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          TextInputField(
            provider: preRegistrationFormProvider,
            selector: (form) => form.permanentAddress,
            hintText: "Address",
            onChanged: notifier.updatePermanentAddress,
          ),

          const SizedBox(height: 10),

          CheckboxListTile(
            value: sameAsPermanent,
            title: const Text("Current address same as permanent"),
            onChanged: (val) => notifier.updateSameAsPermanent(val!),
            controlAffinity: ListTileControlAffinity.leading,
          ),

          // Current Address (if not same as permanent)
          if (!sameAsPermanent) ...[
            SizedBox(height: 20),
            // Gender
            const Text(
              "Current Address (In Bangladesh)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Gender
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "District", // Your localized text
                    style: TextStyle(
                      color: Colors.black,
                    ), // or your default text color
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            DynamicDropdownID(
              hint: "Select District",
              selector: (form) => form.currentDistrictId,
              onUpdate: (notifier, id, name, _) =>
                  notifier.updateCurrentDistrict(id, name),
              request: districtDropDownRequest,
            ),
            SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Police Station",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            DynamicDropdownID(
              hint: "Select Police Station",
              selector: (form) => form.currentThanaId,
              onUpdate: (notifier, id, name, _) =>
                  notifier.updateCurrentThana(id, name),
              request: cThanaDropDownRequest,
            ),
            SizedBox(height: 20),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Post Code", // Your localized text
                    style: TextStyle(
                      color: Colors.black,
                    ), // or your default text color
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextInputField(
              provider: preRegistrationFormProvider,
              selector: (form) => form.currentPostCode,
              hintText: "Post Code",
              onChanged: (code) {
                if (code.isNotEmpty) {
                  notifier.updateCurrentPostCode(int.tryParse(code)!);
                }
              },
            ),
            SizedBox(height: 20),
            // Gender
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Address", // Your localized text
                    style: TextStyle(
                      color: Colors.black,
                    ), // or your default text color
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            TextInputField(
              provider: preRegistrationFormProvider,
              selector: (form) => form.currentAddress,
              hintText: "Address",
              onChanged: notifier.updateCurrentAddress,
            ),
          ],
        ],
      ),
    );
  }
}
