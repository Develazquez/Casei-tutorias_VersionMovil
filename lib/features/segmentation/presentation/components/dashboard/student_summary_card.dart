import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class StudentSummaryCard extends StatelessWidget {
  const StudentSummaryCard({
    required this.label,
    required this.count,
    required this.description,
    required this.icon,
    this.color,
    super.key,
  });

  final String label;
  final int count;
  final String description;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: effectiveColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: effectiveColor, size: 20),
                ),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 11,
                color: appColors.mutedText,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: appColors.cardBorder,
                borderRadius: BorderRadius.circular(3),
              ),
              child: FractionallySizedBox(
                widthFactor: 1.0, // Simplificación: barra llena
                child: Container(
                  decoration: BoxDecoration(
                    color: effectiveColor,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
