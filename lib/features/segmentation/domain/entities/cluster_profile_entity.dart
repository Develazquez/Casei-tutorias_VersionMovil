class ClusterProfileEntity {
  const ClusterProfileEntity({
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
}
