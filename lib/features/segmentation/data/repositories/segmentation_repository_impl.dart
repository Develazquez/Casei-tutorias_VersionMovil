import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/repositories/segmentation_repository.dart';
import '../datasources/segmentation_mock_data_source.dart';
import '../mappers/segmentation_mapper.dart';

class SegmentationRepositoryImpl implements SegmentationRepository {
  const SegmentationRepositoryImpl(this._dataSource);

  final SegmentationMockDataSource _dataSource;

  @override
  Future<DashboardSummaryEntity> getSummary({String? role}) async {
    final dto = await _dataSource.getSummary(role: role);
    return SegmentationMapper.summaryToEntity(dto);
  }

  @override
  Future<List<SegmentationStudentEntity>> getStudents({
    String? role,
    String? profile,
    String? program,
  }) async {
    final dtos = await _dataSource.getStudents(
      role: role,
      profile: profile,
      program: program,
    );
    return dtos.map(SegmentationMapper.studentToEntity).toList();
  }
}
