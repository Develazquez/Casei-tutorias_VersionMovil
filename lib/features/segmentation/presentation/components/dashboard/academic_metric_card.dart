import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class AcademicMetricCard extends StatelessWidget {
  const AcademicMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: appColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: effectiveColor, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: appColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
