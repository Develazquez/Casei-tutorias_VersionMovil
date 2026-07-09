class SegmentationMetricDto {
  const SegmentationMetricDto({
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

class SegmentationExperimentDto {
  const SegmentationExperimentDto({
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

class SegmentationPcaPointDto {
  const SegmentationPcaPointDto({
    required this.x,
    required this.y,
    required this.label,
  });

  final double x;
  final double y;
  final String label;
}

class SegmentationArtifactDto {
  const SegmentationArtifactDto({
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

class SegmentationModelArtifactsDto {
  const SegmentationModelArtifactsDto({
    required this.metrics,
    required this.experiments,
    required this.pcaPoints,
    required this.artifacts,
  });

  final List<SegmentationMetricDto> metrics;
  final List<SegmentationExperimentDto> experiments;
  final List<SegmentationPcaPointDto> pcaPoints;
  final List<SegmentationArtifactDto> artifacts;
}
