import '../entities/segmentation_student_entity.dart';
import '../repositories/segmentation_repository.dart';

class GetSegmentationStudentsUseCase {
  const GetSegmentationStudentsUseCase(this._repository);

  final SegmentationRepository _repository;

  Future<List<SegmentationStudentEntity>> call({
    String? role,
    String? profile,
    String? program,
  }) {
    return _repository.getStudents(
      role: role,
      profile: profile,
      program: program,
    );
  }
}
