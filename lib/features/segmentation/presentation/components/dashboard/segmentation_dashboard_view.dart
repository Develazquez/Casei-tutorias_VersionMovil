import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../domain/entities/tutor_status_entity.dart';
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
    final status = viewModel.tutorStatus;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: theme.colorScheme.error,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.errorMessage!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _refresh(context),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (status != null &&
        (status.state == TutorState.noGroup ||
            status.state == TutorState.noData)) {
      return _buildStatusView(context, status);
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Mis tutorados por perfil',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Vista de seguimiento y análisis para el tutor, con métricas clave, perfiles académicos e información de atención prioritaria.',
            style: TextStyle(fontSize: 12, color: appColors.mutedText),
          ),
          const SizedBox(height: 12),
          if (status?.state == TutorState.hasStudents)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      status!.displayMessage,
                      style: TextStyle(
                        color: theme.colorScheme.onSecondaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Top Summary Cards - Adaptable para diferentes anchos de pantalla
          _SummaryGrid(data: data),

          const SizedBox(height: 24),

          if (status?.state == TutorState.modelReady) ...[
            Text(
              'Perfiles Académicos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...data.profileMetrics.map((metric) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ProfileStatusCard(
                  metric: metric,
                  allStudents: context
                      .read<SegmentationProvider>()
                      .allTutorStudents,
                ),
              );
            }),
            const SizedBox(height: 24),
            ProfileDistributionChart(metrics: data.profileMetrics),
            if (data.generationMetrics.isNotEmpty) ...[
              const SizedBox(height: 12),
              GenerationGenderCard(metrics: data.generationMetrics),
            ],
            const SizedBox(height: 24),
          ],

          // Priority Students
          _PriorityStudentsSection(students: data.priorityStudents),

          const SizedBox(height: 12),
          if (status?.state == TutorState.modelReady) ...[
            ProfileAttendanceChart(metrics: data.profileMetrics),
            const SizedBox(height: 12),
            const AcademicRadarChart(),
            const SizedBox(height: 12),
            const ModelQualityCard(),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> _refresh(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return context.read<SegmentationProvider>().load(
      role: auth.user?.role,
      userId: auth.user?.id,
    );
  }

  Widget _buildStatusView(BuildContext context, TutorStatusEntity status) {
    final theme = Theme.of(context);
    final icon = switch (status.state) {
      TutorState.noGroup => Icons.group_off_rounded,
      TutorState.noData => Icons.person_off_rounded,
      TutorState.hasStudents => Icons.analytics_outlined,
      _ => Icons.info_outline_rounded,
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              status.displayMessage,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (status.state == TutorState.hasStudents)
              const Text(
                'Los datos de tus alumnos ya están en el sistema, pero el proceso de segmentación (K-Means) aún no se ha ejecutado o publicado para este periodo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _refresh(context),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Verificar de nuevo'),
            ),
          ],
        ),
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
                _buildItem(
                  itemWidth,
                  'Activos',
                  data.totalStudents,
                  'Tutorados este periodo',
                  Icons.person_search_rounded,
                  theme.colorScheme.primary,
                ),
                SizedBox(width: spacing),
                _buildItem(
                  itemWidth,
                  'Egresados',
                  data.alumniCount,
                  'Carrera terminada',
                  Icons.school_rounded,
                  appColors.profileAtypical,
                ),
              ],
            ),
            SizedBox(height: spacing),
            Row(
              children: [
                _buildItem(
                  itemWidth,
                  'Seguimiento',
                  data.urgentTrackingCount,
                  'Atención urgente',
                  Icons.warning_amber_rounded,
                  appColors.profileCritical,
                ),
                SizedBox(width: spacing),
                _buildItem(
                  itemWidth,
                  'Generaciones',
                  data.generationCount,
                  'Cohortes activas',
                  Icons.groups_2_rounded,
                  appColors.profileModerateRisk,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildItem(
    double width,
    String label,
    int count,
    String desc,
    IconData icon,
    Color color,
  ) {
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
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.priority_high_rounded,
                color: Colors.orange,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (students.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No hay alumnos prioritarios.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
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
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                if (student.delayedSubjects > 0)
                  Text(
                    '${student.delayedSubjects.round()} deudas',
                    style: TextStyle(
                      fontSize: 9,
                      color: appColors.profileCritical,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: appColors.cardBorder,
            ),
          ],
        ),
      ),
    );
  }
}
