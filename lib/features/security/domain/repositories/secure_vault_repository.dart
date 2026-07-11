import '../entities/secure_vault_data.dart';

abstract class SecureVaultRepository {
  bool get isEnabled;

  Future<SecureVaultData> read();

  Future<void> save(SecureVaultData data);

  Future<void> clear();
}
