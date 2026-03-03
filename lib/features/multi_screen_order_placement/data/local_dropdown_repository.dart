class LocalDropdownData {
  // Districts
  static const List<Map<String, dynamic>> districts = [
    {'id': 1, 'title': 'Dhaka', 'title_bn': 'ঢাকা'},
    {'id': 2, 'title': 'Khulna', 'title_bn': 'খুলনা'},
  ];

  // Police Stations
  static const Map<int, List<Map<String, dynamic>>> policeStations = {
    1: [
      {'id': 101, 'title': 'Mohammadpur', 'title_bn': 'মোহাম্মদপুর'},
      {'id': 102, 'title': 'Adabor', 'title_bn': 'আদাবর'},
      {'id': 103, 'title': 'Shahbagh', 'title_bn': 'শাহবাগ'},
    ],
    2: [
      {'id': 201, 'title': 'Batiaghata', 'title_bn': 'বটিয়াঘাটা'},
      {'id': 202, 'title': 'Rupsha', 'title_bn': 'রূপসা'},
    ],
  };

  // Banks
  static const List<Map<String, dynamic>> banks = [
    {'id': 1, 'title': 'Sonali Bank', 'title_bn': 'সোনালী ব্যাংক'},
    {'id': 2, 'title': 'Dutch Bangla Bank', 'title_bn': 'ডাচ বাংলা ব্যাংক'},
    {'id': 3, 'title': 'BRAC Bank', 'title_bn': 'ব্র্যাক ব্যাংক'},
    {'id': 4, 'title': 'Islami Bank', 'title_bn': 'ইসলামী ব্যাংক'},
  ];

  /// Bank → District mapping
  static const Map<int, List<Map<String, dynamic>>> bankDistricts = {
    1: [
      {'id': 11, 'title': 'Dhaka', 'title_bn': 'ঢাকা'},
      {'id': 12, 'title': 'Khulna', 'title_bn': 'খুলনা'},
    ],
    2: [
      {'id': 21, 'title': 'Dhaka', 'title_bn': 'ঢাকা'},
    ],
    3: [
      {'id': 31, 'title': 'Khulna', 'title_bn': 'খুলনা'},
    ],
    4: [
      {'id': 41, 'title': 'Dhaka', 'title_bn': 'ঢাকা'},
    ],
  };

  /// Bank + District → Branch mapping
  static const Map<String, List<Map<String, dynamic>>> bankBranches = {
    // Sonali Bank
    "1_11": [
      {'id': 111, 'title': 'Motijheel Branch', 'title_bn': 'মতিঝিল শাখা'},
      {'id': 112, 'title': 'Dhanmondi Branch', 'title_bn': 'ধানমন্ডি শাখা'},
    ],
    "1_12": [
      {
        'id': 121,
        'title': 'Khulna Main Branch',
        'title_bn': 'খুলনা প্রধান শাখা',
      },
    ],

    // Dutch Bangla
    "2_21": [
      {'id': 211, 'title': 'Gulshan Branch', 'title_bn': 'গুলশান শাখা'},
    ],

    // BRAC
    "3_31": [
      {'id': 311, 'title': 'Rupsha Branch', 'title_bn': 'রূপসা শাখা'},
    ],

    // Islami
    "4_41": [
      {'id': 411, 'title': 'Mirpur Branch', 'title_bn': 'মিরপুর শাখা'},
    ],
  };
}
