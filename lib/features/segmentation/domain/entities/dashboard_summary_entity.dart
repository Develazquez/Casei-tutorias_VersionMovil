import 'cluster_profile_entity.dart';

class DashboardSummaryEntity {
  const DashboardSummaryEntity({
    required this.totalStudents,
    required this.averageGrade,
    required this.attendanceRate,
    required this.riskStudents,
    required this.clusters,
  });

  final int totalStudents;
  final double averageGrade;
  final double attendanceRate;
  final int riskStudents;
  final List<ClusterProfileEntity> clusters;
}
