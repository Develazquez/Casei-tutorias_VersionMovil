import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class ModelMetricCard extends StatelessWidget {
  const ModelMetricCard({
    required this.metric,
    super.key,
  });

  final ModelQualityMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SegmentationDashboardColors.border),
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
                  color: SegmentationDashboardColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(metric.icon,
                    color: SegmentationDashboardColors.primaryBlue, size: 16),
              ),
              Icon(
                metric.isUpGood
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: Colors.green,
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
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: SegmentationDashboardColors.textPrimary,
              ),
            ),
          ),
          Text(
            metric.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          Text(
            metric.description,
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Roboto',
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
