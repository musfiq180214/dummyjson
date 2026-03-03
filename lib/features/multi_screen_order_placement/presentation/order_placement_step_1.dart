import 'package:dummyjson/core/constants/urls.dart';
import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:dummyjson/core/widgets/dynamic_dropdown_id.dart';
import 'package:dummyjson/core/widgets/radio.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/drop_down_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:dummyjson/features/multi_screen_order_placement/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step1Form extends ConsumerWidget {
  const Step1Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(orderFormProvider.notifier);
    final selectedMedium = ref.watch(orderFormProvider.select((s) => s.medium));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Registration Type
          Consumer(
            builder: (context, ref, _) {
              final registrationType = ref.watch(
                orderFormProvider.select((s) => s.registrationType),
              );
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Order Type"),
                        // TextSpan(
                        //     text: ' *', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox.adaptive(
                        value: registrationType == "self",
                        onChanged: (val) async {
                          if (val != null) {
                            notifier.updateRegistrationType(val);
                          }
                          if (val!) {
                            final phone = await ref
                                .read(secureStorageProvider)
                                .read(key: 'lastLoggedInPhone');
                            if (phone != null) {
                              notifier.updateMobile(phone);
                            }
                          } else {
                            notifier.updateMobile('');
                          }
                        },
                      ),
                      const Text("Self"),
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Medium"),
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: ["Government", "Private"].map((e) {
              return Expanded(
                child: RoundedRadioGroup<String>(
                  selectedValue: selectedMedium,
                  options: [RadioOption(label: e, value: e)],
                  onChanged: (val) => notifier.updateMedium(val),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
          // Resident Type Radio
          Consumer(
            builder: (context, ref, _) {
              final residentType = ref.watch(
                orderFormProvider.select((s) => s.residentType),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Resident Type"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ["Bangladeshi", "NRB"].map((e) {
                      return Expanded(
                        child: RoundedRadioGroup<String>(
                          selectedValue: residentType,
                          options: [RadioOption(label: e, value: e)],
                          onChanged: (val) => notifier.updateResidentType(val),
                        ),
                      );
                    }).toList(),
                  ),
                  if (residentType == "NRB") ...[
                    SizedBox(height: 10),
                    Consumer(
                      builder: (context, ref, child) {
                        final nationalityId = ref.watch(
                          orderFormProvider.select((s) => s.nationalityId),
                        );

                        final nationalityDropDownRequest = DropdownRequest(
                          endpoint: "ApiEndpoints.nationalityDropdown",
                        );

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(text: "Country"),
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            DynamicDropdownID(
                              hint: "Country",
                              selector: (form) => nationalityId,
                              onUpdate: (notifier, id, name, _) =>
                                  notifier.updateNationality(id, name),
                              request: nationalityDropDownRequest,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ],
              );
            },
          ),

          SizedBox(height: 20),

          // Gender Radio
          Consumer(
            builder: (context, ref, _) {
              final gender = ref.watch(
                orderFormProvider.select((s) => s.gender),
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Gender"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: ["Male", "Female"].map((e) {
                      return Expanded(
                        child: RoundedRadioGroup<String>(
                          selectedValue: gender,
                          options: [RadioOption(label: e, value: e)],
                          onChanged: (val) => notifier.updateGender(val),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Date of Birth
          Consumer(
            builder: (context, ref, _) {
              final form = ref.watch(orderFormProvider);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Date of Birth"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final initialDate = DateTime.now().subtract(
                        const Duration(days: 365 * 18),
                      );
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: form.yyyy.isNotEmpty
                            ? DateTime(
                                int.parse(form.yyyy),
                                int.parse(form.mm),
                                int.parse(form.dd),
                              )
                            : initialDate,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (selectedDate != null) {
                        notifier.updateDD(
                          selectedDate.day.toString().padLeft(2, '0'),
                        );
                        notifier.updateMM(
                          selectedDate.month.toString().padLeft(2, '0'),
                        );
                        notifier.updateYYYY(selectedDate.year.toString());
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade400,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        form.dd.isNotEmpty &&
                                form.mm.isNotEmpty &&
                                form.yyyy.isNotEmpty
                            ? "${form.dd}-${form.mm}-${form.yyyy}"
                            : "Select Date of Birth",
                        style: TextStyle(
                          color: form.dd.isNotEmpty
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          // Identity Type
          Consumer(
            builder: (context, ref, child) {
              final isMinor = ref.watch(
                orderFormProvider.select((state) => state.isMinor),
              );
              final identityType = ref.watch(
                orderFormProvider.select((s) => s.identityType),
              );
              final passportType = ref.watch(
                orderFormProvider.select((s) => s.passportType),
              );
              final passportCategory = ref.watch(
                orderFormProvider.select((s) => s.passportCategory),
              );
              final passportIssueDate = ref.watch(
                orderFormProvider.select((s) => s.passportIssueDate),
              );
              final passportExpiryDate = ref.watch(
                orderFormProvider.select((s) => s.passportExpiryDate),
              );
              final nid = ref.watch(orderFormProvider.select((s) => s.nid));
              final passportNumber = ref.watch(
                orderFormProvider.select((s) => s.passportNo),
              );
              final birthCertificateNo = ref.watch(
                orderFormProvider.select((s) => s.birthCertificateNo),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Identity Type
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(text: "Identity Type"),
                        TextSpan(
                          text: ' *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children:
                        (!isMinor
                                ? ["Passport", "Nid"]
                                : ["Passport", "Birth Certificate"])
                            .map(
                              (e) => Expanded(
                                child: RoundedRadioGroup<String>(
                                  selectedValue: identityType,
                                  options: [RadioOption(label: e, value: e)],
                                  onChanged: (val) =>
                                      notifier.updateIdentityType(val),
                                ),
                              ),
                            )
                            .toList(),
                  ),

                  // Passport Type (only if Passport is selected)
                  if (identityType == 'Passport') ...[
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Passport Type"),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ["E-Passport", "MRP"]
                          .map(
                            (e) => Expanded(
                              child: RoundedRadioGroup<String>(
                                selectedValue: passportType,
                                options: [RadioOption(label: e, value: e)],
                                onChanged: (val) =>
                                    notifier.updatePassportType(val),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Passport Category"),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ["Ordinary", "Official", "Diplomatic"]
                          .map(
                            (e) => Expanded(
                              child: RoundedRadioGroup<String>(
                                selectedValue: passportCategory,
                                options: [RadioOption(label: e, value: e)],
                                onChanged: (val) =>
                                    notifier.updatePassportCategory(val),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Passport Issued Date"),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (selectedDate != null) {
                          notifier.updatePassportIssueDate(
                            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          passportIssueDate.isNotEmpty
                              ? passportIssueDate
                              : "Select Date",
                          style: TextStyle(
                            color: passportIssueDate.isNotEmpty
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: "Passport Expiry Date"),
                          TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(3000),
                        );
                        if (selectedDate != null) {
                          notifier.updatePassportExpiryDate(
                            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          passportExpiryDate.isNotEmpty
                              ? passportExpiryDate
                              : "Select Date",
                          style: TextStyle(
                            color: passportExpiryDate.isNotEmpty
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],

                  if (identityType.isNotEmpty) ...[
                    // 🛂 Passport Type
                    if (identityType.toLowerCase() == "passport") ...[
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: const [
                            TextSpan(text: "Passport Number"),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextInputField(
                        initialValue: passportNumber,
                        hintText: "Passport Number",
                        onChanged: notifier.updatePassportNo,
                        provider: orderFormProvider,
                        selector: (form) => form.passportNo,
                      ),

                      // Show NID if not minor, otherwise Birth Certificate
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: isMinor
                                  ? "Birth Certificate Number"
                                  : "NID Number",
                            ),
                            const TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextInputField(
                        initialValue: isMinor ? birthCertificateNo : nid,
                        hintText: isMinor
                            ? "Birth Certificate Number"
                            : "NID Number",
                        onChanged: (value) {
                          if (isMinor) {
                            notifier.updateBirthCertificateNo(value);
                          } else {
                            notifier.updateNid(value);
                          }
                        },
                        provider: orderFormProvider,
                        selector: (form) =>
                            isMinor ? form.birthCertificateNo : form.nid,
                      ),
                    ]
                    // 🪪 NID Type
                    else if (identityType.toLowerCase() == "nid") ...[
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: const [
                            TextSpan(text: "NID Number"),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextInputField(
                        initialValue: nid,
                        hintText: "NID Number",
                        onChanged: notifier.updateNid,
                        provider: orderFormProvider,
                        selector: (form) => form.nid,
                      ),
                    ]
                    // Birth Certificate Type
                    else if (identityType.toLowerCase() ==
                        "birth certificate") ...[
                      const SizedBox(height: 20),
                      Text.rich(
                        TextSpan(
                          children: const [
                            TextSpan(text: "Birth Certificate Number"),
                            TextSpan(
                              text: ' *',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextInputField(
                        initialValue: birthCertificateNo,
                        hintText: "Birth Certificate Number",
                        onChanged: notifier.updateBirthCertificateNo,
                        provider: orderFormProvider,
                        selector: (form) => form.birthCertificateNo,
                      ),
                    ],
                  ],
                ],
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final isMinor = ref.watch(
                orderFormProvider.select((state) => state.isMinor),
              );
              final guardianNumber = ref.watch(
                orderFormProvider.select((s) => s.guardianTrackingNo),
              );
              final gender = ref.watch(
                orderFormProvider.select((s) => s.gender),
              );

              // Show guardian if minor OR female
              if (isMinor) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Guardian Tracking Number",
                            style: TextStyle(color: Colors.black),
                          ),
                          const TextSpan(
                            text: ' *',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextInputField(
                      initialValue: guardianNumber,
                      hintText: "Guardian Tracking Number",
                      onChanged: notifier.updateGuardianTrackingNo,
                      provider: orderFormProvider,
                      selector: (form) => form.guardianTrackingNo,
                    ),
                    const SizedBox(height: 10),
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: "Mahram Relation", // Your localized text
                    //         style: TextStyle(
                    //           color: Colors.black,
                    //         ), // or your default text color
                    //       ),
                    //       TextSpan(
                    //         text: ' *',
                    //         style: TextStyle(color: Colors.red),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    // DynamicDropdownID(
                    //   hint: "Mahram Relation",
                    //   selector: (form) => form.guardianRelationId,
                    //   onUpdate: (notifier, id, name, serviceType) =>
                    //       notifier.updateGuardianRelation(id),
                    //   request: mahramDropDownRequest,
                    // ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
