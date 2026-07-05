import 'package:flutter/material.dart';
import 'segmentation_model_data.dart';

class SegmentationModelMockData {
  const SegmentationModelMockData._();

  static const qualityMetrics = [
    ModelQualityMetric(
      name: 'Silhouette',
      value: 0.175,
      description: 'Cohesión',
      icon: Icons.grain_rounded,
      isUpGood: true,
    ),
    ModelQualityMetric(
      name: 'Davies-Bouldin',
      value: 2.021,
      description: 'Separación',
      icon: Icons.unfold_more_rounded,
      isUpGood: false,
    ),
    ModelQualityMetric(
      name: 'Calinski-Harabasz',
      value: 158.3,
      description: 'Densidad',
      icon: Icons.blur_on_rounded,
      isUpGood: true,
    ),
    ModelQualityMetric(
      name: 'Inercia',
      value: 17366.0,
      description: 'Dist. intra-clust',
      icon: Icons.center_focus_strong_rounded,
      isUpGood: false,
    ),
  ];

  static const experiments = [
    ModelExperimentResult(representation: 'PCA-2', k: 2, silhouette: 0.175, daviesBouldin: 2.021, minSize: 15, maxSize: 85, selected: true),
    ModelExperimentResult(representation: 'Full', k: 3, silhouette: 0.142, daviesBouldin: 2.450, minSize: 8, maxSize: 70),
    ModelExperimentResult(representation: 'Full', k: 4, silhouette: 0.138, daviesBouldin: 2.510, minSize: 5, maxSize: 65),
    ModelExperimentResult(representation: 'PCA-2', k: 5, silhouette: 0.125, daviesBouldin: 2.780, minSize: 4, maxSize: 60),
  ];

  static const artifacts = [
    ModelArtifactItem(
      id: '1',
      displayName: 'Dataset v2',
      fileName: 'dataset_alumnos_u_z.csv',
      createdAt: '2024-03-15 10:30',
    ),
    ModelArtifactItem(
      id: '2',
      displayName: 'Métricas BM25',
      fileName: 'search_metrics.csv',
      createdAt: '2024-03-15 10:35',
    ),
    ModelArtifactItem(
      id: '3',
      displayName: 'EDA, features y PCA',
      fileName: 'pca_report.md',
      createdAt: '2024-03-15 11:00',
      type: 'MD',
    ),
    ModelArtifactItem(
      id: '4',
      displayName: 'K-Means Entrenamiento',
      fileName: 'kmeans_metadata.json',
      createdAt: '2024-03-15 11:15',
      type: 'JSON',
    ),
  ];

  static const pcaPoints = [
    // Representación simplificada de puntos PCA para la gráfica
    PcaPoint(x: -2.5, y: 1.2, label: 'Regular'),
    PcaPoint(x: -1.8, y: 0.5, label: 'Regular'),
    PcaPoint(x: -2.1, y: -0.8, label: 'Regular'),
    PcaPoint(x: 0.5, y: 2.3, label: 'Atípico'),
    PcaPoint(x: 1.2, y: 1.8, label: 'Atípico'),
    PcaPoint(x: 3.4, y: -1.2, label: 'Crítico'),
    PcaPoint(x: 2.8, y: -2.5, label: 'Crítico'),
    PcaPoint(x: 0.2, y: -1.5, label: 'Riesgo moderado'),
    PcaPoint(x: 1.1, y: -0.5, label: 'Riesgo moderado'),
  ];
}
