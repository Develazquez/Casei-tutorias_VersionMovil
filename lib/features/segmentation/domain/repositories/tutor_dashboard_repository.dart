import '../entities/segmentation_student_entity.dart';
import '../entities/dashboard_summary_entity.dart';
import '../entities/tutor_status_entity.dart';

abstract class TutorDashboardRepository {
  Future<TutorStatusEntity> getTutorStatus(String userId);
  Future<List<SegmentationStudentEntity>> getTutorStudents(String userId);
  Future<DashboardSummaryEntity> getTutorSummary(String userId);
  Future<List<SegmentationStudentEntity>> searchTutorStudents(String userId, String query);
}
