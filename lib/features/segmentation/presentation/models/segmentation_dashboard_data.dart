import '../../domain/entities/segmentation_student_entity.dart';

class SegmentationDashboardData {
  const SegmentationDashboardData({
    required this.activeCount,
    required this.alumniCount,
    required this.averageGrade,
    required this.averageAttendance,
    required this.trackingCount,
    required this.profileMetrics,
    required this.priorityStudents,
    required this.totalStudents,
    this.isMock = false,
  });

  final int activeCount;
  final int alumniCount;
  final double averageGrade;
  final double averageAttendance;
  final int trackingCount;
  final List<ProfileMetric> profileMetrics;
  final List<SegmentationStudentEntity> priorityStudents;
  final int totalStudents;
  final bool isMock;

  static const empty = SegmentationDashboardData(
    activeCount: 0,
    alumniCount: 0,
    averageGrade: 0,
    averageAttendance: 0,
    trackingCount: 0,
    profileMetrics: [],
    priorityStudents: [],
    totalStudents: 0,
  );
}

class ProfileMetric {
  const ProfileMetric({
    required this.label,
    required this.count,
    required this.percentage,
    required this.averageGrade,
    required this.averageAttendance,
  });

  final String label;
  final int count;
  final double percentage;
  final double averageGrade;
  final double averageAttendance;
}
