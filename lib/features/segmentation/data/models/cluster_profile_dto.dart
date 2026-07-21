import '../../domain/entities/cluster_profile_entity.dart';

class ClusterProfileDto {
  const ClusterProfileDto({
    required this.cluster,
    required this.label,
    required this.studentCount,
    required this.averageGrade,
    required this.attendanceRate,
    required this.failedSubjects,
    required this.delayedSubjects,
    required this.distinctiveVariables,
  });

  final int cluster;
  final String label;
  final int studentCount;
  final double averageGrade;
  final double attendanceRate;
  final double failedSubjects;
  final double delayedSubjects;
  final String distinctiveVariables;

  factory ClusterProfileDto.fromJson(Map<String, dynamic> json) {
    return ClusterProfileDto(
      cluster: json['cluster'] ?? 0,
      label: json['label'] ?? json['profile_name'] ?? 'Desconocido',
      studentCount: json['student_count'] ?? json['count'] ?? 0,
      averageGrade: _toDouble(json['average_grade'] ?? 0.0),
      attendanceRate: _toDouble(json['attendance_rate'] ?? 0.0),
      failedSubjects: _toDouble(json['failed_subjects'] ?? 0.0),
      delayedSubjects: _toDouble(json['delayed_subjects'] ?? 0.0),
      distinctiveVariables: json['distinctive_variables']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  ClusterProfileEntity toEntity() {
    return ClusterProfileEntity(
      cluster: cluster,
      label: label,
      studentCount: studentCount,
      averageGrade: averageGrade,
      attendanceRate: attendanceRate,
      failedSubjects: failedSubjects,
      delayedSubjects: delayedSubjects,
      distinctiveVariables: distinctiveVariables,
    );
  }
}
