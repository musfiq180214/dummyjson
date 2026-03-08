// lib/domain/ayah_model.dart
class Ayah {
  final int number;
  final String text;
  final bool sajda;

  Ayah({
    required this.number,
    required this.text,
    required this.sajda
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json["numberInSurah"],
      text: json["text"] ?? "",
      sajda: json["sajda"] ?? false
    );
  }
}