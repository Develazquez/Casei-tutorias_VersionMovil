import 'package:flutter/material.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class ProfileSummaryCard extends StatelessWidget {
  const ProfileSummaryCard({
    required this.metric,
    super.key,
  });

  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _getColor(metric.label);

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
              Text(
                metric.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: SegmentationDashboardColors.textPrimary,
                ),
              ),
              Text(
                '${metric.percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${metric.count} estudiantes',
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'Roboto',
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: SegmentationDashboardColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: metric.percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _SmallMetric(
                  label: 'PROM',
                  value: metric.averageGrade.toStringAsFixed(1)),
              const SizedBox(width: 8),
              _SmallMetric(
                  label: 'ASIST', value: '${metric.averageAttendance.round()}%'),
            ],
          ),
        ],
      ),
    );
  }

  Color _getColor(String label) {
    if (label == 'Regular') return SegmentationDashboardColors.profileRegular;
    if (label == 'Atípico') return SegmentationDashboardColors.profileAtypical;
    if (label == 'Crítico') return SegmentationDashboardColors.profileCritical;
    return SegmentationDashboardColors.profileModerate;
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 8,
                fontFamily: 'Roboto',
                color: SegmentationDashboardColors.textSecondary)),
        Text(value,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: SegmentationDashboardColors.textPrimary)),
      ],
    );
  }
}
