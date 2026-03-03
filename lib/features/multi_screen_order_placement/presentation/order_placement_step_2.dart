import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/core/utils/logger.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_id.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_string.dart';
import 'package:dummyjson/core/widgets/phone_input.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step2Form extends ConsumerWidget {
  const Step2Form({super.key});

  // Bangla allowed range
  static final _bnRegex = RegExp(r'[\u0980-\u09FF\s]');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderFormProvider.notifier);

    AppLogger.i("Step2 form rebuilt");

    final occupationDropDownRequest = DropdownRequest(
      endpoint: "ApiEndpoints.occupationDropdown",
    );

    final serviceGradeDropDownRequest = DropdownRequest(
      endpoint: "ApiEndpoints.serviceGradeDropdown",
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------
          // Name (Bangla)
          // -------------------------------------------------
          buildLabel("Name (Bangla)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.nameBn,
            hintText: "Name (Bangla)",
            inputLanguage: InputLanguageType.bangla,
            onChanged: (value) {
              notifier.updateNameBn(_filterBangla(value));
            },
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Full Name English
          // -------------------------------------------------
          buildLabel("Full Name (English)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.fullNameEn,
            hintText: "Full Name (English)",
            inputLanguage: InputLanguageType.english,
            onChanged: notifier.updateFullNameEn,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Given Name
          // -------------------------------------------------
          buildLabel("Given Name"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.givenName,
            hintText: "Given Name",
            onChanged: notifier.updateGivenName,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Surname
          // -------------------------------------------------
          buildLabel("Surname"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.surname,
            hintText: "Surname",
            onChanged: notifier.updateSurname,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Father Name Bangla
          // -------------------------------------------------
          buildLabel("Father's Name (Bangla)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.fatherNameBn,
            hintText: "Father's Name (Bangla)",
            inputLanguage: InputLanguageType.bangla,
            onChanged: (value) =>
                notifier.updateFatherNameBn(_filterBangla(value)),
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Father Name English
          // -------------------------------------------------
          buildLabel("Father's Name (English)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.fatherName,
            hintText: "Father's Name (English)",
            inputLanguage: InputLanguageType.english,
            onChanged: notifier.updateFatherName,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Mother Name Bangla
          // -------------------------------------------------
          buildLabel("Mother's Name (Bangla)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.motherNameBn,
            hintText: "Mother's Name (Bangla)",
            inputLanguage: InputLanguageType.bangla,
            onChanged: (value) =>
                notifier.updateMotherNameBn(_filterBangla(value)),
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Mother Name English
          // -------------------------------------------------
          buildLabel("Mother's Name (English)"),
          const SizedBox(height: 10),
          TextInputField(
            provider: orderFormProvider,
            selector: (form) => form.motherName,
            hintText: "Mother's Name (English)",
            inputLanguage: InputLanguageType.english,
            onChanged: notifier.updateMotherName,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Occupation
          // -------------------------------------------------
          // buildLabel("Occupation"),
          // const SizedBox(height: 10),
          // DynamicDropdownID(
          //   hint: "Select Occupation",
          //   selector: (form) => form.occupationId,
          //   onUpdate: (notifier, id, name, serviceType) =>
          //       notifier.updateOccupation(id, name, serviceType!),
          //   request: occupationDropDownRequest,
          // ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Service Grade + Designation (Government only)
          // -------------------------------------------------
          Consumer(
            builder: (context, ref, _) {
              final serviceType = ref
                  .watch(orderFormProvider.select((f) => f.serviceType))
                  ?.toLowerCase();

              if (serviceType != "government") return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DynamicDropdownID(
                    hint: "Service Grade",
                    selector: (form) => form.serviceGradeId,
                    onUpdate: (notifier, id, name, _) =>
                        notifier.updateServiceGrade(id, name),
                    request: serviceGradeDropDownRequest,
                  ),
                  const SizedBox(height: 10),
                  TextInputField(
                    provider: orderFormProvider,
                    selector: (form) => form.designationName ?? "",
                    hintText: "Designation",
                    onChanged: notifier.updateDesignation,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Phone
          // -------------------------------------------------
          buildLabel("Phone"),
          const SizedBox(height: 10),
          PhoneInputField(
            provider: orderFormProvider,
            selector: (form) => form.mobile,
            hintText: "Phone",
            showCountryCode: true,
            allowLeadingZero: false,
            onChanged: notifier.updateMobile,
          ),
          const SizedBox(height: 20),

          // -------------------------------------------------
          // Marital Status
          // -------------------------------------------------
          buildLabel("Marital Status"),
          const SizedBox(height: 10),
          StringDropdownSelector(
            hint: "Select Marital Status",
            options: const ["Single", "Married"],
            selector: (form) => form.maritalStatus,
            onChanged: notifier.updateMaritalStatus,
          ),
          const SizedBox(height: 10),

          // Spouse Name (conditional)
          Consumer(
            builder: (context, ref, _) {
              final status = ref.watch(
                orderFormProvider.select((f) => f.maritalStatus),
              );

              if (status != "Married") return const SizedBox();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildLabel("Spouse Name"),
                  const SizedBox(height: 10),
                  TextInputField(
                    provider: orderFormProvider,
                    selector: (form) => form.spouseName,
                    hintText: "Spouse Name",
                    onChanged: notifier.updateSpouseName,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  static String _filterBangla(String value) {
    return value.replaceAll(RegExp(r'[^\u0980-\u09FF\s]'), '');
  }

  Widget buildLabel(String text) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: const TextStyle(color: Colors.black),
          ),
          const TextSpan(
            text: " *",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
