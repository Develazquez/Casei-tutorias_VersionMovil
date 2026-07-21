import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../providers/segmentation_search_provider.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationSearchProvider>();
    final results = viewModel.results;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resultados: ${viewModel.totalResults}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: appColors.mutedText,
              ),
            ),
            Icon(
              Icons.sort_rounded,
              color: appColors.mutedText,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (results.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No se encontraron resultados',
                style: TextStyle(
                  color: appColors.mutedText,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          ...results.map((student) => _StudentResultTile(student: student)),
      ],
    );
  }
}

class _StudentResultTile extends StatelessWidget {
  const _StudentResultTile({required this.student});
  final dynamic
  student; // Usamos dynamic para evitar problemas de tipos en esta etapa

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final color = _getProfileColor(appColors, student.profileLabel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: appColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Text(
              _getInitials(student.name),
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  '${student.id} · ${student.program}',
                  style: TextStyle(
                    fontSize: 10,
                    color: appColors.mutedText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${student.averageGrade.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${student.attendanceRate.round()}%',
                style: TextStyle(
                  fontSize: 10,
                  color: student.attendanceRate < 60
                      ? theme.colorScheme.error
                      : appColors.profileAtypical,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right_rounded,
            color: appColors.cardBorder,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name[0];
  }

  Color _getProfileColor(AppThemeColors appColors, String label) {
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
}
