class Pilgrim {
  final int? id;
  final String? pid;
  final String? trackingNo;
  final String? name;
  final String? gender;
  final String? applicationType;
  final String? paymentStatus;
  final String? contactNumber;
  final String? medium;

  final bool isSelected;

  const Pilgrim({
    this.id,
    this.pid,
    this.trackingNo,
    this.name,
    this.gender,
    this.applicationType,
    this.paymentStatus,
    this.contactNumber,
    this.isSelected = false,
    this.medium,
  });

  Pilgrim copyWith({bool? isSelected}) {
    return Pilgrim(
      isSelected: isSelected ?? this.isSelected,
      id: id,
      pid: pid,
      trackingNo: trackingNo,
      name: name,
      gender: gender,
      applicationType: applicationType,
      paymentStatus: paymentStatus,
      contactNumber: contactNumber,
      medium: medium,
    );
  }

  factory Pilgrim.fromJson(Map<String, dynamic> json) {
    return Pilgrim(
      id: json['id'] as int?,
      pid: json['pid'] as String?,
      trackingNo: json['tracking_no'] as String?,
      name: json['name'] as String?,
      gender: json['gender'] as String?,
      applicationType: json['application_type'] as String?,
      paymentStatus: json['payment_status'] as String?,
      contactNumber: json['contact_number'] as String?,
      medium: json['medium'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pid': pid,
      'tracking_no': trackingNo,
      'name': name,
      'gender': gender,
      'application_type': applicationType,
      'payment_status': paymentStatus,
      'contact_number': contactNumber,
      'medium': medium,
    };
  }
}
