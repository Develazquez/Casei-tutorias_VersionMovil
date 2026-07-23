import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/theme_casei_material3.dart';
import '../../models/segmentation_model_data.dart';
import '../../providers/segmentation_model_provider.dart';

class ModelQualityCard extends StatelessWidget {
  const ModelQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final metrics = context
        .watch<SegmentationModelProvider>()
        .data
        .qualityMetrics
        .where(_isModelQualityMetric)
        .take(3)
        .toList();

    if (metrics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Calidad del modelo de minería',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: metrics
                .map(
                  (metric) => _QualityMetric(
                    label: metric.name,
                    value: _formatValue(metric),
                    color: _metricColor(metric, theme, appColors),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Text(
            'Métricas calculadas durante el último reentrenamiento.',
            style: TextStyle(fontSize: 10, color: appColors.mutedText),
          ),
        ],
      ),
    );
  }

  bool _isModelQualityMetric(ModelQualityMetric metric) {
    final name = metric.name.toLowerCase();
    return name.contains('silhouette') ||
        name.contains('davies') ||
        name.contains('calinski') ||
        name.contains('inercia');
  }

  String _formatValue(ModelQualityMetric metric) {
    return metric.value.abs() >= 10
        ? metric.value.toStringAsFixed(1)
        : metric.value.toStringAsFixed(3);
  }

  Color _metricColor(
    ModelQualityMetric metric,
    ThemeData theme,
    AppThemeColors appColors,
  ) {
    final name = metric.name.toLowerCase();
    if (name.contains('silhouette')) return appColors.profileAtypical;
    if (name.contains('davies')) return theme.colorScheme.primary;
    return appColors.profileModerateRisk;
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
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
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
            style: TextStyle(fontSize: 10, color: appColors.mutedText),
          ),
        ],
      ),
    );
  }
}
