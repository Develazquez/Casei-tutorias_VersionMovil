import 'package:flutter/foundation.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../models/segmentation_dashboard_data.dart';
import '../util/tutor_logic_utils.dart';
import 'segmentation_provider.dart';

class SegmentationDashboardProvider extends ChangeNotifier {
  SegmentationDashboardProvider(this._sourceProvider) {
    _sourceProvider.addListener(_onSourceChanged);
    _processData();
  }

  final SegmentationProvider _sourceProvider;
  SegmentationDashboardData _data = SegmentationDashboardData.empty;

  SegmentationDashboardData get data => _data;
  bool get isLoading => _sourceProvider.state == ViewState.loading;
  String? get errorMessage => _sourceProvider.errorMessage;

  @override
  void dispose() {
    _sourceProvider.removeListener(_onSourceChanged);
    super.dispose();
  }

  void _onSourceChanged() {
    _processData();
    notifyListeners();
  }

  void _processData() {
    final students = _sourceProvider.allTutorStudents;
    if (students.isEmpty) {
      _data = SegmentationDashboardData.empty;
      return;
    }

    final total = students.length;

    // Summary Metrics
    final activeCount = students.where((s) => s.period.isNotEmpty).length;
    final alumniCount = students.where((s) => s.period.isEmpty).length;
    
    final urgentTracking = students.where((s) {
      final profile = TutorLogicUtils.normalizeProfileLabel(s.profileLabel);
      return profile == 'Crítico' || s.delayedSubjects > 0;
    }).length;

    final generationsSet = students.map((s) => s.cohort).toSet();

    // Profile Metrics
    final profileGroups = <String, List<SegmentationStudentEntity>>{};
    for (final student in students) {
      final label = TutorLogicUtils.normalizeProfileLabel(student.profileLabel);
      profileGroups.putIfAbsent(label, () => []).add(student);
    }

    final profileMetrics = profileGroups.entries.map((entry) {
      final group = entry.value;
      return ProfileMetric(
        label: entry.key,
        count: group.length,
        percentage: (group.length / total) * 100,
        averageGrade: _calculateAverage(group.map((e) => e.averageGrade)),
        averageAttendance: _calculateAverage(group.map((e) => e.attendanceRate)),
        description: _getProfileDescription(entry.key),
      );
    }).toList();

    profileMetrics.sort((a, b) => _labelPriority(b.label).compareTo(_labelPriority(a.label)));

    // Generation Metrics
    final generationGroups = <String, List<SegmentationStudentEntity>>{};
    for (final student in students) {
      generationGroups.putIfAbsent(student.cohort, () => []).add(student);
    }

    final generationMetrics = generationGroups.entries.map((entry) {
      final group = entry.value;
      final males = group.where((s) => TutorLogicUtils.getStudentGender(s) == 'Hombre').length;
      final females = group.length - males;
      return GenerationMetric(
        generation: entry.key,
        maleCount: males,
        femaleCount: females,
        totalCount: group.length,
        students: group,
      );
    }).toList()..sort((a, b) => b.generation.compareTo(a.generation));

    // Priority Students
    final priorityList = List<SegmentationStudentEntity>.from(students)
      ..sort((a, b) => TutorLogicUtils.calculatePriorityScore(b).compareTo(TutorLogicUtils.calculatePriorityScore(a)));

    _data = SegmentationDashboardData(
      activeCount: activeCount,
      alumniCount: alumniCount,
      urgentTrackingCount: urgentTracking,
      generationCount: generationsSet.length,
      profileMetrics: profileMetrics,
      priorityStudents: priorityList.take(6).toList(),
      totalStudents: total,
      generationMetrics: generationMetrics,
      isMock: total == 9,
    );
  }

  double _calculateAverage(Iterable<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  String _getProfileDescription(String label) {
    return switch (label) {
      'Regular' => 'Desempeño estable y asistencia constante.',
      'Atípico' => 'Buen promedio pero con baja asistencia o viceversa.',
      'Crítico' => 'Riesgo alto de reprobación o deserción.',
      'Riesgo moderado' => 'Requiere atención para evitar rezago.',
      _ => '',
    };
  }

  int _labelPriority(String label) {
    if (label == 'Crítico') return 4;
    if (label == 'Riesgo moderado') return 3;
    if (label == 'Atípico') return 2;
    if (label == 'Regular') return 1;
    return 0;
  }
}
