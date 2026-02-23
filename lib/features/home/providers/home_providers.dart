// providers/home_provider.dart
import 'package:dummyjson/core/network/api_client.dart';
import 'package:dummyjson/features/auth/providers/login_provider.dart';
import 'package:dummyjson/features/home/domain/home_models.dart';
import 'package:dummyjson/features/home/repository/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
