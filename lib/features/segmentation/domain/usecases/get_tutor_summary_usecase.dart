import '../entities/dashboard_summary_entity.dart';
import '../repositories/tutor_dashboard_repository.dart';

class GetTutorSummaryUseCase {
  const GetTutorSummaryUseCase(this._repository);
  final TutorDashboardRepository _repository;

  Future<DashboardSummaryEntity> call(String userId) {
    return _repository.getTutorSummary(userId);
  }
}
