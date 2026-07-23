import '../../domain/entities/segmentation_student_entity.dart';

class SegmentationStudentDto {
  const SegmentationStudentDto({
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
    this.distanceToCentroid,
    this.gender,
    this.academicStatus,
    this.failedSubjects,
    this.lagSubjects,
    this.periodGrade,
    this.semester,
    this.graduationProjection,
    this.email,
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
  final double? distanceToCentroid;
  final String? gender;
  final String? academicStatus;
  final double? failedSubjects;
  final double? lagSubjects;
  final double? periodGrade;
  final String? semester;
  final String? graduationProjection;
  final String? email;

  factory SegmentationStudentDto.fromJson(Map<String, dynamic> json) {
    // Aliases normalization
    final id =
        json['id_estudiante'] ??
        json['student_id'] ??
        json['matricula'] ??
        json['studentId'] ??
        json['id'] ??
        '';
    final name =
        json['nombre'] ??
        json['name'] ??
        json['student_name'] ??
        json['studentName'] ??
        '';
    final program = json['programa'] ?? json['program'] ?? '';
    final cohort = json['cohorte'] ?? json['cohort'] ?? '';

    final period =
        json['id_periodo'] ??
        json['period_id'] ??
        json['periodo'] ??
        json['period'] ??
        json['periodId'] ??
        '';

    final cluster = json['cluster'] ?? 0;

    final profileLabel =
        json['perfil_academico'] ??
        json['perfil_sugerido'] ??
        json['cluster_profile'] ??
        json['profile'] ??
        json['profileLabel'] ??
        'Sin segmentación';

    final averageGrade = _toDouble(
      json['promedio_general'] ??
          json['average_grade'] ??
          json['averageGrade'] ??
          json['average_grade'] ??
          0.0,
    );
    final attendanceRate = _toDouble(
      json['porcentaje_asistencia'] ??
          json['attendance_rate'] ??
          json['attendanceRate'] ??
          0.0,
    );

    final failedSubs = _toDouble(
      json['materias_reprobadas_acumuladas'] ??
          json['materias_reprobadas'] ??
          json['failed_subjects'] ??
          json['failedSubjects'] ??
          0.0,
    );
    final lagSubs = _toDouble(
      json['rezago_materias'] ??
          json['lag_subjects'] ??
          json['lagSubjects'] ??
          0.0,
    );

    final membershipScore = _toDouble(
      json['membership_score'] ?? json['membershipScore'] ?? 0.0,
    );
    final distanceToCentroid = _toDouble(
      json['distance_to_centroid'] ?? json['distanceToCentroid'],
    );

    final gender = json['sexo'] ?? json['gender'];
    final academicStatus = json['estatus_academico'] ?? json['academic_status'];

    final periodGrade = _toDouble(
      json['promedio_periodo'] ?? json['period_grade'] ?? json['periodGrade'],
    );

    final semester = json['cuatrimestre'] ?? json['semester'];
    final graduationProjection =
        json['proyeccion_egreso'] ?? json['graduation_projection'];
    final email = json['correo'] ?? json['email'];

    return SegmentationStudentDto(
      id: id.toString(),
      name: name.toString(),
      program: program.toString(),
      cohort: cohort.toString(),
      period: period.toString(),
      cluster: cluster is int
          ? cluster
          : (int.tryParse(cluster.toString()) ?? 0),
      profileLabel: profileLabel.toString(),
      averageGrade: averageGrade,
      attendanceRate: attendanceRate,
      delayedSubjects: lagSubs > 0 ? lagSubs : failedSubs, // Fallback logic
      membershipScore: membershipScore,
      distanceToCentroid: distanceToCentroid,
      gender: gender?.toString(),
      academicStatus: academicStatus?.toString(),
      failedSubjects: failedSubs,
      lagSubjects: lagSubs,
      periodGrade: periodGrade,
      semester: semester?.toString(),
      graduationProjection: graduationProjection?.toString(),
      email: email?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  SegmentationStudentEntity toEntity() {
    return SegmentationStudentEntity(
      id: id,
      name: name,
      program: program,
      cohort: cohort,
      period: period,
      cluster: cluster,
      profileLabel: profileLabel,
      averageGrade: averageGrade,
      attendanceRate: attendanceRate,
      delayedSubjects: delayedSubjects,
      membershipScore: membershipScore,
      gender: gender,
      academicStatus: academicStatus,
      semester: semester,
      graduationProjection: graduationProjection,
      email: email,
    );
  }
}
