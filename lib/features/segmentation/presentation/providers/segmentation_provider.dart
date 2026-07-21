import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_model_artifacts_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/entities/tutor_status_entity.dart';
import '../../domain/usecases/get_segmentation_model_artifacts_usecase.dart';
import '../../domain/usecases/get_tutor_status_usecase.dart';
import '../../domain/usecases/get_tutor_students_usecase.dart';
import '../../domain/usecases/get_tutor_summary_usecase.dart';
import '../../domain/usecases/search_tutor_students_usecase.dart';

import '../util/tutor_logic_utils.dart';

class SegmentationProvider extends ChangeNotifier {
  SegmentationProvider(
    this._getStatusUseCase,
    this._getStudentsUseCase,
    this._getSummaryUseCase,
    this._searchUseCase,
    this._getModelArtifactsUseCase,
  );

  final GetTutorStatusUseCase _getStatusUseCase;
  final GetTutorStudentsUseCase _getStudentsUseCase;
  final GetTutorSummaryUseCase _getSummaryUseCase;
  final SearchTutorStudentsUseCase _searchUseCase;
  final GetSegmentationModelArtifactsUseCase _getModelArtifactsUseCase;

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  TutorStatusEntity? _tutorStatus;
  DashboardSummaryEntity? _summary;
  SegmentationModelArtifactsEntity? _modelArtifacts;
  List<SegmentationStudentEntity> _tutorStudents = [];
  List<SegmentationStudentEntity> _visibleStudents = [];
  
  String _selectedProfile = 'Todos';
  String _selectedProgram = 'Todos';
  String _searchQuery = '';
  bool _isRealSearch = false;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  TutorStatusEntity? get tutorStatus => _tutorStatus;
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
    'Regular / seguimiento preventivo',
    'Atípico / buen promedio con baja asistencia',
    'Crítico / rezago alto',
    'Riesgo académico moderado',
  ];

  List<String> get programs {
    final set = _tutorStudents.map((s) => s.program).toSet();
    return ['Todos', ...set.toList()..sort()];
  }

  Future<void> load({String? role, String? userId}) async {
    if (userId == null) {
      _errorMessage = 'No se pudo identificar al usuario.';
      _state = ViewState.error;
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    
    try {
      // 1. Check Tutor Status
      _tutorStatus = await _getStatusUseCase(userId).timeout(const Duration(seconds: 10));

      if (_tutorStatus?.state == TutorState.noGroup || _tutorStatus?.state == TutorState.noData) {
        _state = ViewState.success;
        notifyListeners();
        return;
      }

      // 2. Fetch Summary
      _summary = await _getSummaryUseCase(userId).timeout(const Duration(seconds: 10));
      
      // 3. Fetch Students
      _tutorStudents = await _getStudentsUseCase(userId).timeout(const Duration(seconds: 15));

      // 4. Fetch Model Artifacts (Optional)
      try {
        _modelArtifacts = await _getModelArtifactsUseCase().timeout(const Duration(seconds: 10));
      } catch (_) {
        // Artifacts are optional for the dashboard to work
      }
      
      _applyFiltersAndSearch();
      _state = ViewState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (error) {
      _errorMessage = 'Error de conexión con el servidor CASEI. Reintente más tarde.';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  void changeSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  Future<void> search(String query, String userId) async {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _isRealSearch = false;
      _applyFiltersAndSearch();
      notifyListeners();
      return;
    }

    _state = ViewState.loading;
    notifyListeners();

    try {
      final results = await _searchUseCase(userId, query);
      _visibleStudents = results;
      _isRealSearch = true;
      _state = ViewState.success;
    } catch (_) {
      // Fallback to local search if remote fails
      _isRealSearch = false;
      _applyFiltersAndSearch();
      _state = ViewState.success;
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

  void clearSearch() {
    _searchQuery = '';
    _selectedProfile = 'Todos';
    _selectedProgram = 'Todos';
    _isRealSearch = false;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void _applyFiltersAndSearch() {
    if (_isRealSearch) return;

    var filtered = _tutorStudents;

    if (_selectedProfile != 'Todos') {
      filtered = filtered.where((s) => 
        TutorLogicUtils.normalizeProfileLabel(s.profileLabel) == _selectedProfile
      ).toList();
    }

    if (_selectedProgram != 'Todos') {
      filtered = filtered.where((s) => s.program == _selectedProgram).toList();
    }

    _visibleStudents = _applyLocalSearch(filtered);
  }

  List<SegmentationStudentEntity> _applyLocalSearch(
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
    final document = _searchDocument(student);
    var score = 0;
    for (final term in terms) {
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
        student.academicStatus ?? '',
        if (student.averageGrade < 70) 'critico promedio bajo',
        if (student.attendanceRate < 70) 'baja asistencia',
        if (student.delayedSubjects >= 3) 'rezago',
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
