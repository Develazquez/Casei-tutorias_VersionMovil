import 'package:flutter/material.dart';

enum DataOrigin { real, derived, mock, unavailable }

class ModelQualityMetric {
  const ModelQualityMetric({
    required this.name,
    required this.value,
    required this.description,
    required this.icon,
    required this.isUpGood,
    this.origin = DataOrigin.mock,
  });

  final String name;
  final double value;
  final String description;
  final IconData icon;
  final bool isUpGood;
  final DataOrigin origin;
}

class ModelExperimentResult {
  const ModelExperimentResult({
    required this.representation,
    required this.k,
    required this.silhouette,
    required this.daviesBouldin,
    required this.minSize,
    required this.maxSize,
    this.selected = false,
  });

  final String representation;
  final int k;
  final double silhouette;
  final double daviesBouldin;
  final int minSize;
  final int maxSize;
  final bool selected;
}

class PcaPoint {
  const PcaPoint({
    required this.x,
    required this.y,
    required this.label,
  });

  final double x;
  final double y;
  final String label;
}

class ModelArtifactItem {
  const ModelArtifactItem({
    required this.id,
    required this.displayName,
    required this.fileName,
    required this.createdAt,
    this.type = 'CSV',
    this.available = true,
  });

  final String id;
  final String displayName;
  final String fileName;
  final String createdAt;
  final String type;
  final bool available;
}

class SegmentationModelData {
  const SegmentationModelData({
    required this.qualityMetrics,
    required this.experiments,
    required this.pcaPoints,
    required this.artifacts,
  });

  final List<ModelQualityMetric> qualityMetrics;
  final List<ModelExperimentResult> experiments;
  final List<PcaPoint> pcaPoints;
  final List<ModelArtifactItem> artifacts;

  static const empty = SegmentationModelData(
    qualityMetrics: [],
    experiments: [],
    pcaPoints: [],
    artifacts: [],
  );
}
