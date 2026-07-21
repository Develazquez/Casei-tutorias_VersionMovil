import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class PcaScatterCard extends StatelessWidget {
  const PcaScatterCard({required this.points, super.key});

  final List<PcaPoint> points;

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
            'Dispersión PC1/PC2',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Alumnos segmentados sobre componentes principales',
            style: TextStyle(
              fontSize: 10,
              color: appColors.mutedText,
            ),
          ),
          const SizedBox(height: 24),
          AspectRatio(
            aspectRatio: 1.4, // Más compacto para móvil
            child: ClipRect(
              child: CustomPaint(painter: _ScatterPainter(points, appColors)),
            ),
          ),
          const SizedBox(height: 20),
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
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      alignment: WrapAlignment.start,
      children: [
        _LegendItem(
          label: 'Regular',
          color: appColors.profileRegular,
        ),
        _LegendItem(
          label: 'Atípico',
          color: appColors.profileAtypical,
        ),
        _LegendItem(
          label: 'Crítico',
          color: appColors.profileCritical,
        ),
        _LegendItem(
          label: 'Riesgo moderado',
          color: appColors.profileModerateRisk,
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
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
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
          style: TextStyle(
            fontSize: 10,
            color: appColors.mutedText,
          ),
        ),
      ],
    );
  }
}

class _ScatterPainter extends CustomPainter {
  _ScatterPainter(this.points, this.appColors);
  final List<PcaPoint> points;
  final AppThemeColors appColors;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Dibujar ejes centrados
    final axisPaint = Paint()
      ..color = appColors.cardBorder.withValues(alpha: 0.8)
      ..strokeWidth = 1.5;

    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      axisPaint,
    );
    canvas.drawLine(
      Offset(centerX, 0),
      Offset(centerX, size.height),
      axisPaint,
    );

    if (points.isEmpty) return;

    // Normalizar puntos al tamaño del lienzo con margen de seguridad
    const double range = 10.0;
    final double scaleX = (size.width - 20) / range;
    final double scaleY = (size.height - 20) / range;

    for (final point in points) {
      final double dx = centerX + (point.x * scaleX);
      final double dy = centerY - (point.y * scaleY);

      // Dibujar punto con borde para contraste
      final color = _getColor(point.label);
      paint.color = color.withValues(alpha: 0.6);
      canvas.drawCircle(Offset(dx, dy), 4.5, paint);

      paint.color = color;
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = 1;
      canvas.drawCircle(Offset(dx, dy), 4.5, paint);
      paint.style = PaintingStyle.fill;
    }
  }

  Color _getColor(String label) {
    if (label.contains('Regular')) {
      return appColors.profileRegular;
    }
    if (label.contains('Atípico')) {
      return appColors.profileAtypical;
    }
    if (label.contains('Crítico')) {
      return appColors.profileCritical;
    }
    return appColors.profileModerateRisk;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
