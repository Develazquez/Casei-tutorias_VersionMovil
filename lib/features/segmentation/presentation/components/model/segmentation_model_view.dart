import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/theme/theme_casei_material3.dart';
import '../../providers/segmentation_model_provider.dart';
import '../dashboard/academic_radar_chart.dart';
import 'experimental_comparison_card.dart';
import 'model_artifacts_card.dart';
import 'model_metric_card.dart';
import 'pca_scatter_card.dart';

class SegmentationModelView extends StatelessWidget {
  const SegmentationModelView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SegmentationModelProvider>();
    final data = provider.data;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            provider.errorMessage!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: appColors.mutedText,
            ),
          ),
        ),
      );
    }
    if (data.qualityMetrics.isEmpty &&
        data.experiments.isEmpty &&
        data.pcaPoints.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Actualmente no hay información del modelo disponible. Es posible que el sistema se esté actualizando.',
            textAlign: TextAlign.center,
            style: TextStyle(color: appColors.mutedText),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Modelo K-Means',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          'Resultados y métricas del modelo de segmentación',
          style: TextStyle(
            fontSize: 12,
            color: appColors.mutedText,
          ),
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 340;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: data.qualityMetrics.map((metric) {
                return SizedBox(
                  width: isNarrow
                      ? constraints.maxWidth
                      : (constraints.maxWidth - 12) / 2,
                  child: ModelMetricCard(metric: metric),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 18),
        ExperimentalComparisonCard(experiments: data.experiments),
        const SizedBox(height: 12),
        PcaScatterCard(points: data.pcaPoints),
        const SizedBox(height: 12),
        const AcademicRadarChart(),
        const SizedBox(height: 12),
        ModelArtifactsCard(artifacts: data.artifacts),
        const SizedBox(height: 24),
      ],
    );
  }
}
