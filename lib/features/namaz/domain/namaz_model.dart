

class NamazModel {
  final String district;
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  NamazModel({
    required this.district,
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });

  factory NamazModel.fromJson(Map<String, dynamic> json, String district) {
    final timings = json['data']['timings'];

    return NamazModel(
      district: district,
      fajr: timings['Fajr'],
      dhuhr: timings['Dhuhr'],
      asr: timings['Asr'],
      maghrib: timings['Maghrib'],
      isha: timings['Isha'],
    );
  }
}


