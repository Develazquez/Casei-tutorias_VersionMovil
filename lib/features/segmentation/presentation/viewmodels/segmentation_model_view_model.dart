import 'package:flutter/material.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/segmentation_model_artifacts_entity.dart';
import '../models/segmentation_model_data.dart';
import 'segmentation_provider.dart';

class SegmentationModelViewModel extends ChangeNotifier {
  SegmentationModelViewModel(this._sourceProvider) {
    _sourceProvider.addListener(_onSourceChanged);
    _processData();
  }

  final SegmentationProvider _sourceProvider;
  SegmentationModelData _data = SegmentationModelData.empty;

  SegmentationModelData get data => _data;
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
    final artifacts = _sourceProvider.modelArtifacts;
    if (artifacts == null) {
      _data = SegmentationModelData.empty;
      return;
    }

    _data = SegmentationModelData(
      qualityMetrics: artifacts.metrics.map(_metricToViewData).toList(),
      experiments: artifacts.experiments
          .map(
            (experiment) => ModelExperimentResult(
              representation: experiment.representation,
              k: experiment.k,
              silhouette: experiment.silhouette,
              daviesBouldin: experiment.daviesBouldin,
              minSize: experiment.minSize,
              maxSize: experiment.maxSize,
              selected: experiment.selected,
            ),
          )
          .toList(),
      pcaPoints: artifacts.pcaPoints
          .map((point) => PcaPoint(x: point.x, y: point.y, label: point.label))
          .toList(),
      artifacts: artifacts.artifacts
          .map(
            (artifact) => ModelArtifactItem(
              id: artifact.id,
              displayName: artifact.displayName,
              fileName: artifact.fileName,
              createdAt: 'Storage',
              type: artifact.type,
              available: artifact.available,
            ),
          )
          .toList(),
    );
  }

  ModelQualityMetric _metricToViewData(SegmentationMetricEntity metric) {
    return ModelQualityMetric(
      name: metric.name,
      value: metric.value,
      description: metric.description,
      icon: _iconForMetric(metric.name),
      isUpGood: metric.isUpGood,
      origin: DataOrigin.real,
    );
  }

  IconData _iconForMetric(String name) {
    final normalized = name.toLowerCase();
    if (normalized.contains('silhouette')) return Icons.grain_rounded;
    if (normalized.contains('davies')) return Icons.unfold_more_rounded;
    if (normalized.contains('calinski')) return Icons.blur_on_rounded;
    if (normalized.contains('inercia')) {
      return Icons.center_focus_strong_rounded;
    }
    if (normalized.contains('precision') || normalized.contains('recall')) {
      return Icons.search_rounded;
    }
    if (normalized.contains('mrr') || normalized.contains('ndcg')) {
      return Icons.query_stats_rounded;
    }
    return Icons.analytics_outlined;
  }
}
