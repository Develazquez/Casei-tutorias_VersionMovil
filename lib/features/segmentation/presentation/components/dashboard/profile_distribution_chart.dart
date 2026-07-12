import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class ProfileDistributionChart extends StatelessWidget {
  const ProfileDistributionChart({required this.metrics, super.key});

  final List<ProfileMetric> metrics;

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
            'Distribución por perfil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 300;
              return isNarrow
                ? Column(
                    children: [
                      _DoughnutWidget(metrics: metrics, appColors: appColors),
                      const SizedBox(height: 20),
                      _LegendWidget(metrics: metrics),
                    ],
                  )
                : Row(
                    children: [
                      _DoughnutWidget(metrics: metrics, appColors: appColors),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _LegendWidget(metrics: metrics),
                      ),
                    ],
                  );
            },
          ),
        ],
      ),
    );
  }
}

class _DoughnutWidget extends StatelessWidget {
  const _DoughnutWidget({required this.metrics, required this.appColors});
  final List<ProfileMetric> metrics;
  final AppThemeColors appColors;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(painter: _DoughnutPainter(metrics, appColors)),
    );
  }
}

class _LegendWidget extends StatelessWidget {
  const _LegendWidget({required this.metrics});
  final List<ProfileMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: metrics.map((m) => _LegendItem(metric: m)).toList(),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.metric});
  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final color = _getColor(appColors, metric.label);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metric.label,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${metric.count}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Color _getColor(AppThemeColors appColors, String label) {
    if (label == 'Regular') return appColors.profileRegular;
    if (label == 'Atípico') return appColors.profileAtypical;
    if (label == 'Crítico') return appColors.profileCritical;
    return appColors.profileModerateRisk;
  }
}

class _DoughnutPainter extends CustomPainter {
  _DoughnutPainter(this.metrics, this.appColors);
  final List<ProfileMetric> metrics;
  final AppThemeColors appColors;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    var startAngle = -pi / 2;
    final total = metrics.fold<int>(0, (sum, m) => sum + m.count);

    if (total == 0) {
      paint.color = appColors.cardBorder;
      canvas.drawCircle(center, radius - 10, paint);
      return;
    }

    for (final metric in metrics) {
      final sweepAngle = (metric.count / total) * 2 * pi;
      paint.color = _getColor(metric.label);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 10),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  Color _getColor(String label) {
    if (label == 'Regular') return appColors.profileRegular;
    if (label == 'Atípico') return appColors.profileAtypical;
    if (label == 'Crítico') return appColors.profileCritical;
    return appColors.profileModerateRisk;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
