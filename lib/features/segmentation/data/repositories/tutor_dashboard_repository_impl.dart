import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/entities/tutor_status_entity.dart';
import '../../domain/repositories/tutor_dashboard_repository.dart';
import '../datasources/segmentation_remote_data_source.dart';
import '../datasources/tutor_supabase_data_source.dart';

class TutorDashboardRepositoryImpl implements TutorDashboardRepository {
  TutorDashboardRepositoryImpl(
    this._remoteDataSource,
    this._supabaseDataSource,
  );

  final SegmentationRemoteDataSource _remoteDataSource;
  final TutorSupabaseDataSource _supabaseDataSource;

  @override
  Future<TutorStatusEntity> getTutorStatus(String userId) async {
    // Active scope is authoritative. Direct group ownership is only a fallback
    // for installations that have not populated tutor_student_scope yet.
    var studentCount = await _supabaseDataSource.getTutorStudentScopeCount(
      userId,
    );
    final groupIds = await _supabaseDataSource.getTutorGroupIds(userId);

    if (studentCount == 0) {
      if (groupIds.isEmpty) {
        return const TutorStatusEntity(state: TutorState.noGroup);
      }
      studentCount = await _supabaseDataSource.getCargaAcademicaCount(groupIds);
    }

    if (studentCount == 0) {
      return TutorStatusEntity(state: TutorState.noData, groupIds: groupIds);
    }

    try {
      final summary = await _remoteDataSource.getSummary(userId: userId);
      if (summary.totalStudents > 0) {
        return TutorStatusEntity(
          state: TutorState.modelReady,
          groupIds: groupIds,
          studentCount: studentCount,
        );
      }
    } catch (_) {
      // Institutional data may exist before a segmentation run is published.
    }

    return TutorStatusEntity(
      state: TutorState.hasStudents,
      groupIds: groupIds,
      studentCount: studentCount,
    );
  }

  @override
  Future<List<SegmentationStudentEntity>> getTutorStudents(
    String userId,
  ) async {
    final dtos = await _remoteDataSource.getStudents(userId: userId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<DashboardSummaryEntity> getTutorSummary(String userId) async {
    final dto = await _remoteDataSource.getSummary(userId: userId);
    return dto.toEntity();
  }

  @override
  Future<List<SegmentationStudentEntity>> searchTutorStudents(
    String userId,
    String query,
  ) async {
    final dtos = await _remoteDataSource.searchStudents(
      userId: userId,
      query: query,
    );
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
