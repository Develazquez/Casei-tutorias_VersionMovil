import '../entities/segmentation_student_entity.dart';
import '../repositories/tutor_dashboard_repository.dart';

class SearchTutorStudentsUseCase {
  const SearchTutorStudentsUseCase(this._repository);
  final TutorDashboardRepository _repository;

  Future<List<SegmentationStudentEntity>> call(String userId, String query) {
    return _repository.searchTutorStudents(userId, query);
  }
}
