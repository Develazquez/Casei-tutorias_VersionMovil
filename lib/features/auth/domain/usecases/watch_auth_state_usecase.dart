import '../repositories/auth_state_repository.dart';

class WatchAuthStateUseCase {
  const WatchAuthStateUseCase(this._repository);

  final AuthStateRepository _repository;

  Stream<bool> call() => _repository.watchSignedIn();
}
