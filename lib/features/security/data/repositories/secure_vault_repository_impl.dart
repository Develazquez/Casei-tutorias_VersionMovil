import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/secure_storage_service.dart';
import '../../domain/entities/secure_vault_data.dart';
import '../../domain/repositories/secure_vault_repository.dart';

class SecureVaultRepositoryImpl implements SecureVaultRepository {
  const SecureVaultRepositoryImpl(this._storage, {bool? enabled})
    : _enabled = enabled ?? AppConstants.enableSecureVault;

  final SecureStorageService _storage;
  final bool _enabled;

  @override
  bool get isEnabled => _enabled;

  @override
  Future<SecureVaultData> read() async {
    if (!_enabled) return SecureVaultData.empty;

    return SecureVaultData(
      savedPassword: await _storage.readVaultValue('saved_password') ?? '',
      privateNotes: await _storage.readVaultValue('private_notes') ?? '',
      phoneNumber: await _storage.readVaultValue('phone_number') ?? '',
      cardNumber: await _storage.readVaultValue('card_number') ?? '',
    );
  }

  @override
  Future<void> save(SecureVaultData data) async {
    if (!_enabled) return;

    await _storage.writeVaultValue('saved_password', data.savedPassword);
    await _storage.writeVaultValue('private_notes', data.privateNotes);
    await _storage.writeVaultValue('phone_number', data.phoneNumber);
    await _storage.writeVaultValue('card_number', data.cardNumber);
  }

  @override
  Future<void> clear() {
    if (!_enabled) return Future.value();
    return _storage.clearVault();
  }
}
