import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class ModelMetricCard extends StatelessWidget {
  const ModelMetricCard({required this.metric, super.key});

  final ModelQualityMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  metric.icon,
                  color: theme.colorScheme.primary,
                  size: 16,
                ),
              ),
              Icon(
                metric.isUpGood
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: appColors.profileAtypical,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              metric.value > 1000
                  ? metric.value.toStringAsFixed(0)
                  : metric.value.toStringAsFixed(3),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            metric.name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            metric.description,
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
