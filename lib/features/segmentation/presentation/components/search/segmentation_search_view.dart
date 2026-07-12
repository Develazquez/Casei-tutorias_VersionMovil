import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';
import '../../providers/segmentation_search_provider.dart';
import 'quick_access_section.dart';
import 'quick_filters_section.dart';
import 'search_results_section.dart';
import 'tutor_search_bar_card.dart';

class SegmentationSearchView extends StatelessWidget {
  const SegmentationSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SegmentationSearchProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Búsqueda',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SegmentationDashboardColors.textPrimary,
          ),
        ),
        const Text(
          'Consulta y filtra la información de tus tutorados',
          style: TextStyle(
            fontSize: 12,
            color: SegmentationDashboardColors.textSecondary,
          ),
        ),
        const SizedBox(height: 18),
        TutorSearchBarCard(
          onChanged: provider.onTextChanged,
          onClear: provider.clearFilters,
        ),
        const SizedBox(height: 18),
        const QuickFiltersSection(),
        const SizedBox(height: 24),
        if (provider.isSearching)
          const SearchResultsSection()
        else
          const QuickAccessSection(),
        const SizedBox(height: 40),
      ],
    );
  }
}
