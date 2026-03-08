// lib/data/quran_repository.dart
import 'package:dio/dio.dart';
import '../domain/ayah_model.dart';
import '../domain/surah_model.dart';

abstract class IQuranRepository {
  Future<List<Surah>> getSurahs();
}

class QuranRepository implements IQuranRepository {
  final Dio _dio;
  QuranRepository(this._dio);

  @override
  Future<List<Surah>> getSurahs() async {
    final response = await _dio.get("https://api.alquran.cloud/v1/surah");
    final List data = response.data["data"];
    return data.map((e) => Surah.fromJson(e)).toList();
  }
}


abstract class IQuranDetailRepository {
  Future<List<Ayah>> getAyahs(int surahNumber);
}

class QuranDetailRepository implements IQuranDetailRepository {
  final Dio _dio;
  QuranDetailRepository(this._dio);

  @override
  Future<List<Ayah>> getAyahs(int surahNumber) async {
    final response =
    await _dio.get("https://api.alquran.cloud/v1/surah/$surahNumber/en.asad");

    final List data = response.data["data"]["ayahs"];
    return data
        .map((e) => Ayah(
      number: e["numberInSurah"],
      text: e["text"] ?? "",
      translation: e["translation"] ?? "",
    ))
        .toList();
  }
}