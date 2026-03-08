// lib/providers/quran_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../data/quran_repository.dart';
import '../domain/ayah_model.dart';
import '../domain/surah_model.dart';

final dioProvider = Provider((ref) => Dio());

final quranRepositoryProvider = Provider<IQuranRepository>((ref) {
  return QuranRepository(ref.watch(dioProvider));
});

final surahListProvider = FutureProvider<List<Surah>>((ref) async {
  final repo = ref.watch(quranRepositoryProvider);
  return repo.getSurahs();
});



final quranDetailRepositoryProvider = Provider<IQuranDetailRepository>((ref) {
  return QuranDetailRepository(ref.watch(dioProvider));
});

final ayahListProvider =
FutureProvider.family<List<Ayah>, int>((ref, surahNumber) async {
  final repo = ref.watch(quranDetailRepositoryProvider);
  return repo.getAyahs(surahNumber);
});