import 'package:dio/dio.dart';
import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/core/utils/custom_dialog.dart';
import 'package:dummyjson/core/utils/enums.dart';
import 'package:dummyjson/features/multi_screen_order_placement/data/order_repository.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_details.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/order_response.dart';
import 'package:dummyjson/features/multi_screen_order_placement/domain/pilgrim.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/logger.dart';

class PreRegistrationFormNotifier extends StateNotifier<PreRegistrationForm> {
  final Ref? ref;

  PreRegistrationFormNotifier({this.ref}) : super(PreRegistrationForm());

  // Step 1
  void updateRegistrationType(bool val) {
    state = state.copyWith(registrationType: val ? "self" : "others");
  }

  void updateMedium(String val) => state = state.copyWith(medium: val);

  void updateNationality(int id, String name) =>
      state = state.copyWith(nationalityId: id, nationalityName: name);

  void updateOccupation(
    int id,
    String name,
    String serviceType, {
    bool reset = true,
  }) {
    state = state.copyWith(
      occupationId: id,
      occupationName: name,
      serviceType: serviceType,

      // If reset==true → reset dependent fields (user changed occupation manually)
      // If reset==false → KEEP previous saved values (edit mode)
      serviceGradeId: reset ? null : state.serviceGradeId,
      serviceGradeName: reset ? null : state.serviceGradeName,
      designationName: reset ? null : state.designationName,
    );
  }

  void updateServiceGrade(int id, String name) =>
      state = state.copyWith(serviceGradeId: id, serviceGradeName: name);

  void updateDesignation(String name) =>
      state = state.copyWith(designationName: name);

  void updateGuardianTrackingNo(String val) =>
      state = state.copyWith(guardianTrackingNo: val);

  void updateGuardianName(String val) =>
      state = state.copyWith(guardianName: val);

  void updateGuardianRelation(int val) =>
      state = state.copyWith(guardianRelationId: val);

  // Step 2
  void updateResidentType(String val) => state = state.copyWith(
    residentType: val,
    resetNationality: true,
    resetNationalityId: true,
  );

  void updateGender(String val) => state = state.copyWith(gender: val);

  void updateDD(String val) => state = state.copyWith(
    dd: val,
    identityType: "",
    passportType: "",
    nid: "",
    passportNo: "",
    birthCertificateNo: "",
  );

  void updateMM(String val) => state = state.copyWith(
    mm: val,
    identityType: "",
    passportType: "",
    nid: "",
    passportNo: "",
    birthCertificateNo: "",
  );

  void updateYYYY(String val) => state = state.copyWith(
    yyyy: val,
    identityType: "",
    passportType: "",
    nid: "",
    passportNo: "",
    birthCertificateNo: "",
  );

  void updateIdentityType(String val) =>
      state = state.copyWith(identityType: val);

  void updatePassportType(String val) =>
      state = state.copyWith(passportType: val);

  void updatePassportCategory(String val) =>
      state = state.copyWith(passportCategory: val);

  void updatePassportIssueDate(String val) =>
      state = state.copyWith(passportIssueDate: val);

  void updatePassportExpiryDate(String val) =>
      state = state.copyWith(passportExpiryDate: val);

  void updateNid(String val) => state = state.copyWith(nid: val);

  void updatePassportNo(String val) => state = state.copyWith(passportNo: val);

  void updateBirthCertificateNo(String val) =>
      state = state.copyWith(birthCertificateNo: val);

  // Step 3
  void updateNameBn(String val) => state = state.copyWith(nameBn: val);

  void updateFullNameEn(String val) => state = state.copyWith(fullNameEn: val);

  void updateGivenName(String val) => state = state.copyWith(givenName: val);

  void updateSurname(String val) => state = state.copyWith(surname: val);

  void updateFatherName(String val) => state = state.copyWith(fatherName: val);

  void updateFatherNameBn(String val) =>
      state = state.copyWith(fatherNameBn: val);

  void updateMotherName(String val) => state = state.copyWith(motherName: val);

  void updateMotherNameBn(String val) =>
      state = state.copyWith(motherNameBn: val);

  void updateMobile(String val) => state = state.copyWith(mobile: val);

  void updateMaritalStatus(String val) =>
      state = state.copyWith(maritalStatus: val);

  void updateSpouseName(String val) => state = state.copyWith(spouseName: val);

  // Step 4
  void updatePermanentPostCode(int val) => state = state.copyWith(
    permanentPostCode: val,
    currentPostCode: state.sameAsPermanent ? val : state.currentPostCode,
  );

  void updatePermanentDistrict(int id, String name) => state = state.copyWith(
    permanentDistrictId: id,
    permanentDistrictName: name,
    resetPermanentThanaID: true,
    resetPermanentThanaName: true,
    currentDistrictId: state.sameAsPermanent ? id : state.currentDistrictId,
    currentDistrictName: state.sameAsPermanent
        ? name
        : state.currentDistrictName,
    resetCurrentThanaID: state.sameAsPermanent ? true : false,
    resetCurrentThanaName: state.sameAsPermanent ? true : false,
  );

  void updatePermanentThana(int id, String name) => state = state.copyWith(
    permanentThanaId: id,
    permanentThanaName: name,
    currentThanaId: state.sameAsPermanent ? id : state.currentThanaId,
    currentThanaName: state.sameAsPermanent ? name : state.currentThanaName,
  );

  void updatePermanentAddress(String val) => state = state.copyWith(
    permanentAddress: val,
    currentAddress: state.sameAsPermanent ? val : state.currentAddress,
  );

  void updateSameAsPermanent(bool val) {
    if (val) {
      state = state.copyWith(
        sameAsPermanent: true,
        currentPostCode: state.permanentPostCode,
        currentDistrictId: state.permanentDistrictId,
        currentDistrictName: state.permanentDistrictName,
        currentThanaId: state.permanentThanaId,
        currentThanaName: state.permanentThanaName,
        currentAddress: state.permanentAddress,
      );
    } else {
      state = state.copyWith(sameAsPermanent: false);
    }
  }

  void updateCurrentPostCode(int val) =>
      state = state.copyWith(currentPostCode: val);

  void updateCurrentDistrict(int id, String name) => state = state.copyWith(
    currentDistrictId: id,
    currentDistrictName: name,
    resetCurrentThanaID: true,
    resetCurrentThanaName: true,
  );

  void updateCurrentThana(int id, String name) =>
      state = state.copyWith(currentThanaId: id, currentThanaName: name);

  void updateCurrentAddress(String val) =>
      state = state.copyWith(currentAddress: val);

  // Step 5
  void updateAccountType(String val) =>
      state = state.copyWith(accountType: val);

  void updateAccountHolderName(String val) =>
      state = state.copyWith(accountHolderName: val);

  void updateAccountNumber(String val) =>
      state = state.copyWith(accountNumber: val);

  void updateBankId(int id, String name) => state = state.copyWith(
    bankId: id,
    bankName: name,
    resetBankDistrictID: false,
    resetBankDistrictName: false,
  );

  void updateBankBranchId(int id, String name) =>
      state = state.copyWith(bankBranchId: id, branchName: name);

  void updateBankDistrictId(int id, String name) => state = state.copyWith(
    bankDistrictId: id,
    bankDistrictName: name,
    resetBankBranchID: false,
    resetBankBranchName: false,
  );

  void updatePhoto(XFile val) {
    state = state.copyWith(localProfilePhoto: val);
  }

  void updateBirthCertificate(XFile val) =>
      state = state.copyWith(birthCertificate: val);

  Future<(bool, String?)> validateStep1(BuildContext context) async {
    AppLogger.i("=== Step 1 Current State ===");
    AppLogger.i("Registration Type: ${state.registrationType}");
    AppLogger.i("Medium: ${state.medium}");
    AppLogger.i("Resident Type: ${state.residentType}");
    AppLogger.i("Nationality ID: ${state.nationalityId}");
    AppLogger.i("Gender: ${state.gender}");
    AppLogger.i("DOB: ${state.dd}-${state.mm}-${state.yyyy}");
    AppLogger.i("Identity Type: ${state.identityType}");
    AppLogger.i("Passport Number: ${state.passportNo}");
    AppLogger.i("Passport Type: ${state.passportType}");
    AppLogger.i("Passport Category: ${state.passportCategory}");
    AppLogger.i("Passport Issue Date: ${state.passportIssueDate}");
    AppLogger.i("Passport Expiry Date: ${state.passportExpiryDate}");
    AppLogger.i("NID: ${state.nid}");
    AppLogger.i("Birth Certificate No: ${state.birthCertificateNo}");
    AppLogger.i("Is Minor: ${state.isMinor}");
    AppLogger.i("Guardian Tracking No: ${state.guardianTrackingNo}");
    AppLogger.i("Guardian Relation ID: ${state.guardianRelationId}");
    AppLogger.i("=============================");
    if (state.registrationType.isEmpty) {
      return (false, "Registration type is required");
    }
    if (state.medium.isEmpty) return (false, "Medium is required");
    if (state.residentType.isEmpty) return (false, "Resident type is required");
    if (state.residentType == "NRB" && state.nationalityId == null) {
      return (false, "Nationality is required for NRB");
    }
    if (state.gender.isEmpty) return (false, "Gender is required");
    if (state.dd.isEmpty) return (false, "Date of birth is required");
    if (state.identityType.isEmpty) return (false, "Identity type is required");

    if (state.identityType == "Passport") {
      if (state.passportNo.isEmpty) {
        return (false, "Passport number is required");
      }

      final passport = state.passportNo;

      if (!RegExp(r'^[A-Z]').hasMatch(passport)) {
        return (false, "Passport must start with a capital letter");
      }

      if (passport.length != 9) {
        return (false, "Passport must be exactly 9 characters long");
      }

      if (!RegExp(r'^[A-Z][0-9]{8}$').hasMatch(passport)) {
        return (
          false,
          "Passport format must be: 1 capital letter followed by 8 digits",
        );
      }

      if (state.passportType.isEmpty) {
        return (false, "Passport type is required");
      }
      if (state.passportCategory.isEmpty) {
        return (false, "Passport category is required");
      }
      if (state.passportIssueDate.isEmpty) {
        return (false, "Passport issue date is required");
      }
      if (state.passportExpiryDate.isEmpty) {
        return (false, "Passport expiry date is required");
      }
      if (state.isMinor) {
        if (state.birthCertificateNo.isEmpty) {
          return (false, "Birth certificate number is required");
        }
      }
      if (!state.isMinor) {
        if (state.nid.isEmpty) {
          return (false, "NID is required");
        }
      }
    }

    if (state.identityType == "NID") {
      if (state.nid.isEmpty) return (false, "NID is required");
    }
    if (state.identityType == "Birth Certificate") {
      if (state.birthCertificateNo.isEmpty) {
        return (false, "Birth certificate number is required");
      }
    }

    // if (state.isMinor) {
    //   if (state.guardianRelationId == null) {
    //     return (false, "Guardian relation is required");
    //   }
    // }

    // if (state.isMinor) {
    //   final repo = ref!.read(preRegRepoProvider);
    //   final isValidGuardian = await repo.verifyGuardian(
    //     trackingNumber: state.guardianTrackingNo,
    //   );

    //   showCustomDialog(
    //     context,
    //     type: MessageType.success,
    //     title: "Guardian Name",
    //     message: isValidGuardian['name'],
    //   );
    //   state = state.copyWith(guardianName: isValidGuardian['name']);
    //   return (true, null);
    // }

    return (true, null);
  }

  Future<(bool, String?)> validateStep2(BuildContext context) async {
    AppLogger.i("NID: ${state.fatherName}");
    AppLogger.i("Birth Certificate No: ${state.fatherNameBn}");
    AppLogger.i("Is Minor: ${state.motherName}");
    AppLogger.i("Guardian Tracking No: ${state.motherNameBn}");
    if (state.nameBn.isEmpty) return (false, "Bangla name is required");
    if (state.fullNameEn.isEmpty) {
      return (false, "Full English name is required");
    }
    if (state.givenName.isEmpty) return (false, "Given name is required");
    if (state.surname.isEmpty) return (false, "Surname is required");
    if (state.fatherNameBn.isEmpty) return (false, "Father's name is required");
    if (state.motherNameBn.isEmpty) return (false, "Mother's name is required");
    if (state.mobile.isEmpty) return (false, "Phone number is required");
    // if (state.occupationName == null) return (false, "Occupation is required");
    if (state.serviceType == 'government' && state.serviceGradeName == null) {
      return (false, "Service grade is required for government employees");
    }
    if (state.serviceType == 'government' && state.designationName == null) {
      return (false, "Designation is required for government employees");
    }
    if (state.maritalStatus.isEmpty) {
      return (false, "Marital status is required");
    }
    if (state.maritalStatus == "Married" && state.spouseName.trim().isEmpty) {
      return (false, "Spouse name is required for married applicants");
    }

    return (true, null);
  }

  Future<(bool, String?)> validateStep3() async {
    if (state.permanentPostCode == null) {
      return (false, "Permanent post code is required");
    }
    if (state.permanentDistrictId == null) {
      return (false, "Permanent district is required");
    }
    if (state.permanentThanaId == null) {
      return (false, "Permanent thana is required");
    }
    if (state.permanentAddress.isEmpty) {
      return (false, "Permanent address is required");
    }
    if (state.currentAddress.isEmpty) {
      return (false, "Current address is required");
    }
    if (state.currentPostCode == null) {
      return (false, "Current post code is required");
    }
    if (state.currentDistrictId == null) {
      return (false, "Current district is required");
    }
    if (state.currentThanaId == null) {
      return (false, "Current thana is required");
    }
    return (true, null);
  }

  Future<(bool, String?)> validateStep4() async {
    if (state.accountType.isEmpty) return (false, "Account type is required");
    if (state.accountHolderName.isEmpty) {
      return (false, "Account holder name is required");
    }
    if (state.accountNumber.isEmpty) {
      return (false, "Account number is required");
    }
    if (!RegExp(r'^[0-9]{13}$').hasMatch(state.accountNumber)) {
      return (false, "Account number must be exactly 13 digits");
    }
    if (state.bankId == null) return (false, "Bank name is required");
    if (state.bankBranchId == null) return (false, "Bank branch is required");
    if (state.bankDistrictId == null) {
      return (false, "Bank district is required");
    }
    if (state.isMinor && state.birthCertificate == null) {
      return (false, "Birth certificate is required for minors");
    }
    if (state.localProfilePhoto == null &&
        (state.serverProfilePhotoUrl == null ||
            state.serverProfilePhotoUrl!.isEmpty)) {
      return (false, "Profile photo is required");
    }

    return (true, null);
  }

  void reset() {
    state = PreRegistrationForm();
  }

  Future<void> loadPresetValues(PreRegistrationForm preset) async {
    state = state.copyWith(
      registrationType: preset.registrationType.toLowerCase(),
      medium: preset.medium == "government" ? "Government" : "Private",
      residentType: preset.residentType,
      nationalityId: preset.nationalityId,
      nationalityName: preset.nationalityName,
      gender: preset.gender,
      dd: preset.dd,
      mm: preset.mm,
      yyyy: preset.yyyy,
      identityType: preset.identityType,
      passportType: preset.passportType,
      passportCategory: preset.passportCategory,
      passportIssueDate: preset.passportIssueDate,
      passportExpiryDate: preset.passportExpiryDate,
      nid: preset.nid,
      passportNo: preset.passportNo,
      birthCertificateNo: preset.birthCertificateNo,
      guardianTrackingNo: preset.guardianTrackingNo,
      guardianName: preset.guardianName,
      guardianRelationId: preset.guardianRelationId,
      nameBn: preset.nameBn,
      fullNameEn: preset.fullNameEn,
      givenName: preset.givenName,
      surname: preset.surname,
      fatherName: preset.fatherName,
      fatherNameBn: preset.fatherNameBn,
      motherName: preset.motherName,
      motherNameBn: preset.motherNameBn,
      mobile: preset.mobile,
      maritalStatus: preset.maritalStatus == "Unmarried"
          ? "Single"
          : preset.maritalStatus,
      spouseName: preset.spouseName,
      occupationId: preset.occupationId,
      occupationName: preset.occupationName,
      serviceType: preset.serviceType,
      serviceGradeId: preset.serviceGradeId,
      serviceGradeName: preset.serviceGradeName,
      designationName: preset.designationName,
      permanentPostCode: preset.permanentPostCode,
      permanentDistrictId: preset.permanentDistrictId,
      permanentDistrictName: preset.permanentDistrictName,
      permanentThanaId: preset.permanentThanaId,
      permanentThanaName: preset.permanentThanaName,
      permanentAddress: preset.permanentAddress,
      sameAsPermanent:
          preset.permanentPostCode == preset.currentPostCode &&
          preset.permanentDistrictId == preset.currentDistrictId &&
          preset.permanentDistrictName == preset.currentDistrictName &&
          preset.permanentThanaId == preset.currentThanaId &&
          preset.permanentThanaName == preset.currentThanaName &&
          preset.permanentAddress == preset.currentAddress,
      currentPostCode: preset.currentPostCode,
      currentDistrictId: preset.currentDistrictId,
      currentDistrictName: preset.currentDistrictName,
      currentThanaId: preset.currentThanaId,
      currentThanaName: preset.currentThanaName,
      currentAddress: preset.currentAddress,
      accountType: preset.accountType == "pilgrim_own"
          ? "Self"
          : preset.accountType == "nearest_relative"
          ? "Nearest Relative"
          : preset.accountType == "guardian"
          ? "Guardian"
          : preset.accountType == "maharam"
          ? "Maharam"
          : "",
      accountHolderName: preset.accountHolderName,
      accountNumber: preset.accountNumber,
      bankId: preset.bankId,
      bankName: preset.bankName,
      bankBranchId: preset.bankBranchId,
      branchName: preset.branchName,
      bankDistrictId: preset.bankDistrictId,
      bankDistrictName: preset.bankDistrictName,
      localProfilePhoto: preset.localProfilePhoto,
      serverProfilePhotoUrl: preset.serverProfilePhotoUrl,
      birthCertificate: preset.birthCertificate,
    );

    AppLogger.i(
      "Preset occupationId: ${preset.occupationId}, "
      "occupationName: ${preset.occupationName}, "
      "serviceType: ${preset.serviceType}, "
      "serviceGradeId: ${preset.serviceGradeId}, "
      "designationName: ${preset.designationName}",
    );

    updateOccupation(
      preset.occupationId!,
      preset.occupationName!,
      preset.serviceType!,
      reset: false,
    );
  }

  // inside PreRegistrationFormNotifier
  void updateServerPhoto(String? url) {
    state = state.copyWith(
      serverProfilePhotoUrl: url,
      localProfilePhoto: null, // optional: clear temp local file
    );
  }
}

final preRegistrationFormProvider =
    StateNotifierProvider<PreRegistrationFormNotifier, PreRegistrationForm>(
      (ref) => PreRegistrationFormNotifier(ref: ref),
    );

class PreRegistrationNotifier extends AutoDisposeAsyncNotifier<PreRegResponse> {
  @override
  Future<PreRegResponse> build() async {
    return PreRegResponse();
  }

  Future<void> preRegistration({
    required PreRegistrationForm form,
    required bool edit,
    required String applicationID,
  }) async {
    state = const AsyncLoading();
    final repo = ref.read(preRegRepoProvider);
    try {
      final response = await repo.preRegistration(
        form: form,
        applicationID: applicationID,
        edit: edit,
      );

      // Update the form state with server URLs
      ref
          .read(preRegistrationFormProvider.notifier)
          .updateServerPhoto(response.imageUrl);

      state = AsyncData(response);
    } on DioException catch (dioError, st) {
      final errorMessage =
          dioError.response?.data['error'] ??
          dioError.response?.data['message'] ??
          "Registration failed";
      state = AsyncError(errorMessage, st);
    } catch (e, st) {
      AppLogger.e(e.toString());
      AppLogger.e(st.toString());
      state = AsyncError(e, st);
    }
  }
}

final preRegRepoProvider = Provider.autoDispose<IPreRegistrationRepository>(
  (ref) => PreRegistrationRepository(ref.watch(apiClientProvider).dio),
);

final preRegProvider =
    AsyncNotifierProvider.autoDispose<PreRegistrationNotifier, PreRegResponse>(
      () => PreRegistrationNotifier(),
    );

final preRegListProvider = FutureProvider.autoDispose<List<Pilgrim>>((ref) {
  final repo = ref.watch(preRegRepoProvider);
  return repo.getPreRegistrationList();
});

final pilgrimDetailsProvider = FutureProvider.family
    .autoDispose<PilgrimDetailsResponse, int>((ref, id) {
      final repo = ref.read(preRegRepoProvider);
      return repo.getPilgrimDetails(id: id);
    });
