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
    // 1. Check groups
    final groupIds = await _supabaseDataSource.getTutorGroupIds(userId);
    if (groupIds.isEmpty) {
      return const TutorStatusEntity(state: TutorState.noGroup);
    }

    // 2. Check scope
    var studentCount = await _supabaseDataSource.getTutorStudentScopeCount(userId);
    
    // 3. Fallback to carga_academica
    if (studentCount == 0) {
      studentCount = await _supabaseDataSource.getCargaAcademicaCount(groupIds);
    }

    if (studentCount == 0) {
      return TutorStatusEntity(
        state: TutorState.noData,
        groupIds: groupIds,
      );
    }

    // 4. Check segmentation results (MODEL_READY)
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
      // If summary fails or returns 0, it might be HAS_STUDENTS
    }

    return TutorStatusEntity(
      state: TutorState.hasStudents,
      groupIds: groupIds,
      studentCount: studentCount,
    );
  }

  @override
  Future<List<SegmentationStudentEntity>> getTutorStudents(String userId) async {
    final dtos = await _remoteDataSource.getStudents(userId: userId);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<DashboardSummaryEntity> getTutorSummary(String userId) async {
    final dto = await _remoteDataSource.getSummary(userId: userId);
    return dto.toEntity();
  }

  @override
  Future<List<SegmentationStudentEntity>> searchTutorStudents(String userId, String query) async {
    final dtos = await _remoteDataSource.searchStudents(userId: userId, query: query);
    return dtos.map((dto) => dto.toEntity()).toList();
  }
}
