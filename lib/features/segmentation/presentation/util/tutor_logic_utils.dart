import '../../domain/entities/segmentation_student_entity.dart';

abstract final class TutorLogicUtils {
  /// Normalizes student data and applies business rules for priorities.
  static List<SegmentationStudentEntity> normalizeTutorStudents(
    List<SegmentationStudentEntity> students,
  ) {
    return students;
  }

  /// Calculates a priority score to rank students who need more attention.
  static double calculatePriorityScore(SegmentationStudentEntity student) {
    double score = 0;

    // Academic Profile
    final profile = normalizeProfileLabel(student.profileLabel);
    if (profile.contains('Crítico')) {
      score += 50;
    }
    if (profile.contains('Riesgo')) {
      score += 30;
    }
    if (profile.contains('Atípico')) {
      score += 10;
    }

    // Debt subjects
    score += (student.delayedSubjects * 10);

    // Attendance
    if (student.attendanceRate < 60) {
      score += 25;
    } else if (student.attendanceRate < 70) {
      score += 15;
    } else if (student.attendanceRate < 75) {
      score += 5;
    }

    // Grade
    if (student.averageGrade < 70) {
      score += 15;
    }

    return score;
  }

  static String normalizeProfileLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('regular')) return 'Regular / seguimiento preventivo';
    if (l.contains('atípico') || l.contains('atipico')) {
      return 'Atípico / buen promedio con baja asistencia';
    }
    if (l.contains('crítico') || l.contains('critico')) {
      return 'Crítico / rezago alto';
    }
    if (l.contains('riesgo') || l.contains('moderado')) {
      return 'Riesgo académico moderado';
    }
    return label;
  }

  static bool isUrgentTracking(SegmentationStudentEntity student) {
    final profile = normalizeProfileLabel(student.profileLabel);
    final isCriticalOrRisk =
        profile.contains('Crítico') || profile.contains('Riesgo');
    final lowAttendance = student.attendanceRate < 75;
    final manyDebts = student.delayedSubjects >= 3;

    return isCriticalOrRisk && (lowAttendance || manyDebts);
  }

  static bool isLowAttendance(SegmentationStudentEntity student) {
    return student.attendanceRate < 70;
  }

  static bool isHighTrajectoryRisk(SegmentationStudentEntity student) {
    return student.attendanceRate < 60;
  }

  static String getStudentGender(SegmentationStudentEntity student) {
    final value = student.gender?.trim().toLowerCase();
    if (value == 'm' || value == 'hombre' || value == 'male') {
      return 'Hombre';
    }
    if (value == 'f' || value == 'mujer' || value == 'female') {
      return 'Mujer';
    }
    return 'Sin dato';
  }

  static List<String> getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return [parts[0][0].toUpperCase(), parts[1][0].toUpperCase()];
    }
    if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return [parts[0][0].toUpperCase()];
    }
    return ['?'];
  }

  /// Estimates term number based on cohort (fallback)
  static int getCurrentTermNumber(SegmentationStudentEntity student) {
    try {
      final cohortYear = int.parse(student.cohort);
      final currentYear = DateTime.now().year;
      final currentMonth = DateTime.now().month;

      int diffYears = currentYear - cohortYear;
      int terms = diffYears * 3;

      if (currentMonth >= 1 && currentMonth <= 4) {
        terms += 1;
      } else if (currentMonth >= 5 && currentMonth <= 8) {
        terms += 2;
      } else {
        terms += 3;
      }

      return terms.clamp(1, 12);
    } catch (_) {
      return 4; // default
    }
  }

  static String getTrajectoryRisk(SegmentationStudentEntity student) {
    final term = getCurrentTermNumber(student);
    final debts = student.delayedSubjects;

    if (term > 10 || (term >= 9 && debts > 2)) return 'Riesgo alto';
    if (term >= 9 || debts > 1) return 'Requiere permiso';
    if (debts > 0) return 'Puede terminar con extensión';
    return 'En tiempo';
  }

  static String getGraduationProjection(SegmentationStudentEntity student) {
    final term = getCurrentTermNumber(student);
    if (term <= 9) return 'Graduación normal';
    if (term <= 12) return 'Graduación extendida';
    return 'Fuera de tiempo';
  }

  static double getCurricularProgress(SegmentationStudentEntity student) {
    final term = getCurrentTermNumber(student);
    final progress = (term / 9.0) * 100;
    return progress.clamp(0.0, 100.0);
  }
}
