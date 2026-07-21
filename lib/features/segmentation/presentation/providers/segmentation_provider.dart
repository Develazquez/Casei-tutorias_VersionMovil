import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_model_artifacts_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_segmentation_model_artifacts_usecase.dart';
import '../../domain/usecases/get_segmentation_students_usecase.dart';

import '../util/tutor_logic_utils.dart';

class SegmentationProvider extends ChangeNotifier {
  SegmentationProvider(
    this._getSummaryUseCase,
    this._getStudentsUseCase,
    this._getModelArtifactsUseCase,
  );

  final GetDashboardSummaryUseCase _getSummaryUseCase;
  final GetSegmentationStudentsUseCase _getStudentsUseCase;
  final GetSegmentationModelArtifactsUseCase _getModelArtifactsUseCase;

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  DashboardSummaryEntity? _summary;
  SegmentationModelArtifactsEntity? _modelArtifacts;
  List<SegmentationStudentEntity> _rawStudents = [];
  List<SegmentationStudentEntity> _tutorStudents = [];
  List<SegmentationStudentEntity> _visibleStudents = [];
  String _selectedProfile = 'Todos';
  String _selectedProgram = 'Todos';
  String _searchQuery = '';

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  DashboardSummaryEntity? get summary => _summary;
  SegmentationModelArtifactsEntity? get modelArtifacts => _modelArtifacts;
  List<SegmentationStudentEntity> get students => _visibleStudents;
  List<SegmentationStudentEntity> get allTutorStudents => _tutorStudents;
  String get selectedProfile => _selectedProfile;
  String get selectedProgram => _selectedProgram;
  String get searchQuery => _searchQuery;
  bool get isSearchActive => _searchQuery.trim().isNotEmpty;

  List<String> get profiles => [
    'Todos',
    'Regular',
    'Atípico',
    'Crítico',
    'Riesgo moderado',
  ];

  List<String> get programs => [
    'Todos',
    'Ingeniería en Desarrollo de Software',
    'Ingeniería en Energía',
    'Ingeniería Biomédica',
    'Ingeniería Agroindustrial',
    'Ingeniería Mecatrónica',
  ];

  Future<void> load({String? role}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _summary = await _getSummaryUseCase(
        role: role,
      ).timeout(const Duration(seconds: 8));
      
      _rawStudents = await _getStudentsUseCase(
        role: role,
      ).timeout(const Duration(seconds: 8));

      // Apply normalization (max 80)
      _tutorStudents = TutorLogicUtils.normalizeTutorStudents(_rawStudents);
      
      _modelArtifacts = await _getModelArtifactsUseCase().timeout(
        const Duration(seconds: 8),
      );
      
      _applyFiltersAndSearch();
      _state = ViewState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (error) {
      _errorMessage =
          'No hemos podido conectar con el sistema académico. Por favor, revisa tu conexión a internet o intenta más tarde.';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void changeProfile(String profile) {
    _selectedProfile = profile;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void changeProgram(String program) {
    _selectedProgram = program;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void changeSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _selectedProfile = 'Todos';
    _selectedProgram = 'Todos';
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void _applyFiltersAndSearch() {
    var filtered = _tutorStudents;

    if (_selectedProfile != 'Todos') {
      filtered = filtered.where((s) => 
        TutorLogicUtils.normalizeProfileLabel(s.profileLabel) == _selectedProfile
      ).toList();
    }

    if (_selectedProgram != 'Todos') {
      filtered = filtered.where((s) => s.program == _selectedProgram).toList();
    }

    _visibleStudents = _applySearch(filtered);
  }

  List<SegmentationStudentEntity> _applySearch(
    List<SegmentationStudentEntity> source,
  ) {
    final terms = _normalize(
      _searchQuery,
    ).split(RegExp(r'\s+')).where((term) => term.length > 1).toList();
    if (terms.isEmpty) return source;

    final ranked =
        source
            .map(
              (student) => _SearchMatch(student, _scoreStudent(student, terms)),
            )
            .where((match) => match.score > 0)
            .toList()
          ..sort((a, b) => b.score.compareTo(a.score));

    return ranked.map((match) => match.student).toList();
  }

  int _scoreStudent(SegmentationStudentEntity student, List<String> terms) {
    final normalizedProgram = _normalize(student.program);
    final normalizedProfile = _normalize(student.profileLabel);
    final document = _searchDocument(student);

    var score = 0;
    for (final term in terms) {
      if (normalizedProgram.contains(term)) score += 5;
      if (normalizedProfile.contains(term)) score += 4;
      if (document.contains(term)) score += 2;
    }
    if (terms.every(document.contains)) score += 4;
    return score;
  }

  String _searchDocument(SegmentationStudentEntity student) {
    return _normalize(
      [
        student.id,
        student.name,
        student.program,
        student.cohort,
        student.period,
        student.profileLabel,
        'cluster ${student.cluster}',
        if (student.program.contains('Biomédica')) 'biomedica biomedical',
        if (student.program.contains('Software')) 'software desarrollo',
        if (student.program.contains('Energía')) 'energia',
        if (student.program.contains('Agroindustrial')) 'agroindustrial',
        if (student.averageGrade < 60)
          'critico criticos promedio bajo reprobacion',
        if (student.averageGrade >= 85) 'buen promedio alto desempeno',
        if (student.attendanceRate < 60)
          'baja asistencia ausentismo asistencias',
        if (student.delayedSubjects >= 3)
          'rezago rezagos alto atraso academico',
      ].join(' '),
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .replaceAll('ñ', 'n');
  }
}

class _SearchMatch {
  const _SearchMatch(this.student, this.score);

  final SegmentationStudentEntity student;
  final int score;
}
