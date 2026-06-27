class SegmentationStudentEntity {
  const SegmentationStudentEntity({
    required this.id,
    required this.name,
    required this.program,
    required this.cohort,
    required this.period,
    required this.cluster,
    required this.profileLabel,
    required this.averageGrade,
    required this.attendanceRate,
    required this.delayedSubjects,
    required this.membershipScore,
  });

  final String id;
  final String name;
  final String program;
  final String cohort;
  final String period;
  final int cluster;
  final String profileLabel;
  final double averageGrade;
  final double attendanceRate;
  final double delayedSubjects;
  final double membershipScore;
}
