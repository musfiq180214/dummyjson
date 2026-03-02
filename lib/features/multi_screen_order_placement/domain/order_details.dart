import 'package:dummyjson/features/multi_screen_order_placement/domain/order_model.dart';

class PilgrimDetailsResponse {
  final int? id;
  final int? pid;
  final String? trackingNo;
  final String? name;
  final String? nameBn;
  final String? givenNameEn;
  final String? surnameEn;
  final String? fathersName;
  final String? fathersNameBn;
  final String? mothersName;
  final String? mothersNameBn;
  final String? gender;
  final String? dob;
  final String? paymentStatus;
  final String? registrationType;
  final String? residentType;
  final String? identificationType;
  final String? nid;
  final String? passportNo;
  final String? passportType;
  final String? passportCategory;
  final String? passportIssueDate;
  final String? passportExpiry;
  final int? nationalityId;
  final Occupation? occupation;
  final String? maritalStatus;
  final String? spouseName;
  final String? contactNumber;
  final String? guardianTrackingNo;
  final String? medium;
  final List<Address>? addresses;
  final List<BankAccount>? bankAccounts;
  final String? imageUrl;
  final String? birthCertificateUrl;
  final String? nidImgUrl;
  final bool? locked;
  final ServiceGrade? serviceGrade;
  final String? designation;

  const PilgrimDetailsResponse({
    this.id,
    this.pid,
    this.trackingNo,
    this.name,
    this.nameBn,
    this.givenNameEn,
    this.surnameEn,
    this.fathersName,
    this.fathersNameBn,
    this.mothersName,
    this.mothersNameBn,
    this.gender,
    this.dob,
    this.registrationType,
    this.residentType,
    this.identificationType,
    this.nid,
    this.paymentStatus,
    this.passportNo,
    this.passportType,
    this.passportCategory,
    this.passportIssueDate,
    this.passportExpiry,
    this.nationalityId,
    this.occupation,
    this.maritalStatus,
    this.spouseName,
    this.contactNumber,
    this.guardianTrackingNo,
    this.medium,
    this.addresses,
    this.bankAccounts,
    this.imageUrl,
    this.birthCertificateUrl,
    this.nidImgUrl,
    this.locked,
    this.serviceGrade,
    this.designation,
  });

  factory PilgrimDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PilgrimDetailsResponse(
      id: json['id'] ?? 0,
      pid: json['pid'],
      locked: json['locked'] ?? false,
      trackingNo: json['tracking_no'] ?? '',
      name: json['name'] ?? '',
      nameBn: json['name_bn'] ?? '',
      givenNameEn: json['given_name_en'] ?? '',
      surnameEn: json['surname_en'] ?? '',
      fathersName: json['fathers_name'],
      fathersNameBn: json['fathers_name_bn'],
      mothersName: json['mothers_name'],
      mothersNameBn: json['mothers_name_bn'],
      gender: json['gender'] ?? '',
      dob: json['dob'] ?? '',
      registrationType: json['registration_type'] ?? '',
      residentType: json['resident_type'] ?? '',
      identificationType: json['identification_type'] ?? '',
      nid: json['nid'],
      passportNo: json['passport_no'],
      passportType: json['passport_type'],
      passportCategory: json['passport_category'],
      passportIssueDate: json['passport_issue_date'],
      passportExpiry: json['passport_expiry'],
      paymentStatus: json['payment_status'],
      nationalityId: json['nationality_id'],
      occupation: json['occupation'] != null
          ? Occupation.fromJson(json['occupation'])
          : null,
      maritalStatus: json['marital_status'] ?? '',
      spouseName: json['spouse_name'],
      contactNumber: json['contact_number'] ?? '',
      guardianTrackingNo: json['guardian_tracking_no'],
      medium: json['medium'] ?? '',
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => Address.fromJson(e))
              .toList() ??
          [],
      bankAccounts:
          (json['bank_accounts'] as List<dynamic>?)
              ?.map((e) => BankAccount.fromJson(e))
              .toList() ??
          [],
      imageUrl: json['image_url'] ?? '',
      birthCertificateUrl: json['birth_certificate_url'],
      nidImgUrl: json['nid_img_url'],
      serviceGrade: json['service_grade'] != null
          ? ServiceGrade.fromJson(json['service_grade'])
          : null, // ✅ fixed mapping
      designation: json['designation'], // already a string
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pid': pid,
      'tracking_no': trackingNo,
      'name': name,
      'name_bn': nameBn,
      'given_name_en': givenNameEn,
      'surname_en': surnameEn,
      'fathers_name': fathersName,
      'fathers_name_bn': fathersNameBn,
      'mothers_name': mothersName,
      'mothers_name_bn': mothersNameBn,
      'gender': gender,
      'dob': dob,
      'registration_type': registrationType,
      'resident_type': residentType,
      'identification_type': identificationType,
      'nid': nid,
      'passport_no': passportNo,
      'passport_type': passportType,
      'payment_status': paymentStatus,
      'passport_category': passportCategory,
      'passport_issue_date': passportIssueDate,
      'passport_expiry': passportExpiry,
      'nationality_id': nationalityId,
      'occupation': occupation?.toJson(),
      'marital_status': maritalStatus,
      'spouse_name': spouseName,
      'contact_number': contactNumber,
      'guardian_tracking_no': guardianTrackingNo,
      'medium': medium,
      'addresses': addresses!.map((e) => e.toJson()).toList(),
      'bank_accounts': bankAccounts!.map((e) => e.toJson()).toList(),
      'image_url': imageUrl,
      'birth_certificate_url': birthCertificateUrl,
      'nid_img_url': nidImgUrl,
      'locked': locked,
      'service_grade': serviceGrade,
      'designation': designation,
    };
  }
}

class Occupation {
  final int id;
  final String title;
  final String titleBn;
  final String serviceType;
  final ServiceGrade? serviceGrade; // Add this
  final String? designation; // Add this

  const Occupation({
    required this.id,
    required this.title,
    required this.titleBn,
    required this.serviceType,
    this.serviceGrade,
    this.designation,
  });

  factory Occupation.fromJson(Map<String, dynamic> json) {
    return Occupation(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      titleBn: json['title_bn'] ?? '',
      serviceType: json['service_type'] ?? '',
      serviceGrade: json['service_grade'] != null
          ? ServiceGrade.fromJson(json['service_grade'])
          : null,
      designation: json['designation'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'title_bn': titleBn,
    'service_type': serviceType,
    'service_grade': serviceGrade?.toJson(),
    'designation': designation,
  };
}

class ServiceGrade {
  final int id;
  final String title;

  const ServiceGrade({required this.id, required this.title});

  factory ServiceGrade.fromJson(Map<String, dynamic> json) {
    return ServiceGrade(id: json['id'] ?? 0, title: json['title'] ?? '');
  }

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}

class Address {
  final String addressType;
  final String postCode;
  final int districtId;
  final String districtTitle;
  final String districtTitleBn;
  final int thanaId;
  final String thanaTitle;
  final String thanaTitleBn;
  final String addressLine;

  const Address({
    required this.addressType,
    required this.postCode,
    required this.districtId,
    required this.districtTitle,
    required this.districtTitleBn,
    required this.thanaId,
    required this.thanaTitle,
    required this.thanaTitleBn,
    required this.addressLine,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressType: json['address_type'] ?? '',
      postCode: json['post_code'] ?? '',
      districtId: json['district_id'] ?? 0,
      districtTitle: json['district_title'] ?? '',
      districtTitleBn: json['district_title_bn'] ?? '',
      thanaId: json['thana_id'] ?? 0,
      thanaTitle: json['thana_title'] ?? '',
      thanaTitleBn: json['thana_title_bn'] ?? '',
      addressLine: json['address_line'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'address_type': addressType,
    'post_code': postCode,
    'district_id': districtId,
    'district_title': districtTitle,
    'district_title_bn': districtTitleBn,
    'thana_id': thanaId,
    'thana_title': thanaTitle,
    'thana_title_bn': thanaTitleBn,
    'address_line': addressLine,
  };
}

class BankAccount {
  final int id;
  final String ownerType;
  final String accountHolderName;
  final String accountNumber;

  final int bankId;
  final String bankTitle;
  final String bankTitleBn;

  final int districtId;
  final String districtTitle;
  final String districtTitleBn;

  final int branchId;
  final String branchTitle;
  final String branchTitleBn;

  const BankAccount({
    required this.id,
    required this.ownerType,
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankId,
    required this.bankTitle,
    required this.bankTitleBn,
    required this.districtId,
    required this.districtTitle,
    required this.districtTitleBn,
    required this.branchId,
    required this.branchTitle,
    required this.branchTitleBn,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['id'] ?? 0,
      ownerType: json['owner_type'] ?? '',
      accountHolderName: json['account_holder_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      bankId: json['bank_id'] ?? 0,
      bankTitle: json['bank_title'] ?? '',
      bankTitleBn: json['bank_title_bn'] ?? '',
      districtId: json['district_id'] ?? 0,
      districtTitle: json['district_title'] ?? '',
      districtTitleBn: json['district_title_bn'] ?? '',
      branchId: json['branch_id'] ?? 0,
      branchTitle: json['branch_title'] ?? '',
      branchTitleBn: json['branch_title_bn'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_type': ownerType,
    'account_holder_name': accountHolderName,
    'account_number': accountNumber,
    'bank_id': bankId,
    'bank_title': bankTitle,
    'bank_title_bn': bankTitleBn,
    'district_id': districtId,
    'district_title': districtTitle,
    'district_title_bn': districtTitleBn,
    'branch_id': branchId,
    'branch_title': branchTitle,
    'branch_title_bn': branchTitleBn,
  };
}

extension PilgrimMapper on PilgrimDetailsResponse {
  PreRegistrationForm toForm() {
    final permanentAddress = addresses?.firstWhere(
      (a) => a.addressType == 'permanent',
      orElse: () => Address(
        addressType: '',
        postCode: '',
        districtId: 0,
        districtTitle: '',
        districtTitleBn: '',
        thanaId: 0,
        thanaTitle: '',
        thanaTitleBn: '',
        addressLine: '',
      ),
    );

    final currentAddress = addresses?.firstWhere(
      (a) => a.addressType == 'present_bd',
      orElse: () => Address(
        addressType: '',
        postCode: '',
        districtId: 0,
        districtTitle: '',
        districtTitleBn: '',
        thanaId: 0,
        thanaTitle: '',
        thanaTitleBn: '',
        addressLine: '',
      ),
    );

    final bankAccount = bankAccounts?.isNotEmpty == true
        ? bankAccounts!.first
        : null;

    return PreRegistrationForm(
      registrationType: registrationType ?? 'others',
      medium: medium ?? '',
      residentType: residentType ?? '',
      gender: gender ?? '',
      dd: dob != null ? dob!.split('-').last : '',
      mm: dob != null ? dob!.split('-')[1] : '',
      yyyy: dob != null ? dob!.split('-').first : '',
      identityType: identificationType ?? '',
      nid: nid ?? '',
      passportNo: passportNo ?? '',
      passportType: passportType ?? '',
      passportCategory: passportCategory ?? '',
      passportIssueDate: passportIssueDate ?? '',
      passportExpiryDate: passportExpiry ?? '',
      nationalityId: nationalityId,
      occupationId: occupation?.id,
      occupationName: occupation?.title,
      serviceType: occupation?.serviceType ?? '',
      serviceGradeId: occupation?.serviceType == "government"
          ? serviceGrade?.id
          : null,
      serviceGradeName: occupation?.serviceType == "government"
          ? serviceGrade?.title
          : null,
      designationName: occupation?.serviceType == "government"
          ? designation
          : null,
      maritalStatus: maritalStatus ?? '',
      spouseName: spouseName ?? '',
      fullNameEn: name ?? '',
      nameBn: nameBn ?? '',
      givenName: givenNameEn ?? '',
      surname: surnameEn ?? '',
      fatherName: fathersName ?? '',
      fatherNameBn: fathersNameBn ?? '',
      motherName: mothersName ?? '',
      motherNameBn: mothersNameBn ?? '',
      mobile: contactNumber?.replaceAll('+880', '') ?? '',
      guardianTrackingNo: guardianTrackingNo ?? '',
      permanentAddress: permanentAddress?.addressLine ?? '',
      permanentPostCode: int.tryParse(permanentAddress?.postCode ?? ''),
      permanentDistrictId: permanentAddress?.districtId,
      permanentDistrictName: permanentAddress?.districtTitle,
      permanentThanaId: permanentAddress?.thanaId,
      permanentThanaName: permanentAddress?.thanaTitle,
      currentAddress: currentAddress?.addressLine ?? '',
      currentPostCode: int.tryParse(currentAddress?.postCode ?? ''),
      currentDistrictId: currentAddress?.districtId,
      currentDistrictName: currentAddress?.districtTitle,
      currentThanaId: currentAddress?.thanaId,
      currentThanaName: currentAddress?.thanaTitle,
      accountType: bankAccount?.ownerType ?? '',
      accountHolderName: bankAccount?.accountHolderName ?? '',
      accountNumber: bankAccount?.accountNumber ?? '',
      bankId: bankAccount?.bankId,
      bankName: bankAccount?.bankTitle,
      bankDistrictId: bankAccount?.districtId,
      bankDistrictName: bankAccount?.districtTitle,
      bankBranchId: bankAccount?.branchId,
      branchName: bankAccount?.branchTitle,
      serverProfilePhotoUrl: imageUrl,
    );
  }
}
