import '../entities/segmentation_student_entity.dart';
import '../models/tutor_search_models.dart';

class SearchTutoradosUseCase {
  static const double lowAttendanceThreshold = 60.0;

  TutorSearchResult call(List<SegmentationStudentEntity> students, TutorSearchQuery query) {
    if (query.isEmpty) {
      return TutorSearchResult(students: [], totalCount: students.length);
    }

    final filtered = students.where((student) {
      // 1. Filtro por perfiles (OR dentro de categoría)
      if (query.profiles.isNotEmpty) {
        final matchesProfile = query.profiles.any((p) => 
          student.profileLabel.toLowerCase().contains(p.toLowerCase()));
        if (!matchesProfile) return false;
      }

      // 2. Filtro por generaciones (OR dentro de categoría)
      if (query.generations.isNotEmpty) {
        if (!query.generations.contains(student.cohort)) return false;
      }

      // 3. Filtro por baja asistencia (AND)
      if (query.lowAttendanceOnly) {
        if (student.attendanceRate >= lowAttendanceThreshold) return false;
      }

      // 4. Filtro por egresados (AND) - Nota: No disponible en entidad real actual
      if (query.alumniOnly) return false;

      // 5. Búsqueda por texto (AND)
      if (query.text.isNotEmpty) {
        final normalizedQuery = _normalize(query.text);
        final tokens = normalizedQuery.split(RegExp(r'\s+')).where((t) => t.length > 1);
        
        final studentDoc = _normalize([
          student.name,
          student.id,
          student.program,
          student.profileLabel,
        ].join(' '));

        if (!tokens.every((token) => studentDoc.contains(token))) return false;
      }

      return true;
    }).toList();

    // Ordenar resultados: Críticos primero, luego Riesgo, luego alfabético
    filtered.sort((a, b) {
      final aWeight = _getProfileWeight(a.profileLabel);
      final bWeight = _getProfileWeight(b.profileLabel);
      if (aWeight != bWeight) return bWeight.compareTo(aWeight);
      return a.name.compareTo(b.name);
    });

    return TutorSearchResult(
      students: filtered,
      totalCount: filtered.length,
    );
  }

  String _normalize(String text) {
    return text.toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }

  int _getProfileWeight(String label) {
    if (label.contains('Crítico')) return 4;
    if (label.contains('Riesgo')) return 3;
    if (label.contains('Atípico')) return 2;
    if (label.contains('Regular')) return 1;
    return 0;
  }
}
