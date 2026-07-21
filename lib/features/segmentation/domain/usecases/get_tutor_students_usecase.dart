import '../entities/segmentation_student_entity.dart';
import '../repositories/tutor_dashboard_repository.dart';

class GetTutorStudentsUseCase {
  const GetTutorStudentsUseCase(this._repository);
  final TutorDashboardRepository _repository;

  Future<List<SegmentationStudentEntity>> call(String userId) {
    return _repository.getTutorStudents(userId);
  }
}
