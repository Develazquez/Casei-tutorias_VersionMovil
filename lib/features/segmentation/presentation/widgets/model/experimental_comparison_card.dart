import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';
import 'experiment_results_table.dart';

class ExperimentalComparisonCard extends StatelessWidget {
  const ExperimentalComparisonCard({required this.experiments, super.key});

  final List<ModelExperimentResult> experiments;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SegmentationDashboardColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparación experimental',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const Text(
            'Silhouette por K y representación',
            style: TextStyle(
              fontSize: 11,
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _ExperimentChart(experiments: experiments),
          const SizedBox(height: 20),
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
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: experiments.map((e) => _BarItem(experiment: e)).toList(),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({required this.experiment});
  final ModelExperimentResult experiment;

  @override
  Widget build(BuildContext context) {
    final color = experiment.selected
        ? SegmentationDashboardColors.primaryBlue
        : SegmentationDashboardColors.border;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: (experiment.silhouette / 0.2) * 100, // Escala relativa
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'K=${experiment.k}',
          style: const TextStyle(
            fontSize: 9,
            color: SegmentationDashboardColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
