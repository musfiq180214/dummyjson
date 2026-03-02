class PreRegResponse {
  final int? id;
  final String? pid;
  final String? trackingNo;
  final String? name;
  final String? nameBn;
  final String? gender;
  final String? dob;
  final String? applicationType;
  final String? applicationStatus;
  final String? paymentStatus;
  final String? contactNumber;
  final Address? permanentAddress;
  final Address? currentAddress;
  final BankAccount? bankAccount;
  final String? imageUrl;
  final String? birthCertificateUrl;

  PreRegResponse({
    this.id,
    this.pid,
    this.trackingNo,
    this.name,
    this.nameBn,
    this.gender,
    this.dob,
    this.applicationType,
    this.applicationStatus,
    this.paymentStatus,
    this.contactNumber,
    this.permanentAddress,
    this.currentAddress,
    this.bankAccount,
    this.imageUrl,
    this.birthCertificateUrl,
  });

  factory PreRegResponse.fromJson(Map<String, dynamic> json) {
    return PreRegResponse(
      id: json['id'] as int?,
      pid: json['pid'] as String?,
      trackingNo: json['tracking_no'] as String?,
      name: json['name'] as String?,
      nameBn: json['name_bn'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      applicationType: json['application_type'] as String?,
      applicationStatus: json['application_status'] as String?,
      paymentStatus: json['payment_status'] as String?,
      contactNumber: json['contact_number'] as String?,
      permanentAddress: json['permanent_address'] != null
          ? Address.fromJson(json['permanent_address'])
          : null,
      currentAddress: json['current_address'] != null
          ? Address.fromJson(json['current_address'])
          : null,
      bankAccount: json['bank_account'] != null
          ? BankAccount.fromJson(json['bank_account'])
          : null,
      imageUrl: json['image_url'] as String?,
      birthCertificateUrl: json['birth_certificate_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pid': pid,
      'tracking_no': trackingNo,
      'name': name,
      'name_bn': nameBn,
      'gender': gender,
      'dob': dob,
      'application_type': applicationType,
      'application_status': applicationStatus,
      'payment_status': paymentStatus,
      'contact_number': contactNumber,
      'permanent_address': permanentAddress?.toJson(),
      'current_address': currentAddress?.toJson(),
      'bank_account': bankAccount?.toJson(),
      'image_url': imageUrl,
      'birth_certificate_url': birthCertificateUrl,
    };
  }
}

class Address {
  final String? street;
  final String? city;
  final String? district;
  final String? country;
  final String? postalCode;

  Address({
    this.street,
    this.city,
    this.district,
    this.country,
    this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'] as String?,
      city: json['city'] as String?,
      district: json['district'] as String?,
      country: json['country'] as String?,
      postalCode: json['postal_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'city': city,
      'district': district,
      'country': country,
      'postal_code': postalCode,
    };
  }
}

class BankAccount {
  final String? accountNumber;
  final String? bankName;
  final String? branch;
  final String? ifscCode;

  BankAccount({this.accountNumber, this.bankName, this.branch, this.ifscCode});

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountNumber: json['account_number'] as String?,
      bankName: json['bank_name'] as String?,
      branch: json['branch'] as String?,
      ifscCode: json['ifsc_code'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_number': accountNumber,
      'bank_name': bankName,
      'branch': branch,
      'ifsc_code': ifscCode,
    };
  }
}
