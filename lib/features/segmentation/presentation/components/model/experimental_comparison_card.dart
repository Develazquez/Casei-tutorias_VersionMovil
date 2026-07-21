import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import 'experiment_results_table.dart';

class ExperimentalComparisonCard extends StatelessWidget {
  const ExperimentalComparisonCard({required this.experiments, super.key});

  final List<ModelExperimentResult> experiments;

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
            'Comparación experimental',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Silhouette por K y representación',
            style: TextStyle(
              fontSize: 10,
              color: appColors.mutedText,
            ),
          ),
          const SizedBox(height: 24),
          _ExperimentChart(experiments: experiments),
          const SizedBox(height: 24),
          ExperimentResultsTable(experiments: experiments),
        ],
      ),
    );
  }
}

class _ExperimentChart extends StatelessWidget {
  const _ExperimentChart({required this.experiments});
  final List<ModelExperimentResult> experiments;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Ancho calculado: al menos el ancho de pantalla menos padding, o dinámico según items
    final double itemWidth = 64.0;
    final double chartWidth = max(screenWidth - 64, experiments.length * itemWidth);

    return SizedBox(
      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: chartWidth,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: experiments.map((e) => _BarItem(experiment: e, width: itemWidth)).toList(),
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.experiment, required this.width});
  final ModelExperimentResult experiment;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    
    final color = experiment.selected
        ? theme.colorScheme.primary
        : appColors.cardBorder;

    // Normalización de altura: 1.0 de silhouette -> ~130px
    final double barHeight = (experiment.silhouette.clamp(0.0, 1.0) * 130).toDouble();

    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (experiment.selected)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                experiment.silhouette.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          const SizedBox(height: 4),
          Container(
            width: 28,
            height: barHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              boxShadow: experiment.selected ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                )
              ] : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'K=${experiment.k}',
            style: TextStyle(
              fontSize: 10,
              fontWeight: experiment.selected ? FontWeight.bold : FontWeight.normal,
              color: experiment.selected ? theme.colorScheme.primary : appColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
