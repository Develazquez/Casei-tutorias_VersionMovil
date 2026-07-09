import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/segmentation_search_view_model.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class SearchResultsSection extends StatelessWidget {
  const SearchResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationSearchViewModel>();
    final results = viewModel.results;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resultados: ${viewModel.totalResults}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: SegmentationDashboardColors.textSecondary,
              ),
            ),
            const Icon(
              Icons.sort_rounded,
              color: SegmentationDashboardColors.textSecondary,
              size: 18,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (results.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'No encontramos resultados con estos criterios.',
                style: TextStyle(
                  color: SegmentationDashboardColors.textSecondary,
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
    final color = _getProfileColor(student.profileLabel);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: SegmentationDashboardColors.border),
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
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: SegmentationDashboardColors.textPrimary,
                  ),
                ),
                Text(
                  '${student.id} · ${student.program}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: SegmentationDashboardColors.textSecondary,
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
                      ? Colors.red
                      : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            color: SegmentationDashboardColors.border,
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

  Color _getProfileColor(String label) {
    if (label.contains('Regular')) {
      return SegmentationDashboardColors.profileRegular;
    }
    if (label.contains('Atípico')) {
      return SegmentationDashboardColors.profileAtypical;
    }
    if (label.contains('Crítico')) {
      return SegmentationDashboardColors.profileCritical;
    }
    return SegmentationDashboardColors.profileModerate;
  }
}
