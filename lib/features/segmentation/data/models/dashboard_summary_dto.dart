import 'cluster_profile_dto.dart';

class DashboardSummaryDto {
  const DashboardSummaryDto({
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
  final List<ClusterProfileDto> clusters;
}
