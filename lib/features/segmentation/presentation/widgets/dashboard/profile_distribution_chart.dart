import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class ProfileDistributionChart extends StatelessWidget {
  const ProfileDistributionChart({required this.metrics, super.key});

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
            'Distribución por perfil',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CustomPaint(painter: _DoughnutPainter(metrics)),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: metrics.map((m) => _LegendItem(metric: m)).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.metric});
  final ProfileMetric metric;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: _getColor(metric.label),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              metric.label,
              style: const TextStyle(
                fontSize: 11,
                color: SegmentationDashboardColors.textPrimary,
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

  Color _getColor(String label) {
    if (label == 'Regular') return SegmentationDashboardColors.profileRegular;
    if (label == 'Atípico') return SegmentationDashboardColors.profileAtypical;
    if (label == 'Crítico') return SegmentationDashboardColors.profileCritical;
    return SegmentationDashboardColors.profileModerate;
  }
}

class _DoughnutPainter extends CustomPainter {
  _DoughnutPainter(this.metrics);
  final List<ProfileMetric> metrics;

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
      paint.color = SegmentationDashboardColors.border;
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
    if (label == 'Regular') return SegmentationDashboardColors.profileRegular;
    if (label == 'Atípico') return SegmentationDashboardColors.profileAtypical;
    if (label == 'Crítico') return SegmentationDashboardColors.profileCritical;
    return SegmentationDashboardColors.profileModerate;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
