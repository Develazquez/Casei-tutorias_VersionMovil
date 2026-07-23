import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/theme_casei_material3.dart';
import '../../providers/segmentation_search_provider.dart';

class QuickAccessSection extends StatelessWidget {
  const QuickAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consultas rápidas',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: appColors.mutedText,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _QuickAccessCard(
              title: '¿Qué materias deben los críticos?',
              icon: Icons.error_outline_rounded,
              color: appColors.profileCritical,
            ),
            _QuickAccessCard(
              title: 'Materias del próximo cuatrimestre',
              icon: Icons.calendar_month_outlined,
              color: theme.colorScheme.primary,
            ),
            _QuickAccessCard(
              title: 'Materias con más alumnos en deuda',
              icon: Icons.format_list_numbered_rounded,
              color: appColors.profileModerateRisk,
            ),
            _QuickAccessCard(
              title: 'Alumnos con asistencia < 60%',
              icon: Icons.person_off_outlined,
              color: Colors.deepOrange,
            ),
            _QuickAccessCard(
              title: 'Próximos a egresar (sem. 8-9)',
              icon: Icons.school_outlined,
              color: appColors.profileAtypical,
            ),
            _QuickAccessCard(
              title: 'Atípicos: alto promedio, baja asist.',
              icon: Icons.query_stats_rounded,
              color: appColors.info,
            ),
            _QuickAccessCard(
              title: 'Gen. 2022 con materias pendientes',
              icon: Icons.history_edu_rounded,
              color: Colors.blueGrey,
            ),
            _QuickAccessCard(
              title: 'Alumnos por programa educativo',
              icon: Icons.pie_chart_outline_rounded,
              color: Colors.teal,
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return InkWell(
      onTap: () =>
          context.read<SegmentationSearchProvider>().submitQuery(title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
