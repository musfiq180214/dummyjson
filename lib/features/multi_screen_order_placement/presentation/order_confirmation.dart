import 'package:dummyjson/features/multi_screen_order_placement/provider/order_placement_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Step5Preview extends ConsumerWidget {
  final void Function(int step) onEditStep;

  const Step5Preview({super.key, required this.onEditStep});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(orderFormProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Review",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Step 0: General Info
          buildStepHeader("Step 1: General Info", onEdit: () => onEditStep(1)),
          buildPreviewRow("Registration Type", form.registrationType),
          buildPreviewRow("Resident Type", form.residentType),
          if (form.residentType.toLowerCase() == 'nrb')
            buildPreviewRow("Country", form.nationalityName ?? ""),
          buildPreviewRow("Gender", form.gender),
          buildPreviewRow("DOB", "${form.dd}-${form.mm}-${form.yyyy}"),
          buildPreviewRow("Identity Type", form.identityType),
          if (form.identityType.toLowerCase() == 'passport')
            buildPreviewRow("Passport Type", form.passportType),
          // buildPreviewRow("Identity Number", form.identityNumber),
          if (form.isMinor)
            buildPreviewRow(
              "Guardian's Tracking Number",
              form.guardianTrackingNo,
            ),
          if (form.isMinor)
            buildPreviewRow("Guardian's Name", form.guardianName),

          const SizedBox(height: 20),
          // Step 2: Personal Info
          buildStepHeader("Step 2: Personal Info", onEdit: () => onEditStep(2)),
          buildPreviewRow("Name (Bangla)", form.nameBn),
          buildPreviewRow("Full Name (EN)", form.fullNameEn),
          buildPreviewRow("Given Name", form.givenName),
          buildPreviewRow("Surname", form.surname),
          buildPreviewRow("Father Name", form.fatherName),
          buildPreviewRow("Father Name (Bangla)", form.fatherNameBn),
          buildPreviewRow("Mother Name", form.motherName),
          buildPreviewRow("Mother Name (Bangla)", form.motherNameBn),
          buildPreviewRow("Mobile", "+880${form.mobile}"),
          buildPreviewRow("Marital Status", form.maritalStatus),
          if (form.maritalStatus.toLowerCase() == 'married')
            buildPreviewRow("Spouse Name", form.spouseName),

          // buildPreviewRow("Occupation", form.occupationName ?? ""),
          // if (form.occupationName?.toLowerCase() == "govt.")
          //   buildPreviewRow("Service Grade", form.serviceGradeName ?? ""),
          // if (form.occupationName?.toLowerCase() == "govt.")
          //   buildPreviewRow("Designation", form.designationName ?? ""),
          buildPreviewRow("Occupation", form.occupationName ?? ""),
          if ((form.occupationName ?? "").contains("GOVERNMENT")) ...[
            buildPreviewRow("Service Grade", form.serviceGradeName ?? ""),
            buildPreviewRow("Designation", form.designationName ?? ""),
          ],

          const SizedBox(height: 20),
          // Step 3: Address Info
          buildStepHeader("Step 3: Address Info", onEdit: () => onEditStep(3)),
          buildPreviewRow(
            "Permanent Address (In Bangladesh)",
            "${form.permanentAddress}, ${form.permanentThanaName ?? ""}, ${form.permanentDistrictName ?? ""}, ${form.permanentPostCode ?? ""}",
          ),
          buildPreviewRow(
            "Current Address (In Bangladesh)",
            form.sameAsPermanent
                ? "Same as Permanent"
                : "${form.currentAddress}, ${form.currentThanaName ?? ""}, ${form.currentDistrictName ?? ""}, ${form.currentPostCode ?? ""}",
          ),

          const SizedBox(height: 20),
          // Step 4: Bank & Photo
          buildStepHeader("Step 4: Bank & Photo", onEdit: () => onEditStep(4)),
          buildPreviewRow("Account Type", form.accountType),
          buildPreviewRow("Account Holder Name", form.accountHolderName),
          buildPreviewRow("Account Number", form.accountNumber),
          buildPreviewRow("Bank Name", form.bankName ?? ""),
          buildPreviewRow("Branch Name", form.branchName ?? ""),
          buildPreviewRow("Branch District", form.bankDistrictName ?? ""),
          /*   buildPreviewRow("Photo Path", form.profilePhoto?.path??""),
          if (form.birthCertificate != null)
            buildPreviewRow(
                "Birth Certificate Path", form.birthCertificate?.path ?? ""), */
        ],
      ),
    );
  }

  Widget buildStepHeader(String title, {required VoidCallback onEdit}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  Widget buildPreviewRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text("$title:")),
          Expanded(flex: 5, child: Text(value)),
        ],
      ),
    );
  }
}
