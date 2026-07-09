import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/cluster_profile_dto.dart';
import '../models/dashboard_summary_dto.dart';
import '../models/segmentation_model_artifacts_dto.dart';
import '../models/segmentation_student_dto.dart';
import 'segmentation_data_source.dart';

class SegmentationSupabaseStorageDataSource implements SegmentationDataSource {
  SegmentationSupabaseStorageDataSource(this._client);

  final SupabaseClient _client;

  _SegmentationArtifacts? _cache;

  @override
  Future<DashboardSummaryDto> getSummary({String? role}) async {
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
  }

  @override
  Future<List<SegmentationStudentDto>> getStudents({
    String? role,
    String? profile,
    String? program,
  }) async {
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
    return result.toList();
  }

  @override
  Future<SegmentationModelArtifactsDto> getModelArtifacts() async {
    final loaded = await _loadArtifacts();
    final metadataText = await _downloadText('artifacts/kmeans_metadata.json');
    final kMetricsCsv = await _downloadText(
      'data/reports/k_selection_metrics.csv',
    );
    final searchMetricsCsv = await _downloadText(
      'data/reports/search_metrics.csv',
    );
    final pcaScoresCsv = await _downloadText('data/processed/pca_scores.csv');

    final metadata = jsonDecode(metadataText) as Map<String, dynamic>;
    final modelMetrics = metadata['metrics'] as Map<String, dynamic>? ?? {};
    final selectedRepresentation =
        metadata['selected_representation']?.toString() ?? '-';
    final selectedK = _toIntValue(metadata['selected_k']);

    final kRows = _parseCsv(kMetricsCsv);
    final searchRows = _parseCsv(searchMetricsCsv);
    final pcaRows = _parseCsv(pcaScoresCsv);

    final profileByKey = {
      for (final student in loaded.students)
        '${student.id}::${student.period}': student.profileLabel,
    };

    return SegmentationModelArtifactsDto(
      metrics: [
        SegmentationMetricDto(
          name: 'K seleccionado',
          value: selectedK.toDouble(),
          description: selectedRepresentation,
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Silhouette',
          value: _toDoubleValue(modelMetrics['silhouette']),
          description: 'Cohesión',
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Davies-Bouldin',
          value: _toDoubleValue(modelMetrics['davies_bouldin']),
          description: 'Separación',
          isUpGood: false,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Calinski-Harabasz',
          value: _toDoubleValue(modelMetrics['calinski_harabasz']),
          description: 'Densidad',
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Inercia',
          value: _toDoubleValue(modelMetrics['inertia']),
          description: 'Dist. intra-cluster',
          isUpGood: false,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Precision@10',
          value: _average(
            searchRows.map((row) => _toDouble(row['precision@10'])),
          ),
          description: 'BM25',
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'Recall@10',
          value: _average(searchRows.map((row) => _toDouble(row['recall@10']))),
          description: 'BM25',
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'MRR@10',
          value: _average(searchRows.map((row) => _toDouble(row['mrr@10']))),
          description: 'BM25',
          isUpGood: true,
          origin: 'storage',
        ),
        SegmentationMetricDto(
          name: 'NDCG@10',
          value: _average(searchRows.map((row) => _toDouble(row['ndcg@10']))),
          description: 'BM25',
          isUpGood: true,
          origin: 'storage',
        ),
      ],
      experiments: kRows
          .map(
            (row) => SegmentationExperimentDto(
              representation: row['representation'] ?? '-',
              k: _toInt(row['k']),
              silhouette: _toDouble(row['silhouette']),
              daviesBouldin: _toDouble(row['davies_bouldin']),
              minSize: _toInt(row['min_cluster_size']),
              maxSize: _toInt(row['max_cluster_size']),
              selected:
                  (row['representation'] ?? '') == selectedRepresentation &&
                  _toInt(row['k']) == selectedK,
            ),
          )
          .toList(),
      pcaPoints: pcaRows
          .where((row) => row.containsKey('PC1') && row.containsKey('PC2'))
          .take(180)
          .map((row) {
            final key = '${row['id_estudiante']}::${row['id_periodo']}';
            return SegmentationPcaPointDto(
              x: _toDouble(row['PC1']),
              y: _toDouble(row['PC2']),
              label: profileByKey[key] ?? 'Sin perfil',
            );
          })
          .toList(),
      artifacts: const [
        SegmentationArtifactDto(
          id: 'cluster_assignments',
          displayName: 'Asignaciones de cluster',
          fileName: 'data/processed/cluster_assignments.csv',
          type: 'CSV',
          available: true,
        ),
        SegmentationArtifactDto(
          id: 'student_period_features',
          displayName: 'Dataset alumno-periodo',
          fileName: 'data/processed/student_period_features.csv',
          type: 'CSV',
          available: true,
        ),
        SegmentationArtifactDto(
          id: 'k_selection_metrics',
          displayName: 'Comparación de K',
          fileName: 'data/reports/k_selection_metrics.csv',
          type: 'CSV',
          available: true,
        ),
        SegmentationArtifactDto(
          id: 'search_metrics',
          displayName: 'Métricas BM25',
          fileName: 'data/reports/search_metrics.csv',
          type: 'CSV',
          available: true,
        ),
        SegmentationArtifactDto(
          id: 'pca_scores',
          displayName: 'Dispersión PC1/PC2',
          fileName: 'data/processed/pca_scores.csv',
          type: 'CSV',
          available: true,
        ),
        SegmentationArtifactDto(
          id: 'kmeans_metadata',
          displayName: 'Metadata K-Means',
          fileName: 'artifacts/kmeans_metadata.json',
          type: 'JSON',
          available: true,
        ),
      ],
    );
  }

  Future<_SegmentationArtifacts> _loadArtifacts() async {
    if (_cache != null) return _cache!;

    final rawRows = await _downloadFirstAvailableAnalyticRows([
      'data/processed/student_period_features.csv',
      'data/raw/dataset_crudo_2000_estudiantes.csv',
      'data/raw/dataset_sintetico_alumnos_v2.csv',
    ]);
    final assignmentsCsv = await _downloadText(
      'data/processed/cluster_assignments.csv',
    );

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

    if (students.isEmpty) {
      throw StateError(
        'No se encontraron alumnos segmentados en Supabase Storage. '
        'Revisa que cluster_assignments.csv y student_period_features.csv compartan id_estudiante e id_periodo.',
      );
    }

    _cache = _SegmentationArtifacts(students);
    return _cache!;
  }

  Future<List<Map<String, String>>> _downloadFirstAvailableAnalyticRows(
    List<String> artifactPaths,
  ) async {
    final errors = <String>[];
    for (final path in artifactPaths) {
      try {
        final rows = _parseCsv(await _downloadText(path));
        if (rows.isNotEmpty && _hasAnalyticColumns(rows.first)) {
          return rows;
        }
        errors.add('$path: no contiene columnas analíticas requeridas');
      } catch (error) {
        errors.add('$path: $error');
      }
    }
    throw StateError(
      'No se pudo descargar un dataset de alumnos desde Supabase Storage. '
      'Intentos: ${errors.join(' | ')}',
    );
  }

  Future<String> _downloadText(String artifactPath) async {
    final prefix = AppConstants.segmentationStoragePrefix.trim();
    final storagePath = prefix.isEmpty ? artifactPath : '$prefix/$artifactPath';
    final Uint8List bytes = await _client.storage
        .from(AppConstants.segmentationStorageBucket)
        .download(storagePath)
        .timeout(const Duration(seconds: 8));
    return utf8.decode(bytes);
  }

  bool _hasAnalyticColumns(Map<String, String> row) {
    return row.containsKey('id_estudiante') &&
        row.containsKey('id_periodo') &&
        row.containsKey('programa') &&
        row.containsKey('promedio_general') &&
        row.containsKey('rezago_materias');
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

    final headers = rows.first
        .map((header) => header.replaceFirst('\ufeff', '').trim())
        .toList();
    return rows.skip(1).map((values) {
      final mapped = <String, String>{};
      for (var index = 0; index < headers.length; index++) {
        mapped[headers[index]] = index < values.length
            ? values[index].trim()
            : '';
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

  double _toDoubleValue(Object? value) {
    if (value is num) return value.toDouble();
    return _toDouble(value?.toString());
  }

  int _toIntValue(Object? value) {
    if (value is num) return value.toInt();
    return _toInt(value?.toString());
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
