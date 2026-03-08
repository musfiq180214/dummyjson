// lib/domain/ayah_model.dart
class Ayah {
  final int number;
  final String text;
  final String translation;

  Ayah({
    required this.number,
    required this.text,
    required this.translation,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json["numberInSurah"],
      text: json["text"] ?? "",
      translation: json["edition"] != null ? json["edition"]["text"] ?? "" : "",
    );
  }
}