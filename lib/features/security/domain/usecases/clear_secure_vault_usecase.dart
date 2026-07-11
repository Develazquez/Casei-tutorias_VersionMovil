import '../repositories/secure_vault_repository.dart';

class ClearSecureVaultUseCase {
  const ClearSecureVaultUseCase(this._repository);

  final SecureVaultRepository _repository;

  Future<void> call() => _repository.clear();
}
