import 'dart:io';
import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/theme/colors.dart';
import 'package:dummyjson/core/utils/helper.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_id.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_string.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/extra_providers.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class Step4Form extends ConsumerWidget {
  const Step4Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(preRegistrationFormProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Type
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Account Type"),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          StringDropdownSelector(
            hint: "Select Owner Type",
            options: ["Self", "Guardian", "Nearest Relative", "Maharam"],
            onChanged: notifier.updateAccountType,
            selector: (form) => form.accountType,
          ),
          const SizedBox(height: 20),

          // Account Holder Name
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Account Holder Name"),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextInputField(
            provider: preRegistrationFormProvider,
            selector: (form) => form.accountHolderName,
            hintText: "Account Holder Name",
            onChanged: notifier.updateAccountHolderName,
          ),
          const SizedBox(height: 20),

          // Account Number
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Account Number"),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextInputField(
            provider: preRegistrationFormProvider,
            selector: (form) => form.accountNumber,
            hintText: "Account Number",
            keyboardType: TextInputType.number,
            onChanged: notifier.updateAccountNumber,
          ),
          const SizedBox(height: 20),

          // Bank Dropdown
          Consumer(
            builder: (context, ref, _) {
              final bankId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankId),
              );
              return DynamicDropdownID(
                hint: "Select Bank",
                selector: (_) => bankId,
                onUpdate: (notifier, id, name, _) =>
                    notifier.updateBankId(id, name),
                request: DropdownRequest(endpoint: "ApiEndpoints.bankDropdown"),
              );
            },
          ),
          const SizedBox(height: 20),

          // Bank District Dropdown
          Consumer(
            builder: (context, ref, _) {
              final bankId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankId),
              );
              final bankDistrictId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankDistrictId),
              );

              if (bankId == null) return const SizedBox.shrink();

              return DynamicDropdownID(
                hint: "Select Bank District",
                selector: (_) => bankDistrictId,
                onUpdate: (notifier, id, name, _) =>
                    notifier.updateBankDistrictId(id, name),
                request: DropdownRequest(
                  endpoint:
                      "${"ApiEndpoints.bankDistrictDropdown"}"
                      "?bank_id=$bankId&is_ref_required=false",
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Bank Branch Dropdown
          Consumer(
            builder: (context, ref, _) {
              final bankId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankId),
              );
              final bankDistrictId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankDistrictId),
              );
              final bankBranchId = ref.watch(
                preRegistrationFormProvider.select((f) => f.bankBranchId),
              );

              if (bankId == null || bankDistrictId == null)
                return const SizedBox.shrink();

              return DynamicDropdownID(
                hint: "Select Bank Branch",
                selector: (_) => bankBranchId,
                onUpdate: (notifier, id, name, _) =>
                    notifier.updateBankBranchId(id, name),
                request: DropdownRequest(
                  endpoint:
                      "${"ApiEndpoints.branchDropdown"}?bank_id=$bankId&district_id=$bankDistrictId",
                ),
              );
            },
          ),
          const SizedBox(height: 20),

          // Profile Photo
          Consumer(
            builder: (context, ref, _) {
              final form = ref.watch(preRegistrationFormProvider);

              Widget buildProfilePhoto() {
                if (form.localProfilePhoto != null) {
                  return Image.file(
                    File(form.localProfilePhoto!.path),
                    fit: BoxFit.cover,
                  );
                } else if (form.serverProfilePhotoUrl != null &&
                    form.serverProfilePhotoUrl!.isNotEmpty) {
                  return Image.network(
                    form.serverProfilePhotoUrl!,
                    fit: BoxFit.cover,
                  );
                } else {
                  return const Center(child: Text("No Photo"));
                }
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Profile Photo"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 150,
                      width: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      child: buildProfilePhoto(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    isExtended: true,
                    elevation: 0.0,
                    onPressed: () async {
                      await ref
                          .read(imagePickerProvider.notifier)
                          .pickFiles(ImageSource.gallery);
                      final file = ref.read(imagePickerProvider);
                      if (file.path.isNotEmpty) {
                        final compressedImage = await getCompressedImage(file);
                        if (compressedImage != null &&
                            compressedImage.path.isNotEmpty) {
                          ref
                              .read(preRegistrationFormProvider.notifier)
                              .updatePhoto(compressedImage);
                        }
                      }
                    },
                    label: Row(
                      children: const [
                        Text("Upload Profile Picture"),
                        SizedBox(width: 12),
                        Icon(Icons.upload_file, color: Colors.white),
                      ],
                    ),
                    backgroundColor: primaryColor,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),

          // Birth Certificate for Minors
          Consumer(
            builder: (context, ref, _) {
              final form = ref.watch(preRegistrationFormProvider);
              if (!form.isMinor) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Birth Certificate Photo"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (form.birthCertificate != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(form.birthCertificate!.path),
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    isExtended: true,
                    elevation: 0.0,
                    onPressed: () async {
                      await ref
                          .read(imagePickerProvider.notifier)
                          .pickFiles(ImageSource.gallery);
                      final file = ref.read(imagePickerProvider);
                      if (file.path.isNotEmpty) {
                        final compressedImage = await getCompressedImage(file);
                        if (compressedImage != null &&
                            compressedImage.path.isNotEmpty) {
                          ref
                              .read(preRegistrationFormProvider.notifier)
                              .updateBirthCertificate(compressedImage);
                        }
                      }
                    },
                    label: Row(
                      children: const [
                        Text("Upload Birth Certificate"),
                        SizedBox(width: 12),
                        Icon(Icons.upload_file, color: Colors.white),
                      ],
                    ),
                    backgroundColor: primaryColor,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
