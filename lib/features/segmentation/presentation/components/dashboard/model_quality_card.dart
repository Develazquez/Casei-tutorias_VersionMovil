import 'package:flutter/material.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class ModelQualityCard extends StatelessWidget {
  const ModelQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SegmentationDashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Calidad del modelo de minería',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _QualityMetric(
                label: 'Silhouette',
                value: '0.74',
                color: SegmentationDashboardColors.turquoise,
              ),
              _QualityMetric(
                label: 'D-Bouldin',
                value: '1.21',
                color: SegmentationDashboardColors.primaryBlue,
              ),
              _QualityMetric(
                label: 'Inercia',
                value: '42.8',
                color: SegmentationDashboardColors.orangeRisk,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Métricas calculadas durante el último reentrenamiento.',
            style: TextStyle(
              fontSize: 10,
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QualityMetric extends StatelessWidget {
  const _QualityMetric({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
