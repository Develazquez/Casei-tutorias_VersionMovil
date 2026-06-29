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
  String _selectedProfile = 'Todos';
  String _selectedProgram = 'Todos';

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  DashboardSummaryEntity? get summary => _summary;
  List<SegmentationStudentEntity> get students => _students;
  String get selectedProfile => _selectedProfile;
  String get selectedProgram => _selectedProgram;

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

  Future<void> _reloadStudents({String? role}) async {
    try {
      _students = await _getStudentsUseCase(
        role: role,
        profile: _selectedProfile,
        program: _selectedProgram,
      ).timeout(const Duration(seconds: 8));
      notifyListeners();
    } catch (_) {
      _errorMessage = 'No fue posible actualizar los filtros.';
      notifyListeners();
    }
  }
}
