import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../providers/segmentation_search_provider.dart';

class QuickFiltersSection extends StatelessWidget {
  const QuickFiltersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationSearchProvider>();
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Filtros rápidos',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: appColors.mutedText,
              ),
            ),
            if (viewModel.isSearching)
              TextButton(
                onPressed: viewModel.clearFilters,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                child: Text(
                  'Limpiar filtros',
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'Críticos',
              color: appColors.profileCritical,
              isSelected: viewModel.query.profiles.contains('Crítico'),
              onTap: () => viewModel.toggleProfile('Crítico'),
            ),
            _FilterChip(
              label: 'Riesgo mod.',
              color: appColors.profileModerateRisk,
              isSelected: viewModel.query.profiles.contains('Riesgo'),
              onTap: () => viewModel.toggleProfile('Riesgo'),
            ),
            _FilterChip(
              label: 'Regulares',
              color: theme.colorScheme.primary,
              isSelected: viewModel.query.profiles.contains('Regular'),
              onTap: () => viewModel.toggleProfile('Regular'),
            ),
            _FilterChip(
              label: 'Atípicos',
              color: appColors.profileAtypical,
              isSelected: viewModel.query.profiles.contains('Atípico'),
              onTap: () => viewModel.toggleProfile('Atípico'),
            ),
            _FilterChip(
              label: 'Baja asist.',
              color: Colors.deepOrange,
              isSelected: viewModel.query.lowAttendanceOnly,
              onTap: viewModel.toggleLowAttendance,
            ),
            _FilterChip(
              label: 'Egresados',
              color: Colors.blueGrey,
              isSelected: false,
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Generaciones',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: appColors.mutedText,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['2021', '2022', '2023', '2024'].map((gen) {
            return _FilterChip(
              label: 'Gen. $gen',
              color: appColors.info,
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
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : color.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : color.darken(),
          ),
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
