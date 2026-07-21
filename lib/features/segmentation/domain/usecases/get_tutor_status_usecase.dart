import '../entities/tutor_status_entity.dart';
import '../repositories/tutor_dashboard_repository.dart';

class GetTutorStatusUseCase {
  const GetTutorStatusUseCase(this._repository);
  final TutorDashboardRepository _repository;

  Future<TutorStatusEntity> call(String userId) {
    return _repository.getTutorStatus(userId);
  }
}
