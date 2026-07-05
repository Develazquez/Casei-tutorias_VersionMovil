import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/segmentation_model_view_model.dart';
import '../../providers/segmentation_provider.dart';
import '../../theme/segmentation_dashboard_colors.dart';
import '../dashboard/academic_radar_chart.dart';
import 'experimental_comparison_card.dart';
import 'model_artifacts_card.dart';
import 'model_metric_card.dart';
import 'pca_scatter_card.dart';

class SegmentationModelView extends StatelessWidget {
  const SegmentationModelView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SegmentationModelViewModel(
        context.read<SegmentationProvider>(),
      ),
      child: Consumer<SegmentationModelViewModel>(
        builder: (context, viewModel, child) {
          final data = viewModel.data;

          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Modelo K-Means',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  color: SegmentationDashboardColors.textPrimary,
                ),
              ),
              const Text(
                'Resultados y métricas del modelo de segmentación',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Roboto',
                  color: SegmentationDashboardColors.textSecondary,
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
        },
      ),
    );
  }
}
