import 'package:flutter/foundation.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/segmentation_student_entity.dart';
import '../models/segmentation_dashboard_data.dart';
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
    final students = _sourceProvider.students;
    if (students.isEmpty) {
      _data = SegmentationDashboardData.empty;
      return;
    }

    final total = students.length;

    // Asumimos que todos son activos por falta de campo 'estado' en entidad real
    final activeCount = total;
    final alumniCount = 0; // Sin datos

    final avgGrade = _calculateAverage(students.map((e) => e.averageGrade));
    final avgAttendance = _calculateAverage(
      students.map((e) => e.attendanceRate),
    );

    // Agrupar por perfiles (Normalización de etiquetas)
    final profileGroups = <String, List<SegmentationStudentEntity>>{};
    for (final student in students) {
      final label = _normalizeLabel(student.profileLabel);
      profileGroups.putIfAbsent(label, () => []).add(student);
    }

    final profileMetrics = profileGroups.entries.map((entry) {
      final group = entry.value;
      return ProfileMetric(
        label: entry.key,
        count: group.length,
        percentage: (group.length / total) * 100,
        averageGrade: _calculateAverage(group.map((e) => e.averageGrade)),
        averageAttendance: _calculateAverage(
          group.map((e) => e.attendanceRate),
        ),
      );
    }).toList();

    // Ordenar métricas por importancia visual (Crítico primero, etc.)
    profileMetrics.sort(
      (a, b) => _labelPriority(b.label).compareTo(_labelPriority(a.label)),
    );

    // Alumnos prioritarios: Críticos y Riesgo Moderado
    final priorityList = students.where((s) {
      final label = _normalizeLabel(s.profileLabel);
      return label.contains('Crítico') || label.contains('Riesgo');
    }).toList();

    // Ordenar prioritarios: Críticos primero, luego por promedio más bajo
    priorityList.sort((a, b) {
      final aCrit = a.profileLabel.contains('Crítico') ? 1 : 0;
      final bCrit = b.profileLabel.contains('Crítico') ? 1 : 0;
      if (aCrit != bCrit) return bCrit.compareTo(aCrit);
      return a.averageGrade.compareTo(b.averageGrade);
    });

    _data = SegmentationDashboardData(
      activeCount: activeCount,
      alumniCount: alumniCount,
      averageGrade: avgGrade,
      averageAttendance: avgAttendance,
      trackingCount: priorityList.length,
      profileMetrics: profileMetrics,
      priorityStudents: priorityList.take(4).toList(),
      totalStudents: total,
      // Detectamos si es mock basándonos en la cantidad exacta del mock (9)
      // o si no hay alumnos reales.
      isMock: total == 9,
    );
  }

  double _calculateAverage(Iterable<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  String _normalizeLabel(String label) {
    if (label.contains('Regular')) return 'Regular';
    if (label.contains('Atípico')) return 'Atípico';
    if (label.contains('Crítico')) return 'Crítico';
    if (label.contains('Riesgo')) return 'Riesgo moderado';
    return label;
  }

  int _labelPriority(String label) {
    if (label == 'Crítico') return 4;
    if (label == 'Riesgo moderado') return 3;
    if (label == 'Atípico') return 2;
    if (label == 'Regular') return 1;
    return 0;
  }
}
