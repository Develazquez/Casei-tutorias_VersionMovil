import '../../domain/entities/segmentation_student_entity.dart';

class SegmentationDashboardData {
  const SegmentationDashboardData({
    required this.activeCount,
    required this.alumniCount,
    required this.urgentTrackingCount,
    required this.generationCount,
    required this.profileMetrics,
    required this.priorityStudents,
    required this.totalStudents,
    required this.generationMetrics,
    this.isMock = false,
  });

  final int activeCount;
  final int alumniCount;
  final int urgentTrackingCount;
  final int generationCount;
  final List<ProfileMetric> profileMetrics;
  final List<SegmentationStudentEntity> priorityStudents;
  final int totalStudents;
  final List<GenerationMetric> generationMetrics;
  final bool isMock;

  static const empty = SegmentationDashboardData(
    activeCount: 0,
    alumniCount: 0,
    urgentTrackingCount: 0,
    generationCount: 0,
    profileMetrics: [],
    priorityStudents: [],
    totalStudents: 0,
    generationMetrics: [],
  );
}

class ProfileMetric {
  const ProfileMetric({
    required this.label,
    required this.count,
    required this.percentage,
    required this.averageGrade,
    required this.averageAttendance,
    this.description = '',
  });

  final String label;
  final int count;
  final double percentage;
  final double averageGrade;
  final double averageAttendance;
  final String description;
}

class GenerationMetric {
  const GenerationMetric({
    required this.generation,
    required this.maleCount,
    required this.femaleCount,
    required this.totalCount,
    required this.students,
  });

  final String generation;
  final int maleCount;
  final int femaleCount;
  final int totalCount;
  final List<SegmentationStudentEntity> students;
}
