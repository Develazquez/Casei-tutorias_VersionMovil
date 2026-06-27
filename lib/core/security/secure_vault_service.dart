import 'secure_storage_service.dart';

class SecureVaultService {
  const SecureVaultService(this._storage);

  final SecureStorageService _storage;

  Future<SecureVaultData> readVault() async {
    return SecureVaultData(
      savedPassword: await _storage.readVaultValue('saved_password') ?? '',
      privateNotes: await _storage.readVaultValue('private_notes') ?? '',
      phoneNumber: await _storage.readVaultValue('phone_number') ?? '',
      cardNumber: await _storage.readVaultValue('card_number') ?? '',
    );
  }

  Future<void> saveVault(SecureVaultData data) async {
    await _storage.writeVaultValue('saved_password', data.savedPassword);
    await _storage.writeVaultValue('private_notes', data.privateNotes);
    await _storage.writeVaultValue('phone_number', data.phoneNumber);
    await _storage.writeVaultValue('card_number', data.cardNumber);
  }

  Future<void> clearVault() => _storage.clearVault();
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
}
