import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_student_dto.dart';

abstract class SegmentationDataSource {
  Future<DashboardSummaryDto> getSummary({String? role});

  Future<List<SegmentationStudentDto>> getStudents({
    String? role,
    String? profile,
    String? program,
  });
}
