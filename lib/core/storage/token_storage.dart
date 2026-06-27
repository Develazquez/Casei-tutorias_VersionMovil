import '../security/secure_storage_service.dart';

class TokenStorage {
  TokenStorage(this._secureStorage);

  static const _tokenKey = 'casei_auth_token';
  static const _roleKey = 'casei_user_role';

  final SecureStorageService _secureStorage;

  Future<void> saveSession({
    required String token,
    required String role,
  }) async {
    await _secureStorage.writeSessionValue(_tokenKey, token);
    await _secureStorage.writeSessionValue(_roleKey, role);
  }

  Future<String?> getToken() async {
    return _secureStorage.readSessionValue(_tokenKey);
  }

  Future<String?> getRole() async {
    return _secureStorage.readSessionValue(_roleKey);
  }

  Future<void> clear() async {
    await _secureStorage.deleteSessionValue(_tokenKey);
    await _secureStorage.deleteSessionValue(_roleKey);
  }
}
