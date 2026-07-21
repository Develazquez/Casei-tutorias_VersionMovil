enum TutorState {
  noGroup,      // NO_GROUP
  noData,       // NO_DATA
  hasStudents,  // HAS_STUDENTS
  modelReady,   // MODEL_READY
  unknown
}

class TutorStatusEntity {
  const TutorStatusEntity({
    required this.state,
    this.message,
    this.groupIds = const [],
    this.studentCount = 0,
  });

  final TutorState state;
  final String? message;
  final List<String> groupIds;
  final int studentCount;

  String get displayMessage {
    if (message != null && message!.isNotEmpty) return message!;
    
    return switch (state) {
      TutorState.noGroup => 'No tienes un grupo asignado. Pide al director que te asigne un grupo desde Asignación de Tutores.',
      TutorState.noData => 'Tu grupo ya está asignado, pero aún no hay alumnos disponibles.',
      TutorState.hasStudents => 'Ya tienes tutorados cargados. Falta ejecutar o publicar el procesamiento de segmentación.',
      TutorState.modelReady => 'Dashboard completo.',
      _ => 'Estado desconocido.',
    };
  }
}
