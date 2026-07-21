import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../../domain/entities/segmentation_student_entity.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../common/student_list_bottom_sheet.dart';

class ProfileStatusCard extends StatelessWidget {
  const ProfileStatusCard({
    required this.metric,
    required this.allStudents,
    super.key,
  });

  final ProfileMetric metric;
  final List<SegmentationStudentEntity> allStudents;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final color = _getProfileColor(appColors, metric.label);
    
    final filteredStudents = allStudents.where((s) {
      final label = s.profileLabel.toLowerCase();
      final target = metric.label.toLowerCase();
      if (target.contains('riesgo')) return label.contains('riesgo') || label.contains('moderado');
      return label.contains(target);
    }).toList();

    return InkWell(
      onTap: () => StudentListBottomSheet.show(
        context,
        title: 'Perfil: ${metric.label}',
        subtitle: metric.description,
        students: filteredStudents,
        color: color,
      ),
      borderRadius: BorderRadius.circular(16),
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
                Text(
                  metric.label,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${metric.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${metric.count} estudiantes',
              style: TextStyle(color: appColors.mutedText, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              metric.description,
              style: TextStyle(fontSize: 10, color: appColors.mutedText),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: metric.percentage / 100,
              backgroundColor: appColors.cardBorder,
              color: color,
              borderRadius: BorderRadius.circular(4),
              minHeight: 6,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _SmallMetric(label: 'PROM', value: metric.averageGrade.toStringAsFixed(1)),
                const SizedBox(width: 16),
                _SmallMetric(label: 'ASIST', value: '${metric.averageAttendance.round()}%'),
                const Spacer(),
                Text(
                  'Ver alumnos',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 10, color: theme.colorScheme.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getProfileColor(AppThemeColors colors, String profile) {
    return switch (profile) {
      'Regular' => colors.profileRegular,
      'Atípico' => colors.profileAtypical,
      'Crítico' => colors.profileCritical,
      'Riesgo moderado' => colors.profileModerateRisk,
      _ => colors.mutedText,
    };
  }
}

class _SmallMetric extends StatelessWidget {
  const _SmallMetric({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 8, color: appColors.mutedText)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
