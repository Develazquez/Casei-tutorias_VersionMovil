import '../entities/dashboard_summary_entity.dart';
import '../repositories/segmentation_repository.dart';

class GetDashboardSummaryUseCase {
  const GetDashboardSummaryUseCase(this._repository);

  final SegmentationRepository _repository;

  Future<DashboardSummaryEntity> call({String? role}) {
    return _repository.getSummary(role: role);
  }
}
