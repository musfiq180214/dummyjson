import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dummyjson/core/network/api_client.dart';
import '../data/namaz_repository.dart';
import '../domain/namaz_model.dart';

final namazProvider = FutureProvider<NamazModel>((ref) async {
  final dio = ref.read(dioProvider);
  final domain = NamazRepository(dio);
  return domain.getNamazTimes();
});