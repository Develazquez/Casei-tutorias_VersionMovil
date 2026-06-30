import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/view_state.dart';
import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../../domain/usecases/get_dashboard_summary_usecase.dart';
import '../../domain/usecases/get_segmentation_students_usecase.dart';

class SegmentationProvider extends ChangeNotifier {
  SegmentationProvider(this._getSummaryUseCase, this._getStudentsUseCase);

  final GetDashboardSummaryUseCase _getSummaryUseCase;
  final GetSegmentationStudentsUseCase _getStudentsUseCase;

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  DashboardSummaryEntity? _summary;
  List<SegmentationStudentEntity> _students = [];
  List<SegmentationStudentEntity> _visibleStudents = [];
  String _selectedProfile = 'Todos';
  String _selectedProgram = 'Todos';
  String _searchQuery = '';

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  DashboardSummaryEntity? get summary => _summary;
  List<SegmentationStudentEntity> get students => _visibleStudents;
  String get selectedProfile => _selectedProfile;
  String get selectedProgram => _selectedProgram;
  String get searchQuery => _searchQuery;
  bool get isSearchActive => _searchQuery.trim().isNotEmpty;

  List<String> get profiles => [
    'Todos',
    ...?_summary?.clusters.map((cluster) => cluster.label),
  ];

  List<String> get programs => [
    'Todos',
    'Ingeniería en Desarrollo de Software',
    'Ingeniería en Energía',
    'Ingeniería Biomédica',
    'Ingeniería Agroindustrial',
  ];

  Future<void> load({String? role}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _summary = await _getSummaryUseCase(
        role: role,
      ).timeout(const Duration(seconds: 8));
      _students = await _getStudentsUseCase(
        role: role,
        profile: _selectedProfile,
        program: _selectedProgram,
      ).timeout(const Duration(seconds: 8));
      _visibleStudents = _applySearch(_students);
      _state = ViewState.success;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
    } catch (_) {
      _errorMessage = 'No fue posible cargar la segmentación.';
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> changeProfile(String profile, {String? role}) async {
    _selectedProfile = profile;
    await _reloadStudents(role: role);
  }

  Future<void> changeProgram(String program, {String? role}) async {
    _selectedProgram = program;
    await _reloadStudents(role: role);
  }

  void changeSearchQuery(String query) {
    _searchQuery = query;
    _visibleStudents = _applySearch(_students);
    notifyListeners();
  }

  void clearSearch() {
    if (_searchQuery.isEmpty) return;
    _searchQuery = '';
    _visibleStudents = _students;
    notifyListeners();
  }

  Future<void> _reloadStudents({String? role}) async {
    try {
      _students = await _getStudentsUseCase(
        role: role,
        profile: _selectedProfile,
        program: _selectedProgram,
      ).timeout(const Duration(seconds: 8));
      _visibleStudents = _applySearch(_students);
      notifyListeners();
    } catch (_) {
      _errorMessage = 'No fue posible actualizar los filtros.';
      notifyListeners();
    }
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
    final document = _normalize(
      [
        student.id,
        student.name,
        student.program,
        student.cohort,
        student.period,
        student.profileLabel,
        'cluster ${student.cluster}',
        if (student.averageGrade < 60) 'critico criticos promedio bajo',
        if (student.averageGrade >= 85) 'buen promedio alto desempeno',
        if (student.attendanceRate < 60) 'baja asistencia ausentismo',
        if (student.delayedSubjects >= 3) 'rezago alto atraso academico',
      ].join(' '),
    );

    var score = 0;
    for (final term in terms) {
      if (document.contains(term)) score += 2;
    }
    if (terms.every(document.contains)) score += 4;
    return score;
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
