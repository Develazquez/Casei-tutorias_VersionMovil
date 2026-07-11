import 'package:flutter/material.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class AcademicMetricCard extends StatelessWidget {
  const AcademicMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    this.color = SegmentationDashboardColors.primaryBlue,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SegmentationDashboardColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: SegmentationDashboardColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: SegmentationDashboardColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
