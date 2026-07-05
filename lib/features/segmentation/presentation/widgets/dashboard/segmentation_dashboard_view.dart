import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/segmentation_dashboard_data.dart';
import '../../providers/segmentation_dashboard_view_model.dart';
import '../../providers/segmentation_provider.dart';
import '../../theme/segmentation_dashboard_colors.dart';
import 'academic_metric_card.dart';
import 'academic_radar_chart.dart';
import 'model_quality_card.dart';
import 'priority_students_card.dart';
import 'profile_attendance_chart.dart';
import 'profile_distribution_chart.dart';
import 'profile_summary_card.dart';
import 'student_summary_card.dart';

class SegmentationDashboardView extends StatelessWidget {
  const SegmentationDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationDashboardViewModel>();
    final data = viewModel.data;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    }

    return RefreshIndicator(
      onRefresh: () => context.read<SegmentationProvider>().load(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (data.isMock) const _MockIndicator(),
          const Text(
            'Mis tutorados',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const Text(
            'Resumen académico y segmentación de tutorados',
            style: TextStyle(
              fontSize: 12,
              color: SegmentationDashboardColors.textSecondary,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              StudentSummaryCard(
                label: 'Activos',
                count: data.activeCount,
                description: 'Alumnos inscritos',
                icon: Icons.person_search_rounded,
                color: SegmentationDashboardColors.primaryBlue,
              ),
              const SizedBox(width: 12),
              StudentSummaryCard(
                label: 'Egresados',
                count: data.alumniCount,
                description: 'Pendiente de conexión',
                icon: Icons.school_rounded,
                color: SegmentationDashboardColors.turquoise,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              AcademicMetricCard(
                label: 'Promedio',
                value: data.averageGrade.toStringAsFixed(1),
                icon: Icons.grade_rounded,
                color: SegmentationDashboardColors.primaryBlue,
              ),
              const SizedBox(width: 12),
              AcademicMetricCard(
                label: 'Asistencia',
                value: '${data.averageAttendance.round()}%',
                icon: Icons.event_available_rounded,
                color: SegmentationDashboardColors.turquoise,
              ),
              const SizedBox(width: 12),
              AcademicMetricCard(
                label: 'Seguimiento',
                value: '${data.trackingCount}',
                icon: Icons.warning_amber_rounded,
                color: SegmentationDashboardColors.orangeRisk,
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 340;
              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: data.profileMetrics.map((metric) {
                  return SizedBox(
                    width: isNarrow
                        ? constraints.maxWidth
                        : (constraints.maxWidth - 12) / 2,
                    child: ProfileSummaryCard(metric: metric),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 18),
          ProfileDistributionChart(metrics: data.profileMetrics),
          const SizedBox(height: 12),
          ProfileAttendanceChart(metrics: data.profileMetrics),
          const SizedBox(height: 12),
          const AcademicRadarChart(),
          const SizedBox(height: 12),
          PriorityStudentsCard(
            students: data.priorityStudents,
            criticalCount: data.profileMetrics
                .firstWhere(
                  (m) => m.label == 'Crítico',
                  orElse: () => const ProfileMetric(
                    label: 'Crítico',
                    count: 0,
                    percentage: 0,
                    averageGrade: 0,
                    averageAttendance: 0,
                  ),
                )
                .count,
          ),
          const SizedBox(height: 12),
          const ModelQualityCard(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MockIndicator extends StatelessWidget {
  const _MockIndicator();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: SegmentationDashboardColors.orangeRisk.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: SegmentationDashboardColors.orangeRisk.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline,
              color: SegmentationDashboardColors.orangeRisk, size: 16),
          SizedBox(width: 8),
          Text(
            'Usando fuente de datos Mock (Falló conexión CSV)',
            style: TextStyle(
                color: SegmentationDashboardColors.orangeRisk,
                fontSize: 10,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
