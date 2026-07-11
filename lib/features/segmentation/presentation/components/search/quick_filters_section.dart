import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';
import '../../viewmodels/segmentation_search_view_model.dart';

class QuickFiltersSection extends StatelessWidget {
  const QuickFiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationSearchViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Filtros rápidos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: SegmentationDashboardColors.textSecondary,
              ),
            ),
            if (viewModel.isSearching)
              TextButton(
                onPressed: viewModel.clearFilters,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: const Text(
                  'Limpiar filtros',
                  style: TextStyle(
                    fontSize: 11,
                    color: SegmentationDashboardColors.primaryBlue,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Críticos',
              count: viewModel.getCountByProfile('Crítico'),
              color: SegmentationDashboardColors.redCritical,
              isSelected: viewModel.query.profiles.contains('Crítico'),
              onTap: () => viewModel.toggleProfile('Crítico'),
            ),
            _FilterChip(
              label: 'Riesgo mod.',
              count: viewModel.getCountByProfile('Riesgo'),
              color: SegmentationDashboardColors.orangeRisk,
              isSelected: viewModel.query.profiles.contains('Riesgo'),
              onTap: () => viewModel.toggleProfile('Riesgo'),
            ),
            _FilterChip(
              label: 'Regulares',
              count: viewModel.getCountByProfile('Regular'),
              color: SegmentationDashboardColors.primaryBlue,
              isSelected: viewModel.query.profiles.contains('Regular'),
              onTap: () => viewModel.toggleProfile('Regular'),
            ),
            _FilterChip(
              label: 'Atípicos',
              count: viewModel.getCountByProfile('Atípico'),
              color: SegmentationDashboardColors.turquoise,
              isSelected: viewModel.query.profiles.contains('Atípico'),
              onTap: () => viewModel.toggleProfile('Atípico'),
            ),
            _FilterChip(
              label: 'Baja asist.',
              count: viewModel.getLowAttendanceCount(),
              color: Colors.deepOrange,
              isSelected: viewModel.query.lowAttendanceOnly,
              onTap: viewModel.toggleLowAttendance,
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Generaciones',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: SegmentationDashboardColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['2021', '2022', '2023', '2024'].map((gen) {
            return _FilterChip(
              label: 'Gen. $gen',
              count: viewModel.getCountByGeneration(gen),
              color: const Color(0xFF7C3AED),
              isSelected: viewModel.query.generations.contains(gen),
              onTap: () => viewModel.toggleGeneration(gen),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : color.darken(),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color.darken(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on Color {
  Color darken([double amount = .2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
