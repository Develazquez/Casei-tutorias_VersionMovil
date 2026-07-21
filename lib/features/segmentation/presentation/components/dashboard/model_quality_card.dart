import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class ModelQualityCard extends StatelessWidget {
  const ModelQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

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
            children: [
              _QualityMetric(
                label: 'Silhouette',
                value: '0.74',
                color: appColors.profileAtypical,
              ),
              _QualityMetric(
                label: 'D-Bouldin',
                value: '1.21',
                color: theme.colorScheme.primary,
              ),
              _QualityMetric(
                label: 'Inercia',
                value: '42.8',
                color: appColors.profileModerateRisk,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Métricas calculadas durante el último reentrenamiento.',
            style: TextStyle(
              fontSize: 10,
              color: appColors.mutedText,
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
            style: TextStyle(
              fontSize: 10,
              color: appColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
