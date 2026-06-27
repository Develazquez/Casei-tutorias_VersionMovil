import '../entities/dashboard_summary_entity.dart';
import '../entities/segmentation_student_entity.dart';

abstract class SegmentationRepository {
  Future<DashboardSummaryEntity> getSummary({String? role});
  Future<List<SegmentationStudentEntity>> getStudents({
    String? role,
    String? profile,
    String? program,
  });
}
