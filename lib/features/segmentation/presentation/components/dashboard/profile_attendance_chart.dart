import 'package:flutter/material.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class ProfileAttendanceChart extends StatelessWidget {
  const ProfileAttendanceChart({required this.metrics, super.key});

  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final viewportWidth = MediaQuery.sizeOf(context).width - 64;
    final chartWidth = viewportWidth > metrics.length * 70.0
        ? viewportWidth
        : metrics.length * 70.0;

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
            'Asistencia promedio por perfil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 150,
              width: chartWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: metrics.map((m) => _BarItem(metric: m)).toList(),
              ),
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
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final color = _getColor(appColors, metric.label);
    final attendance = metric.averageAttendance.clamp(0.0, 100.0);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${metric.averageAttendance.round()}%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 32,
          height: (attendance / 100) * 110,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.8),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 64,
          child: Text(
            metric.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              color: appColors.mutedText,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getColor(AppThemeColors appColors, String label) {
    final lower = label.toLowerCase();
    if (lower.contains('crítico') || lower.contains('critico')) return appColors.profileCritical;
    if (lower.contains('riesgo') || lower.contains('moderado')) return appColors.profileModerateRisk;
    if (lower.contains('atípico') || lower.contains('atipico')) return appColors.profileAtypical;
    if (lower.contains('regular')) return appColors.profileRegular;
    return appColors.mutedText;
  }
}
