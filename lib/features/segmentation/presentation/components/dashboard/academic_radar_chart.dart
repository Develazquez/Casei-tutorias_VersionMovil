import 'package:flutter/material.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class AcademicRadarChart extends StatelessWidget {
  const AcademicRadarChart({super.key});

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
            'Métricas del radar académico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          const Center(
            child: Column(
              children: [
                Icon(
                  Icons.radar_rounded,
                  size: 80,
                  color: SegmentationDashboardColors.border,
                ),
                SizedBox(height: 12),
                Text(
                  'Datos insuficientes para generar el radar',
                  style: TextStyle(
                    fontSize: 12,
                    color: SegmentationDashboardColors.textSecondary,
                  ),
                ),
                Text(
                  '(Avance, Créditos y Puntualidad no disponibles)',
                  style: TextStyle(
                    fontSize: 10,
                    color: SegmentationDashboardColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
