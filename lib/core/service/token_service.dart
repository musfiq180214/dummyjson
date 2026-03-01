import 'package:dummyjson/core/provider/secureStorageProvider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accessTokenServiceProvider = Provider<AccessTokenService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return AccessTokenService(storage);
});

class AccessTokenService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  AccessTokenService(this._storage);
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}

final refreshTokenServiceProvider = Provider<RefreshTokenService>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return RefreshTokenService(storage);
});

class RefreshTokenService {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'refresh_token';

  RefreshTokenService(this._storage);
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
