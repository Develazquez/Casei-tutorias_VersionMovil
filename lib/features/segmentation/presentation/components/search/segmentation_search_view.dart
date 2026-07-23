import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
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
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Búsqueda inteligente',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Consulta y filtra la información de tus tutorados con criterios avanzados.',
          style: TextStyle(fontSize: 12, color: appColors.mutedText),
        ),
        const SizedBox(height: 24),
        TutorSearchBarCard(
          onChanged: provider.onTextChanged,
          onClear: provider.clearFilters,
        ),
        if (provider.isRemoteSearching) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
        ],
        if (provider.usingLocalFallback && provider.isSearching) ...[
          const SizedBox(height: 8),
          Text(
            'El motor inteligente no está disponible. Se muestran coincidencias locales dentro de tus tutorados.',
            style: TextStyle(color: appColors.mutedText, fontSize: 11),
          ),
        ],
        const SizedBox(height: 24),
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
