import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../models/segmentation_dashboard_data.dart';
import '../common/student_list_bottom_sheet.dart';

class GenerationGenderCard extends StatelessWidget {
  const GenerationGenderCard({required this.metrics, super.key});

  final List<GenerationMetric> metrics;

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
            'Distribución por generación y género',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...metrics.map((m) => _GenerationRow(metric: m)),
        ],
      ),
    );
  }
}

class _GenerationRow extends StatelessWidget {
  const _GenerationRow({required this.metric});
  final GenerationMetric metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    final total = metric.totalCount;
    final malePct = total > 0 ? metric.maleCount / total : 0.0;
    final maleFlex = ((malePct * 100).round()).clamp(1, 99);
    final femaleFlex = (100 - maleFlex).clamp(1, 99);

    return InkWell(
      onTap: () => StudentListBottomSheet.show(
        context,
        title: 'Generación ${metric.generation}',
        subtitle:
            '${metric.totalCount} alumnos · ${metric.maleCount} hombres · ${metric.femaleCount} mujeres',
        students: metric.students,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gen. ${metric.generation}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _GenderBadge(
                        count: metric.maleCount,
                        icon: Icons.male_rounded,
                        color: appColors.genderMale,
                      ),
                      const SizedBox(width: 8),
                      _GenderBadge(
                        count: metric.femaleCount,
                        icon: Icons.female_rounded,
                        color: appColors.genderFemale,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${metric.totalCount}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 4,
                child: Row(
                  children: [
                    Expanded(
                      flex: maleFlex,
                      child: Container(color: appColors.genderMale),
                    ),
                    Expanded(
                      flex: femaleFlex,
                      child: Container(color: appColors.genderFemale),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderBadge extends StatelessWidget {
  const _GenderBadge({
    required this.count,
    required this.icon,
    required this.color,
  });
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
