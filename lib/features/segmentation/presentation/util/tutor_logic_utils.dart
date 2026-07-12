import '../../domain/entities/segmentation_student_entity.dart';

abstract final class TutorLogicUtils {
  /// Temporarily limits the number of students to 80 if backend returns too many.
  static List<SegmentationStudentEntity> normalizeTutorStudents(
    List<SegmentationStudentEntity> students,
  ) {
    if (students.length <= 80) {
      return students;
    }
    // isolated fallback: if too many, take first 80.
    // In a real scenario, this should be filtered by tutor_id in backend.
    return students.take(80).toList();
  }

  /// Calculates a priority score to rank students who need more attention.
  static double calculatePriorityScore(SegmentationStudentEntity student) {
    double score = 0;

    // Academic Profile
    final profile = normalizeProfileLabel(student.profileLabel);
    if (profile == 'Crítico') {
      score += 50;
    }
    if (profile == 'Riesgo moderado') {
      score += 30;
    }
    if (profile == 'Atípico') {
      score += 10;
    }

    // Debt subjects
    score += (student.delayedSubjects * 10);

    // Attendance
    if (student.attendanceRate < 60) {
      score += 20;
    } else if (student.attendanceRate < 80) {
      score += 10;
    }

    // Grade
    if (student.averageGrade < 70) {
      score += 15;
    }

    return score;
  }

  static String normalizeProfileLabel(String label) {
    final l = label.toLowerCase();
    if (l.contains('regular')) return 'Regular';
    if (l.contains('atípico') || l.contains('atipico')) return 'Atípico';
    if (l.contains('crítico') || l.contains('critico')) return 'Crítico';
    if (l.contains('riesgo') || l.contains('moderado')) return 'Riesgo moderado';
    return label;
  }

  /// Fallback for gender estimation if backend doesn't provide it.
  static String getStudentGender(SegmentationStudentEntity student) {
    // determinist fallback based on ID or Name
    if (student.name.trim().isEmpty) return 'Hombre';
    final namePart = student.name.trim().split(' ').first;
    final lastChar = namePart.toLowerCase()[namePart.length - 1];
    if (['a', 'e', 'i', 'x'].contains(lastChar)) {
      return 'Mujer';
    }
    return 'Hombre';
  }

  /// Estimates term number based on cohort (fallback)
  static int getCurrentTermNumber(SegmentationStudentEntity student) {
    try {
      final cohortYear = int.parse(student.cohort);
      final currentYear = DateTime.now().year;
      final currentMonth = DateTime.now().month;
      
      // UP Chiapas usually has 3 terms per year
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
    // Rough estimation: 100% / 9 terms = ~11% per term
    final progress = (term / 9.0) * 100;
    return progress.clamp(0.0, 100.0);
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
}
