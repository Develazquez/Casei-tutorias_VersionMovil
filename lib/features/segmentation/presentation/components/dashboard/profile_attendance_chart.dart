import 'package:flutter/material.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class ProfileAttendanceChart extends StatelessWidget {
  const ProfileAttendanceChart({required this.metrics, super.key});

  final List<ProfileMetric> metrics;

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
            'Asistencia promedio por perfil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: metrics.map((m) => _BarItem(metric: m)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.metric});
  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _getColor(metric.label);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${metric.averageAttendance.round()}%',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 30,
          height: (metric.averageAttendance / 100) * 100, // Escala relativa
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 50,
          child: Text(
            metric.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 8,
              color: SegmentationDashboardColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getColor(String label) {
    if (label == 'Regular') return SegmentationDashboardColors.profileRegular;
    if (label == 'Atípico') return SegmentationDashboardColors.profileAtypical;
    if (label == 'Crítico') return SegmentationDashboardColors.profileCritical;
    return SegmentationDashboardColors.profileModerate;
  }
}
