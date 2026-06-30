import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/cluster_profile_dto.dart';
import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_student_dto.dart';
import 'segmentation_data_source.dart';
import 'segmentation_mock_data_source.dart';

class SegmentationSupabaseStorageDataSource implements SegmentationDataSource {
  SegmentationSupabaseStorageDataSource(this._client, this._fallback);

  final SupabaseClient _client;
  final SegmentationMockDataSource _fallback;

  _SegmentationArtifacts? _cache;

  @override
  Future<DashboardSummaryDto> getSummary({String? role}) async {
    try {
      final artifacts = await _loadArtifacts();
      final students = _scopeStudents(artifacts.students, role: role);
      final clusters = _buildProfileClusters(students);
      final total = clusters.fold<int>(
        0,
        (sum, cluster) => sum + cluster.studentCount,
      );
      final risk = clusters
          .where((cluster) => cluster.label != _ProfileLabels.regular)
          .fold<int>(0, (sum, cluster) => sum + cluster.studentCount);

      return DashboardSummaryDto(
        totalStudents: total,
        averageGrade: _average(students.map((student) => student.averageGrade)),
        attendanceRate: _average(
          students.map((student) => student.attendanceRate),
        ),
        riskStudents: risk,
        clusters: clusters,
      );
    } catch (_) {
      return _fallback.getSummary(role: role);
    }
  }

  @override
  Future<List<SegmentationStudentDto>> getStudents({
    String? role,
    String? profile,
    String? program,
  }) async {
    try {
      final artifacts = await _loadArtifacts();
      Iterable<SegmentationStudentDto> result = _scopeStudents(
        artifacts.students,
        role: role,
      );
      if (profile != null && profile != 'Todos') {
        result = result.where((student) => student.profileLabel == profile);
      }
      if (program != null && program != 'Todos') {
        result = result.where((student) => student.program == program);
      }
      return result.take(200).toList();
    } catch (_) {
      return _fallback.getStudents(
        role: role,
        profile: profile,
        program: program,
      );
    }
  }

  Future<_SegmentationArtifacts> _loadArtifacts() async {
    if (_cache != null) return _cache!;

    final rawCsv = await _downloadText(
      'data/raw/dataset_sintetico_alumnos_v2.csv',
    );
    final assignmentsCsv = await _downloadText(
      'data/processed/cluster_assignments.csv',
    );

    final rawRows = _parseCsv(rawCsv);
    final assignmentRows = _parseCsv(assignmentsCsv);
    final assignmentByKey = {
      for (final row in assignmentRows)
        '${row['id_estudiante']}::${row['id_periodo']}': row,
    };

    final students = <SegmentationStudentDto>[];
    for (final row in rawRows) {
      final key = '${row['id_estudiante']}::${row['id_periodo']}';
      final assignment = assignmentByKey[key];
      if (assignment == null) continue;

      final averageGrade = _toDouble(row['promedio_general']);
      final attendanceRate = _toDouble(row['porcentaje_asistencia']);
      final delayedSubjects = _toDouble(row['rezago_materias']);
      final failedSubjects = _toDouble(
        row['materias_reprobadas_acumuladas'] ?? row['materias_reprobadas'],
      );
      final profile = _inferProfile(
        averageGrade: averageGrade,
        attendanceRate: attendanceRate,
        failedSubjects: failedSubjects,
        delayedSubjects: delayedSubjects,
      );

      students.add(
        SegmentationStudentDto(
          id: row['id_estudiante'] ?? key,
          name:
              'Alumno ${(row['id_estudiante'] ?? key).substring(0, 8).toUpperCase()}',
          program: row['programa'] ?? 'Sin programa',
          cohort: row['cohorte'] ?? '-',
          period: row['id_periodo'] ?? '-',
          cluster: _toInt(assignment['cluster']),
          profileLabel: profile,
          averageGrade: averageGrade,
          attendanceRate: attendanceRate,
          delayedSubjects: delayedSubjects,
          membershipScore: _toDouble(assignment['membership_score']),
        ),
      );
    }

    _cache = _SegmentationArtifacts(students);
    return _cache!;
  }

  Future<String> _downloadText(String artifactPath) async {
    final storagePath =
        '${AppConstants.segmentationStoragePrefix}/$artifactPath';
    final Uint8List bytes = await _client.storage
        .from(AppConstants.segmentationStorageBucket)
        .download(storagePath)
        .timeout(const Duration(seconds: 8));
    return utf8.decode(bytes);
  }

  List<ClusterProfileDto> _buildProfileClusters(
    List<SegmentationStudentDto> students,
  ) {
    return _ProfileLabels.ordered.map((label) {
      final group = students
          .where((student) => student.profileLabel == label)
          .toList(growable: false);
      return ClusterProfileDto(
        cluster: _ProfileLabels.ordered.indexOf(label),
        label: label,
        studentCount: group.length,
        averageGrade: _average(group.map((student) => student.averageGrade)),
        attendanceRate: _average(
          group.map((student) => student.attendanceRate),
        ),
        failedSubjects: 0,
        delayedSubjects: _average(
          group.map((student) => student.delayedSubjects),
        ),
        distinctiveVariables: _distinctiveText(label),
      );
    }).toList();
  }

  List<SegmentationStudentDto> _scopeStudents(
    List<SegmentationStudentDto> students, {
    String? role,
  }) {
    if (role == 'tutor') return students.take(80).toList();
    return students;
  }

  String _inferProfile({
    required double averageGrade,
    required double attendanceRate,
    required double failedSubjects,
    required double delayedSubjects,
  }) {
    if (averageGrade >= 85 && attendanceRate < 60) {
      return _ProfileLabels.atypical;
    }
    if (averageGrade < 60 && delayedSubjects >= 4) {
      return _ProfileLabels.critical;
    }
    if (averageGrade >= 70 &&
        attendanceRate >= 65 &&
        failedSubjects <= 2 &&
        delayedSubjects <= 2) {
      return _ProfileLabels.regular;
    }
    return _ProfileLabels.moderateRisk;
  }

  String _distinctiveText(String label) {
    return switch (label) {
      _ProfileLabels.regular =>
        'Desempeño estable, asistencia suficiente y bajo rezago.',
      _ProfileLabels.atypical =>
        'Promedio alto con baja asistencia; revisar causas operativas.',
      _ProfileLabels.critical =>
        'Promedio bajo, rezago alto y prioridad tutorial.',
      _ => 'Riesgo académico moderado con seguimiento recomendado.',
    };
  }

  List<Map<String, String>> _parseCsv(String content) {
    final rows = <List<String>>[];
    var current = StringBuffer();
    var row = <String>[];
    var inQuotes = false;

    for (var index = 0; index < content.length; index++) {
      final char = content[index];
      final next = index + 1 < content.length ? content[index + 1] : '';
      if (char == '"' && inQuotes && next == '"') {
        current.write('"');
        index++;
        continue;
      }
      if (char == '"') {
        inQuotes = !inQuotes;
        continue;
      }
      if (char == ',' && !inQuotes) {
        row.add(current.toString());
        current = StringBuffer();
        continue;
      }
      if ((char == '\n' || char == '\r') && !inQuotes) {
        if (char == '\r' && next == '\n') index++;
        row.add(current.toString());
        if (row.any((value) => value.isNotEmpty)) rows.add(row);
        row = <String>[];
        current = StringBuffer();
        continue;
      }
      current.write(char);
    }

    if (current.isNotEmpty || row.isNotEmpty) {
      row.add(current.toString());
      rows.add(row);
    }
    if (rows.isEmpty) return [];

    final headers = rows.first;
    return rows.skip(1).map((values) {
      final mapped = <String, String>{};
      for (var index = 0; index < headers.length; index++) {
        mapped[headers[index]] = index < values.length ? values[index] : '';
      }
      return mapped;
    }).toList();
  }

  double _average(Iterable<double> values) {
    final clean = values.where((value) => value.isFinite).toList();
    if (clean.isEmpty) return 0;
    return clean.reduce((a, b) => a + b) / clean.length;
  }

  double _toDouble(String? value) {
    return double.tryParse(value ?? '') ?? 0;
  }

  int _toInt(String? value) {
    return int.tryParse(value ?? '') ?? 0;
  }
}

class _SegmentationArtifacts {
  const _SegmentationArtifacts(this.students);

  final List<SegmentationStudentDto> students;
}

class _ProfileLabels {
  const _ProfileLabels._();

  static const regular = 'Regular / seguimiento preventivo';
  static const atypical = 'Atípico / buen promedio con baja asistencia';
  static const critical = 'Crítico / rezago alto';
  static const moderateRisk = 'Riesgo académico moderado';

  static const ordered = [regular, atypical, critical, moderateRisk];
}
