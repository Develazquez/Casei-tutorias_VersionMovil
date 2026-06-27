import '../models/cluster_profile_dto.dart';
import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_student_dto.dart';

class SegmentationMockDataSource {
  static const _clusters = [
    ClusterProfileDto(
      cluster: 0,
      label: 'Regular / seguimiento preventivo',
      studentCount: 646,
      averageGrade: 85.03,
      attendanceRate: 89.31,
      failedSubjects: 0.83,
      delayedSubjects: 0.43,
      distinctiveVariables:
          'Asistencia alta, desempeño estable y pocas materias reprobadas.',
    ),
    ClusterProfileDto(
      cluster: 1,
      label: 'Atípico / buen promedio con baja asistencia',
      studentCount: 55,
      averageGrade: 90.27,
      attendanceRate: 39.39,
      failedSubjects: 0,
      delayedSubjects: 0,
      distinctiveVariables:
          'Promedio alto, asistencia baja e incidencias por seguimiento.',
    ),
    ClusterProfileDto(
      cluster: 2,
      label: 'Crítico / rezago alto',
      studentCount: 104,
      averageGrade: 49.65,
      attendanceRate: 40.90,
      failedSubjects: 6.01,
      delayedSubjects: 5.71,
      distinctiveVariables:
          'Bajo desempeño, baja asistencia y rezago académico acumulado.',
    ),
    ClusterProfileDto(
      cluster: 3,
      label: 'Riesgo académico moderado',
      studentCount: 195,
      averageGrade: 67.79,
      attendanceRate: 70.16,
      failedSubjects: 3.54,
      delayedSubjects: 2.54,
      distinctiveVariables:
          'Reprobación y rezago moderados con oportunidad de intervención.',
    ),
  ];

  static final _students = [
    const SegmentationStudentDto(
      id: '233045',
      name: 'Andrea Méndez Ruiz',
      program: 'Ingeniería en Desarrollo de Software',
      cohort: '2023',
      period: '2024-1',
      cluster: 0,
      profileLabel: 'Regular / seguimiento preventivo',
      averageGrade: 88.4,
      attendanceRate: 92.1,
      delayedSubjects: 0,
      membershipScore: 0.84,
    ),
    const SegmentationStudentDto(
      id: '223014',
      name: 'Luis Fernando Pérez',
      program: 'Ingeniería en Energía',
      cohort: '2022',
      period: '2024-1',
      cluster: 1,
      profileLabel: 'Atípico / buen promedio con baja asistencia',
      averageGrade: 91.6,
      attendanceRate: 42.3,
      delayedSubjects: 0,
      membershipScore: 0.71,
    ),
    const SegmentationStudentDto(
      id: '213087',
      name: 'María José Gómez',
      program: 'Ingeniería Biomédica',
      cohort: '2021',
      period: '2024-1',
      cluster: 2,
      profileLabel: 'Crítico / rezago alto',
      averageGrade: 51.2,
      attendanceRate: 38.5,
      delayedSubjects: 6,
      membershipScore: 0.78,
    ),
    const SegmentationStudentDto(
      id: '223061',
      name: 'Carlos Hernández López',
      program: 'Ingeniería Agroindustrial',
      cohort: '2022',
      period: '2024-1',
      cluster: 3,
      profileLabel: 'Riesgo académico moderado',
      averageGrade: 69.7,
      attendanceRate: 74.2,
      delayedSubjects: 3,
      membershipScore: 0.67,
    ),
    const SegmentationStudentDto(
      id: '233102',
      name: 'Sofía Calderón Díaz',
      program: 'Ingeniería en Desarrollo de Software',
      cohort: '2023',
      period: '2024-1',
      cluster: 0,
      profileLabel: 'Regular / seguimiento preventivo',
      averageGrade: 86.8,
      attendanceRate: 90.4,
      delayedSubjects: 1,
      membershipScore: 0.81,
    ),
    const SegmentationStudentDto(
      id: '203044',
      name: 'Emiliano Torres Cruz',
      program: 'Ingeniería en Energía',
      cohort: '2020',
      period: '2024-1',
      cluster: 2,
      profileLabel: 'Crítico / rezago alto',
      averageGrade: 47.9,
      attendanceRate: 35.6,
      delayedSubjects: 7,
      membershipScore: 0.73,
    ),
  ];

  Future<DashboardSummaryDto> getSummary({String? role}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final clusters = role == 'tutor'
        ? _clusters
              .map(
                (cluster) => ClusterProfileDto(
                  cluster: cluster.cluster,
                  label: cluster.label,
                  studentCount: (cluster.studentCount * 0.08).round(),
                  averageGrade: cluster.averageGrade,
                  attendanceRate: cluster.attendanceRate,
                  failedSubjects: cluster.failedSubjects,
                  delayedSubjects: cluster.delayedSubjects,
                  distinctiveVariables: cluster.distinctiveVariables,
                ),
              )
              .toList()
        : _clusters;
    final total = clusters.fold<int>(0, (sum, item) => sum + item.studentCount);
    final risk = clusters
        .where((item) => item.cluster == 2 || item.cluster == 3)
        .fold<int>(0, (sum, item) => sum + item.studentCount);
    return DashboardSummaryDto(
      totalStudents: total,
      averageGrade: 78.28,
      attendanceRate: 77.80,
      riskStudents: risk,
      clusters: clusters,
    );
  }

  Future<List<SegmentationStudentDto>> getStudents({
    String? role,
    String? profile,
    String? program,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    Iterable<SegmentationStudentDto> result = _students;
    if (role == 'tutor') {
      result = result.take(4);
    }
    if (profile != null && profile != 'Todos') {
      result = result.where((student) => student.profileLabel == profile);
    }
    if (program != null && program != 'Todos') {
      result = result.where((student) => student.program == program);
    }
    return result.toList();
  }
}
