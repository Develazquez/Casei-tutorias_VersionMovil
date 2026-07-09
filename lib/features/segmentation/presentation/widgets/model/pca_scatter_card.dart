import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class PcaScatterCard extends StatelessWidget {
  const PcaScatterCard({required this.points, super.key});

  final List<PcaPoint> points;

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
            'Dispersión PC1/PC2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const Text(
            'Alumnos segmentados sobre componentes principales',
            style: TextStyle(
              fontSize: 11,
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            width: double.infinity,
            child: CustomPaint(painter: _ScatterPainter(points)),
          ),
          const SizedBox(height: 16),
          const _Legend(),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _LegendItem(
          label: 'Regular',
          color: SegmentationDashboardColors.profileRegular,
        ),
        _LegendItem(
          label: 'Atípico',
          color: SegmentationDashboardColors.profileAtypical,
        ),
        _LegendItem(
          label: 'Crítico',
          color: SegmentationDashboardColors.profileCritical,
        ),
        _LegendItem(
          label: 'Riesgo moderado',
          color: SegmentationDashboardColors.profileModerate,
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: SegmentationDashboardColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ScatterPainter extends CustomPainter {
  _ScatterPainter(this.points);
  final List<PcaPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Dibujar ejes
    final axisPaint = Paint()
      ..color = SegmentationDashboardColors.border
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      axisPaint,
    );
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      axisPaint,
    );

    if (points.isEmpty) return;

    // Normalizar puntos al tamaño del lienzo
    // Asumimos rango [-4, 4] para PCA
    const double range = 8.0;
    final double scaleX = size.width / range;
    final double scaleY = size.height / range;

    for (final point in points) {
      final double dx = (point.x + range / 2) * scaleX;
      final double dy = (range / 2 - point.y) * scaleY;

      paint.color = _getColor(point.label).withValues(alpha: 0.6);
      canvas.drawCircle(Offset(dx, dy), 4, paint);

      paint.color = _getColor(point.label);
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      canvas.drawCircle(Offset(dx, dy), 4, paint);
      paint.style = PaintingStyle.fill;
    }
  }

  Color _getColor(String label) {
    if (label.contains('Regular')) {
      return SegmentationDashboardColors.profileRegular;
    }
    if (label.contains('Atípico')) {
      return SegmentationDashboardColors.profileAtypical;
    }
    if (label.contains('Crítico')) {
      return SegmentationDashboardColors.profileCritical;
    }
    return SegmentationDashboardColors.profileModerate;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
