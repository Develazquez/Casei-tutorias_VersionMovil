import '../entities/secure_vault_data.dart';
import '../repositories/secure_vault_repository.dart';

class ReadSecureVaultUseCase {
  const ReadSecureVaultUseCase(this._repository);

  final SecureVaultRepository _repository;

  bool get isEnabled => _repository.isEnabled;

  Future<SecureVaultData> call() => _repository.read();
}
