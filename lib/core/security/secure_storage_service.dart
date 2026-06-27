import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _vaultPrefix = 'casei_vault_';
  static const _sessionPrefix = 'casei_session_';

  final FlutterSecureStorage _storage;

  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<void> clearSessionData() async {
    final entries = await _storage.readAll();
    for (final key in entries.keys) {
      if (key.startsWith(_sessionPrefix) || key.startsWith(_vaultPrefix)) {
        await _storage.delete(key: key);
      }
    }
  }

  Future<void> writeSessionValue(String key, String value) {
    return write('$_sessionPrefix$key', value);
  }

  Future<String?> readSessionValue(String key) {
    return read('$_sessionPrefix$key');
  }

  Future<void> deleteSessionValue(String key) {
    return delete('$_sessionPrefix$key');
  }

  Future<void> writeVaultValue(String key, String value) {
    return write('$_vaultPrefix$key', value);
  }

  Future<String?> readVaultValue(String key) {
    return read('$_vaultPrefix$key');
  }

  Future<void> clearVault() async {
    final entries = await _storage.readAll();
    for (final key in entries.keys) {
      if (key.startsWith(_vaultPrefix)) {
        await _storage.delete(key: key);
      }
    }
  }
}
