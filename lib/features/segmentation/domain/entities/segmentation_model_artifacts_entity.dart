class SegmentationMetricEntity {
  const SegmentationMetricEntity({
    required this.name,
    required this.value,
    required this.description,
    required this.isUpGood,
    required this.origin,
  });

  final String name;
  final double value;
  final String description;
  final bool isUpGood;
  final String origin;
}

class SegmentationExperimentEntity {
  const SegmentationExperimentEntity({
    required this.representation,
    required this.k,
    required this.silhouette,
    required this.daviesBouldin,
    required this.minSize,
    required this.maxSize,
    required this.selected,
  });

  final String representation;
  final int k;
  final double silhouette;
  final double daviesBouldin;
  final int minSize;
  final int maxSize;
  final bool selected;
}

class SegmentationPcaPointEntity {
  const SegmentationPcaPointEntity({
    required this.x,
    required this.y,
    required this.label,
  });

  final double x;
  final double y;
  final String label;
}

class SegmentationArtifactEntity {
  const SegmentationArtifactEntity({
    required this.id,
    required this.displayName,
    required this.fileName,
    required this.type,
    required this.available,
  });

  final String id;
  final String displayName;
  final String fileName;
  final String type;
  final bool available;
}

class SegmentationModelArtifactsEntity {
  const SegmentationModelArtifactsEntity({
    required this.metrics,
    required this.experiments,
    required this.pcaPoints,
    required this.artifacts,
  });

  final List<SegmentationMetricEntity> metrics;
  final List<SegmentationExperimentEntity> experiments;
  final List<SegmentationPcaPointEntity> pcaPoints;
  final List<SegmentationArtifactEntity> artifacts;
}
