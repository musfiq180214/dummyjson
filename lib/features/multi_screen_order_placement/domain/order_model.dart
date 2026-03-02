import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class PreRegistrationForm {
  // Step 0 / General
  String registrationType; // self / others
  int? nationalityId;
  String? nationalityName; // added
  int? occupationId;
  String? occupationName; // added
  int? serviceGradeId;
  String? serviceGradeName; // added
  String? designationName; // added
  int? bankId;
  String? bankName; // added
  String? branchName; // added
  int? bankDistrictId;
  String? bankDistrictName; // added

  // Step 1
  String residentType;
  String gender;
  String dd, mm, yyyy;
  String identityType;
  String passportType;
  String passportIssueDate;
  String passportExpiryDate;
  String passportCategory;

  // String identityNumber; // nid, passport_no, birth_certificate
  String nid;
  String passportNo;
  String birthCertificateNo;
  String guardianTrackingNo;
  int? guardianRelationId;
  String guardianName;
  String medium;

  // Step 2
  String nameBn;
  String fullNameEn;
  String givenName;
  String surname;
  String fatherName;
  String fatherNameBn;
  String motherName;
  String motherNameBn;
  String mobile;
  String maritalStatus;
  String spouseName;
  String serviceType;

  // Step 3
  int? permanentPostCode;
  int? permanentDistrictId;
  String? permanentDistrictName; // added
  int? permanentThanaId;
  String? permanentThanaName; // added
  String permanentAddress;
  bool sameAsPermanent;
  int? currentPostCode;
  int? currentDistrictId;
  String? currentDistrictName; // added
  int? currentThanaId;
  String? currentThanaName; // added
  String currentAddress;

  // Step 4
  String accountType; // self / other
  String accountHolderName;
  String accountNumber;
  int? bankBranchId;
  // XFile? profilePhoto;

  XFile? birthCertificate;

  // LOCAL PICKED PHOTO
  final XFile? localProfilePhoto;

  // SERVER PHOTO URL
  String? serverProfilePhotoUrl;

  PreRegistrationForm({
    this.registrationType = 'others',
    this.medium = 'Government',
    this.nationalityId,
    this.nationalityName,
    this.occupationId,
    this.occupationName,
    this.serviceGradeId,
    this.serviceGradeName,
    this.designationName,
    this.bankId,
    this.bankName,
    this.branchName,
    this.bankDistrictId,
    this.bankDistrictName,
    this.residentType = '',
    this.serviceType = '',
    this.gender = '',
    this.dd = '',
    this.mm = '',
    this.yyyy = '',
    this.identityType = '',
    this.passportType = '',
    this.passportCategory = '',
    this.passportIssueDate = '',
    this.passportExpiryDate = '',
    this.nid = '',
    this.passportNo = '',
    this.birthCertificateNo = '',
    this.guardianTrackingNo = '',
    this.guardianRelationId,
    this.guardianName = '',
    this.nameBn = '',
    this.fullNameEn = '',
    this.givenName = '',
    this.surname = '',
    this.fatherName = '',
    this.fatherNameBn = '',
    this.motherName = '',
    this.motherNameBn = '',
    this.mobile = '',
    this.maritalStatus = '',
    this.spouseName = '',
    this.permanentPostCode,
    this.permanentDistrictId,
    this.permanentDistrictName,
    this.permanentThanaId,
    this.permanentThanaName,
    this.permanentAddress = '',
    this.sameAsPermanent = false,
    this.currentPostCode,
    this.currentDistrictId,
    this.currentDistrictName,
    this.currentThanaId,
    this.currentThanaName,
    this.currentAddress = '',
    this.accountType = '',
    this.accountHolderName = '',
    this.accountNumber = '',
    this.bankBranchId,
    this.birthCertificate,
    this.localProfilePhoto,
    this.serverProfilePhotoUrl,
  });

  PreRegistrationForm copyWith({
    String? registrationType,
    int? nationalityId,
    String? nationalityName,
    int? occupationId,
    String? occupationName,
    int? serviceGradeId,
    String? serviceGradeName,
    String? designationName,
    String? medium,
    int? bankId,
    String? bankName,
    String? branchName,
    int? bankDistrictId,
    String? bankDistrictName,
    String? residentType,
    String? gender,
    String? dd,
    String? mm,
    String? yyyy,
    String? identityType,
    String? passportType,
    String? passportCategory,
    String? passportIssueDate,
    String? passportExpiryDate,
    String? guardianTrackingNo,
    String? guardianName,
    int? guardianRelationId,
    String? nameBn,
    String? fullNameEn,
    String? givenName,
    String? surname,
    String? fatherName,
    String? fatherNameBn,
    String? motherName,
    String? motherNameBn,
    String? mobile,
    String? maritalStatus,
    String? spouseName,
    String? serviceType,
    String? nid,
    String? passportNo,
    String? birthCertificateNo,
    int? permanentPostCode,
    int? permanentDistrictId,
    String? permanentDistrictName,
    int? permanentThanaId,
    String? permanentThanaName,
    String? permanentAddress,
    bool? sameAsPermanent,
    int? currentPostCode,
    int? currentDistrictId,
    String? currentDistrictName,
    int? currentThanaId,
    String? currentThanaName,
    String? currentAddress,
    String? accountType,
    String? accountHolderName,
    String? accountNumber,
    int? bankBranchId,
    XFile? profilePhoto,
    XFile? birthCertificate,
    bool resetPermanentThanaID = false,
    bool resetCurrentThanaID = false,
    bool resetPermanentThanaName = false,
    bool resetCurrentThanaName = false,
    bool resetBankDistrictID = false,
    bool resetBankDistrictName = false,
    bool resetBankBranchID = false,
    bool resetBankBranchName = false,
    bool resetNationality = false,
    bool resetNationalityId = false,
    bool resetBirthCertificate = false,
    XFile? localProfilePhoto,
    String? serverProfilePhotoUrl,
  }) {
    return PreRegistrationForm(
      registrationType: registrationType ?? this.registrationType,
      medium: medium ?? this.medium,
      nationalityId: resetNationalityId
          ? null
          : nationalityId ?? this.nationalityId,
      nationalityName: resetNationality
          ? null
          : nationalityName ?? this.nationalityName,
      occupationId: occupationId ?? this.occupationId,
      occupationName: occupationName ?? this.occupationName,
      serviceGradeId: serviceGradeId ?? this.serviceGradeId,
      serviceGradeName: serviceGradeName ?? this.serviceGradeName,
      designationName: designationName ?? this.designationName,
      bankId: bankId ?? this.bankId,
      bankName: bankName ?? this.bankName,
      branchName: resetBankBranchName ? null : (branchName ?? this.branchName),
      bankDistrictId: resetBankDistrictID
          ? null
          : (bankDistrictId ?? this.bankDistrictId),
      bankDistrictName: resetBankDistrictName
          ? null
          : (bankDistrictName ?? this.bankDistrictName),
      residentType: residentType ?? this.residentType,
      gender: gender ?? this.gender,
      dd: dd ?? this.dd,
      mm: mm ?? this.mm,
      yyyy: yyyy ?? this.yyyy,
      identityType: identityType ?? this.identityType,
      passportType: passportType ?? this.passportType,
      passportCategory: passportCategory ?? this.passportCategory,
      passportIssueDate: passportIssueDate ?? this.passportIssueDate,
      passportExpiryDate: passportExpiryDate ?? this.passportExpiryDate,
      nid: nid ?? this.nid,
      passportNo: passportNo ?? this.passportNo,
      birthCertificateNo: birthCertificateNo ?? this.birthCertificateNo,
      guardianTrackingNo: guardianTrackingNo ?? this.guardianTrackingNo,
      guardianRelationId: guardianRelationId ?? this.guardianRelationId,
      guardianName: guardianName ?? this.guardianName,
      nameBn: nameBn ?? this.nameBn,
      fullNameEn: fullNameEn ?? this.fullNameEn,
      givenName: givenName ?? this.givenName,
      surname: surname ?? this.surname,
      fatherName: fatherName ?? this.fatherName,
      fatherNameBn: fatherNameBn ?? this.fatherNameBn,
      motherName: motherName ?? this.motherName,
      motherNameBn: motherNameBn ?? this.motherNameBn,
      mobile: mobile ?? this.mobile,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      spouseName: spouseName ?? this.spouseName,
      permanentPostCode: permanentPostCode ?? this.permanentPostCode,
      permanentDistrictId: permanentDistrictId ?? this.permanentDistrictId,
      permanentDistrictName:
          permanentDistrictName ?? this.permanentDistrictName,
      permanentThanaId: resetPermanentThanaID
          ? null
          : (permanentThanaId ?? this.permanentThanaId),
      permanentThanaName: resetPermanentThanaName
          ? null
          : (permanentThanaName ?? this.permanentThanaName),
      permanentAddress: permanentAddress ?? this.permanentAddress,
      sameAsPermanent: sameAsPermanent ?? this.sameAsPermanent,
      currentPostCode: currentPostCode ?? this.currentPostCode,
      currentDistrictId: currentDistrictId ?? this.currentDistrictId,
      currentDistrictName: currentDistrictName ?? this.currentDistrictName,
      currentThanaId: resetCurrentThanaID
          ? null
          : (currentThanaId ?? this.currentThanaId),
      currentThanaName: resetCurrentThanaName
          ? null
          : (currentThanaName ?? this.currentDistrictName),
      currentAddress: currentAddress ?? this.currentAddress,
      accountType: accountType ?? this.accountType,
      accountHolderName: accountHolderName ?? this.accountHolderName,
      accountNumber: accountNumber ?? this.accountNumber,
      bankBranchId: resetBankBranchID
          ? null
          : (bankBranchId ?? this.bankBranchId),
      // profilePhoto: profilePhoto ?? this.profilePhoto,
      birthCertificate: birthCertificate ?? this.birthCertificate,
      serviceType: serviceType ?? this.serviceType,

      localProfilePhoto: localProfilePhoto ?? this.localProfilePhoto,
      serverProfilePhotoUrl:
          serverProfilePhotoUrl ?? this.serverProfilePhotoUrl,
    );
  }

  // Utils
  int get age {
    if (dd.isEmpty || mm.isEmpty || yyyy.isEmpty) return 0;
    try {
      final birthDate = DateTime(int.parse(yyyy), int.parse(mm), int.parse(dd));
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month ||
          (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0;
    }
  }

  bool get isMinor => age < 18;

  /// Full toJson (keeps all fields including empty strings)
  /* Map<String, dynamic> toJson() {
    return {
      "registration_type": registrationType,
      "medium": medium,
      "resident_type": residentType.toLowerCase(),
      "nationality_id": nationalityId,
      "gender": gender.toLowerCase(),
      "dob":
          "${yyyy.padLeft(4, '0')}-${mm.padLeft(2, '0')}-${dd.padLeft(2, '0')}",
      "identification_type": identityType.toLowerCase() == "passport"
          ? "passport_type"
          : identityType.toLowerCase() == "nid"
              ? "nid_type"
              : "birth_certification_type",
      "contact_number": "+880$mobile",
      "name": fullNameEn,
      "name_bn": nameBn,
      "given_name_en": givenName,
      "surname_en": surname,
      "father_name": fatherName,
      "fathers_name_bn": fatherNameBn,
      "mothers_name": motherName,
      "mothers_name_bn": motherNameBn,
      "occupation_id": occupationId,
      "service_grade_id": serviceGradeId,
      "marital_status": maritalStatus.toLowerCase() == "single"
          ? "unmarried"
          : maritalStatus.toLowerCase(),
      "spouse_name": spouseName,
      "nid": nid,
      "passport_no": passportNo,
      "passport_type":
          passportType.toLowerCase() == "mrp" ? "mrp" : "e_passport",
      "passport_issue_date": passportIssueDate,
      "passport_expiry": passportExpiryDate,
      "passport_category": passportCategory.toLowerCase(),
      "birth_certificate": birthCertificateNo,
      "permanent_address": {
        "address_type": "permanent",
        "post_code": permanentPostCode,
        "district_id": permanentDistrictId,
        "thana_id": permanentThanaId,
        "address_line": permanentAddress,
      },
      "current_address": {
        "address_type": "present_bd",
        "post_code": currentPostCode,
        "district_id": currentDistrictId,
        "thana_id": currentThanaId,
        "address_line": currentAddress,
      },
      "bank_account": {
        "owner_type": accountType.toLowerCase() == "self"
            ? "pilgrim_own"
            : accountType.toLowerCase() == "nearest relative"
                ? "nearest_relative"
                : accountType.toLowerCase(),
        "account_holder_name": accountHolderName,
        "account_number": accountNumber,
        "bank_id": bankId,
        "branch_id": bankBranchId,
        "district_id": bankDistrictId
      },
      "image_file": profilePhoto,
      "birth_certificate_file": birthCertificate,
    };
  }*/

  Future<FormData> toFormData() async {
    final Map<String, dynamic> formMap = {
      "registration_type": cleanValue(registrationType),
      "medium": cleanValue(medium.toLowerCase()),
      "resident_type": cleanValue(residentType.toLowerCase()),
      "nationality_id": cleanValue(nationalityId),
      "gender": cleanValue(gender.toLowerCase()),
      "dob": cleanValue(
        "${yyyy.padLeft(4, '0')}-${mm.padLeft(2, '0')}-${dd.padLeft(2, '0')}",
      ),
      "identification_type": cleanValue(
        identityType.toLowerCase() == "passport"
            ? "passport_type"
            : identityType.toLowerCase() == "nid"
            ? "nid_type"
            : "birth_certificate_type",
      ),
      "contact_number": cleanValue("+880$mobile"),
      "name": cleanValue(fullNameEn),
      "name_bn": cleanValue(nameBn),
      "given_name_en": cleanValue(givenName),
      "surname_en": cleanValue(surname),
      "fathers_name": cleanValue(fatherName),
      "fathers_name_bn": cleanValue(fatherNameBn),
      "mothers_name": cleanValue(motherName),
      "mothers_name_bn": cleanValue(motherNameBn),
      "occupation_id": cleanValue(occupationId),
      "service_grade_id": cleanValue(serviceGradeId),
      "designation": cleanValue(designationName),
      "marital_status": cleanValue(
        maritalStatus.toLowerCase() == "single"
            ? "unmarried"
            : maritalStatus.toLowerCase(),
      ),
      "spouse_name": cleanValue(spouseName),
      "nid": cleanValue(nid),
      "passport_no": cleanValue(passportNo),
      "passport_type": cleanValue(
        passportType.toLowerCase() == "mrp" ? "mrp" : "e_passport",
      ),
      "passport_category": cleanValue(passportCategory.toLowerCase()),
      "passport_issue_date": cleanValue(passportIssueDate),
      "passport_expiry": cleanValue(passportExpiryDate),
      "birth_certificate_no": cleanValue(birthCertificateNo),
      if (isMinor || gender.toLowerCase() == "female")
        "mahram_relation_id": cleanValue(guardianRelationId),
      if (isMinor || gender.toLowerCase() == "female")
        "guardian_tracking_no": cleanValue(guardianTrackingNo),
      // Flatten nested maps manually
      "permanent_address[address_type]": "permanent",
      "permanent_address[post_code]": cleanValue(permanentPostCode),
      "permanent_address[district_id]": cleanValue(permanentDistrictId),
      "permanent_address[thana_id]": cleanValue(permanentThanaId),
      "permanent_address[address_line]": cleanValue(permanentAddress),
      "current_address[address_type]": "present_bd",
      "current_address[post_code]": cleanValue(currentPostCode),
      "current_address[district_id]": cleanValue(currentDistrictId),
      "current_address[thana_id]": cleanValue(currentThanaId),
      "current_address[address_line]": cleanValue(currentAddress),
      "bank_account[owner_type]": cleanValue(
        accountType.toLowerCase() == "self"
            ? "pilgrim_own"
            : accountType.toLowerCase() == "nearest relative"
            ? "nearest_relative"
            : accountType.toLowerCase(),
      ),
      "bank_account[account_holder_name]": cleanValue(accountHolderName),
      "bank_account[account_number]": cleanValue(accountNumber),
      "bank_account[bank_id]": cleanValue(bankId),
      "bank_account[branch_id]": cleanValue(bankBranchId),
      "bank_account[district_id]": cleanValue(bankDistrictId),
    };

    // Remove any null or empty string values
    final Map<String, dynamic> cleanedData = Map.fromEntries(
      formMap.entries.where(
        (e) =>
            e.value != null &&
            (e.value is! String || e.value.trim().isNotEmpty),
      ),
    );

    // Prepare FormData
    final formDataMap = Map<String, dynamic>.from(cleanedData);

    // if (profilePhoto != null) {
    //   formDataMap["image_file"] = await MultipartFile.fromFile(
    //     profilePhoto!.path,
    //     filename: profilePhoto!.name,
    //   );
    // }

    // 1️⃣ Local picked image
    if (localProfilePhoto != null) {
      formDataMap["image_file"] = await MultipartFile.fromFile(
        localProfilePhoto!.path,
        filename: localProfilePhoto!.name,
      );
    }
    // 2️⃣ Server image URL (edit mode) — optional: include URL if API accepts
    else if (serverProfilePhotoUrl != null &&
        serverProfilePhotoUrl!.isNotEmpty) {
      formDataMap["image_url"] = serverProfilePhotoUrl;
    }

    if (identityType.toLowerCase() == "birth certificate" &&
        birthCertificate != null) {
      formDataMap["birth_certificate_file"] = await MultipartFile.fromFile(
        birthCertificate!.path,
        filename: birthCertificate!.name,
      );
    }

    return FormData.fromMap(formDataMap);
  }

  // Helper function
  dynamic cleanValue(dynamic value) {
    if (value == null) return null;
    if (value is String && value.trim().isEmpty) return null;
    return value;
  }
}
