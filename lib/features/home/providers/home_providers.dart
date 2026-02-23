// providers/home_provider.dart
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/home/domain/home_models.dart';
import 'package:dummyjson/features/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

// Dio provider
final dioProvider = Provider<Dio>((ref) => Dio());

// Repository provider
final homeRepoProvider = Provider<IHomeRepo>((ref) {
  final dio = ref.read(dioProvider);
  return HomeRepo(dio: dio);
});

// Location update provider (async)
final locationUpdateProvider = FutureProvider.family<void, LocationUpdate>((
  ref,
  update,
) async {
  final repo = ref.read(homeRepoProvider);
  final token = ref.read(accessTokenProvider);
  await repo.sendLocationUpdate(update, token ?? "");
});
