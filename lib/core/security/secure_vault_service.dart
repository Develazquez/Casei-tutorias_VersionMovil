import '../constants/app_constants.dart';
import 'secure_storage_service.dart';

class SecureVaultService {
  const SecureVaultService(this._storage, {bool? enabled})
    : _enabled = enabled ?? AppConstants.enableSecureVault;

  final SecureStorageService _storage;
  final bool _enabled;

  bool get isEnabled => _enabled;

  Future<SecureVaultData> readVault() async {
    if (!_enabled) {
      return SecureVaultData.empty;
    }

    return SecureVaultData(
      savedPassword: await _storage.readVaultValue('saved_password') ?? '',
      privateNotes: await _storage.readVaultValue('private_notes') ?? '',
      phoneNumber: await _storage.readVaultValue('phone_number') ?? '',
      cardNumber: await _storage.readVaultValue('card_number') ?? '',
    );
  }

  Future<void> saveVault(SecureVaultData data) async {
    if (!_enabled) return;

    await _storage.writeVaultValue('saved_password', data.savedPassword);
    await _storage.writeVaultValue('private_notes', data.privateNotes);
    await _storage.writeVaultValue('phone_number', data.phoneNumber);
    await _storage.writeVaultValue('card_number', data.cardNumber);
  }

  Future<void> clearVault() {
    if (!_enabled) return Future.value();
    return _storage.clearVault();
  }
}

class SecureVaultData {
  const SecureVaultData({
    required this.savedPassword,
    required this.privateNotes,
    required this.phoneNumber,
    required this.cardNumber,
  });

  final String savedPassword;
  final String privateNotes;
  final String phoneNumber;
  final String cardNumber;

  static const empty = SecureVaultData(
    savedPassword: '',
    privateNotes: '',
    phoneNumber: '',
    cardNumber: '',
  );
}
