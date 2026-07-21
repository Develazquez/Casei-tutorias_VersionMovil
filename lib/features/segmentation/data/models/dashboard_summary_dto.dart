import '../../domain/entities/dashboard_summary_entity.dart';
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

  factory DashboardSummaryDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json['results'] ?? json;
    
    final total = data['total_students'] ?? data['totalStudents'] ?? data['count'] ?? 0;
    final avgGrade = _toDouble(data['average_grade'] ?? data['averageGrade'] ?? 0.0);
    final attendance = _toDouble(data['attendance_rate'] ?? data['attendanceRate'] ?? 0.0);
    final risk = data['risk_students'] ?? data['riskStudents'] ?? 0;
    
    final clustersJson = data['clusters'] ?? data['profiles'] ?? [];
    final clustersList = (clustersJson as List)
        .map((c) => ClusterProfileDto.fromJson(c))
        .toList();

    return DashboardSummaryDto(
      totalStudents: total is int ? total : (int.tryParse(total.toString()) ?? 0),
      averageGrade: avgGrade,
      attendanceRate: attendance,
      riskStudents: risk is int ? risk : (int.tryParse(risk.toString()) ?? 0),
      clusters: clustersList,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  DashboardSummaryEntity toEntity() {
    return DashboardSummaryEntity(
      totalStudents: totalStudents,
      averageGrade: averageGrade,
      attendanceRate: attendanceRate,
      riskStudents: riskStudents,
      clusters: clusters.map((c) => c.toEntity()).toList(),
    );
  }
}
