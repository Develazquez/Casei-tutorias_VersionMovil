import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class AcademicRadarChart extends StatelessWidget {
  const AcademicRadarChart({super.key});

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
            'Métricas del radar académico',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.radar_rounded,
                  size: 80,
                  color: appColors.cardBorder,
                ),
                const SizedBox(height: 12),
                Text(
                  'Datos insuficientes para generar el radar',
                  style: TextStyle(
                    fontSize: 12,
                    color: appColors.mutedText,
                  ),
                ),
                Text(
                  '(Avance, Créditos y Puntualidad no disponibles)',
                  style: TextStyle(
                    fontSize: 10,
                    color: appColors.mutedText,
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
