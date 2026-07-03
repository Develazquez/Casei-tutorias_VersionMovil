import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class SecureStorageService {
  SecureStorageService({
    FlutterSecureStorage? storage,
    bool? useEncryptedStorage,
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _useEncryptedStorage =
           useEncryptedStorage ?? AppConstants.enableEncryptedSecureStorage;

  static const _vaultPrefix = 'casei_vault_';
  static const _sessionPrefix = 'casei_session_';

  final FlutterSecureStorage _storage;
  final bool _useEncryptedStorage;

  Future<void> write(String key, String value) async {
    if (_useEncryptedStorage) {
      await _storage.write(key: key, value: value);
      return;
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(key, value);
  }

  Future<String?> read(String key) async {
    if (_useEncryptedStorage) {
      return _storage.read(key: key);
    }
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(key);
  }

  Future<void> delete(String key) async {
    if (_useEncryptedStorage) {
      await _storage.delete(key: key);
      return;
    }
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  Future<void> clearSessionData() async {
    if (!_useEncryptedStorage) {
      final preferences = await SharedPreferences.getInstance();
      for (final key in preferences.getKeys()) {
        if (key.startsWith(_sessionPrefix) || key.startsWith(_vaultPrefix)) {
          await preferences.remove(key);
        }
      }
      return;
    }

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
    if (!_useEncryptedStorage) {
      final preferences = await SharedPreferences.getInstance();
      for (final key in preferences.getKeys()) {
        if (key.startsWith(_vaultPrefix)) {
          await preferences.remove(key);
        }
      }
      return;
    }

    final entries = await _storage.readAll();
    for (final key in entries.keys) {
      if (key.startsWith(_vaultPrefix)) {
        await _storage.delete(key: key);
      }
    }
  }
}
