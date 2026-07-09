import '../../domain/entities/cluster_profile_entity.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_model_artifacts_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../models/cluster_profile_dto.dart';
import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_model_artifacts_dto.dart';
import '../models/segmentation_student_dto.dart';

class SegmentationMapper {
  const SegmentationMapper._();

  static ClusterProfileEntity clusterToEntity(ClusterProfileDto dto) {
    return ClusterProfileEntity(
      cluster: dto.cluster,
      label: dto.label,
      studentCount: dto.studentCount,
      averageGrade: dto.averageGrade,
      attendanceRate: dto.attendanceRate,
      failedSubjects: dto.failedSubjects,
      delayedSubjects: dto.delayedSubjects,
      distinctiveVariables: dto.distinctiveVariables,
    );
  }

  static DashboardSummaryEntity summaryToEntity(DashboardSummaryDto dto) {
    return DashboardSummaryEntity(
      totalStudents: dto.totalStudents,
      averageGrade: dto.averageGrade,
      attendanceRate: dto.attendanceRate,
      riskStudents: dto.riskStudents,
      clusters: dto.clusters.map(clusterToEntity).toList(),
    );
  }

  static SegmentationStudentEntity studentToEntity(SegmentationStudentDto dto) {
    return SegmentationStudentEntity(
      id: dto.id,
      name: dto.name,
      program: dto.program,
      cohort: dto.cohort,
      period: dto.period,
      cluster: dto.cluster,
      profileLabel: dto.profileLabel,
      averageGrade: dto.averageGrade,
      attendanceRate: dto.attendanceRate,
      delayedSubjects: dto.delayedSubjects,
      membershipScore: dto.membershipScore,
    );
  }

  static SegmentationModelArtifactsEntity modelArtifactsToEntity(
    SegmentationModelArtifactsDto dto,
  ) {
    return SegmentationModelArtifactsEntity(
      metrics: dto.metrics
          .map(
            (metric) => SegmentationMetricEntity(
              name: metric.name,
              value: metric.value,
              description: metric.description,
              isUpGood: metric.isUpGood,
              origin: metric.origin,
            ),
          )
          .toList(),
      experiments: dto.experiments
          .map(
            (experiment) => SegmentationExperimentEntity(
              representation: experiment.representation,
              k: experiment.k,
              silhouette: experiment.silhouette,
              daviesBouldin: experiment.daviesBouldin,
              minSize: experiment.minSize,
              maxSize: experiment.maxSize,
              selected: experiment.selected,
            ),
          )
          .toList(),
      pcaPoints: dto.pcaPoints
          .map(
            (point) => SegmentationPcaPointEntity(
              x: point.x,
              y: point.y,
              label: point.label,
            ),
          )
          .toList(),
      artifacts: dto.artifacts
          .map(
            (artifact) => SegmentationArtifactEntity(
              id: artifact.id,
              displayName: artifact.displayName,
              fileName: artifact.fileName,
              type: artifact.type,
              available: artifact.available,
            ),
          )
          .toList(),
    );
  }
}
