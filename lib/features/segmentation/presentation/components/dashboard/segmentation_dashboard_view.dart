import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/segmentation_dashboard_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../providers/segmentation_dashboard_provider.dart';
import '../../providers/segmentation_provider.dart';
import '../common/student_academic_detail_bottom_sheet.dart';
import '../../util/tutor_logic_utils.dart';
import 'academic_radar_chart.dart';
import 'generation_gender_card.dart';
import 'model_quality_card.dart';
import 'profile_attendance_chart.dart';
import 'profile_distribution_chart.dart';
import 'profile_status_card.dart';
import 'student_summary_card.dart';

class SegmentationDashboardView extends StatelessWidget {
  const SegmentationDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SegmentationDashboardProvider>();
    final data = viewModel.data;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

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
          
          Text(
            'Mis tutorados por perfil',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vista de seguimiento y análisis para el tutor, con métricas clave, perfiles académicos e información de atención prioritaria.',
            style: TextStyle(
              fontSize: 12,
              color: appColors.mutedText,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_graph_rounded, size: 14, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'K-Means K=3 · pca_90',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Top Summary Cards - Adaptable para diferentes anchos de pantalla
          _SummaryGrid(data: data),
          
          const SizedBox(height: 24),
          
          // Academic Profiles
          Text(
            'Perfiles Académicos',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...data.profileMetrics.map((metric) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ProfileStatusCard(
                metric: metric,
                allStudents: context.read<SegmentationProvider>().allTutorStudents,
              ),
            );
          }),

          const SizedBox(height: 24),
          
          ProfileDistributionChart(metrics: data.profileMetrics),
          const SizedBox(height: 12),
          GenerationGenderCard(metrics: data.generationMetrics),
          
          const SizedBox(height: 24),
          
          // Priority Students
          _PriorityStudentsSection(students: data.priorityStudents),
          
          const SizedBox(height: 12),
          ProfileAttendanceChart(metrics: data.profileMetrics),
          const SizedBox(height: 12),
          const AcademicRadarChart(),
          const SizedBox(height: 12),
          const ModelQualityCard(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.data});
  final SegmentationDashboardData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final double spacing = 12.0;
        final double itemWidth = (constraints.maxWidth - spacing) / 2;
        
        return Column(
          children: [
            Row(
              children: [
                _buildItem(itemWidth, 'Activos', data.activeCount, 'Alumnos inscritos', Icons.person_search_rounded, theme.colorScheme.primary),
                SizedBox(width: spacing),
                _buildItem(itemWidth, 'Egresados', data.alumniCount, 'Carrera terminada', Icons.school_rounded, appColors.profileAtypical),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                _buildItem(itemWidth, 'Seguimiento', data.urgentTrackingCount, 'Atención urgente', Icons.warning_amber_rounded, appColors.profileCritical),
                SizedBox(width: spacing),
                _buildItem(itemWidth, 'Generaciones', data.generationCount, 'Cohortes activas', Icons.groups_2_rounded, appColors.profileModerateRisk),
              ],
            ),
          ],
        );
      }
    );
  }

  Widget _buildItem(double width, String label, int count, String desc, IconData icon, Color color) {
    return SizedBox(
      width: width,
      child: StudentSummaryCard(
        label: label,
        count: count,
        description: desc,
        icon: icon,
        color: color,
      ),
    );
  }
}

class _PriorityStudentsSection extends StatelessWidget {
  const _PriorityStudentsSection({required this.students});
  final List<dynamic> students;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Alumnos prioritarios',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.priority_high_rounded, color: Colors.orange, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          if (students.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No hay alumnos prioritarios.', style: TextStyle(fontSize: 12))),
            )
          else
            ...students.map((s) => _PriorityStudentTile(student: s)),
        ],
      ),
    );
  }
}

class _PriorityStudentTile extends StatelessWidget {
  const _PriorityStudentTile({required this.student});
  final dynamic student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final initials = TutorLogicUtils.getInitials(student.name).join('');

    return InkWell(
      onTap: () => StudentAcademicDetailBottomSheet.show(context, student),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                initials,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Gen. ${student.cohort} · ${student.program}',
                    style: TextStyle(fontSize: 10, color: appColors.mutedText),
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
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                if (student.delayedSubjects > 0)
                  Text(
                    '${student.delayedSubjects.round()} deudas',
                    style: TextStyle(fontSize: 9, color: appColors.profileCritical, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, size: 16, color: appColors.cardBorder),
          ],
        ),
      ),
    );
  }
}

class _MockIndicator extends StatelessWidget {
  const _MockIndicator();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: appColors.profileModerateRisk.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: appColors.profileModerateRisk.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: appColors.profileModerateRisk,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            'Usando fuente de datos Mock (Falló conexión CSV)',
            style: TextStyle(
              color: appColors.profileModerateRisk,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
