import '../entities/secure_vault_data.dart';
import '../repositories/secure_vault_repository.dart';

class SaveSecureVaultUseCase {
  const SaveSecureVaultUseCase(this._repository);

  final SecureVaultRepository _repository;

  Future<void> call(SecureVaultData data) => _repository.save(data);
}
