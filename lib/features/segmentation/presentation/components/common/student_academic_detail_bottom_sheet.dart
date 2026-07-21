import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../../domain/entities/segmentation_student_entity.dart';
import '../../util/tutor_logic_utils.dart';

class StudentAcademicDetailBottomSheet extends StatelessWidget {
  const StudentAcademicDetailBottomSheet({required this.student, super.key});

  final SegmentationStudentEntity student;

  static Future<void> show(BuildContext context, SegmentationStudentEntity student) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StudentAcademicDetailBottomSheet(student: student),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final profile = TutorLogicUtils.normalizeProfileLabel(student.profileLabel);
    final profileColor = _getProfileColor(appColors, profile);
    final trajectoryRisk = TutorLogicUtils.getTrajectoryRisk(student);
    final projection = TutorLogicUtils.getGraduationProjection(student);
    final progress = TutorLogicUtils.getCurricularProgress(student);
    final term = TutorLogicUtils.getCurrentTermNumber(student);

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: appColors.cardBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: profileColor.withValues(alpha: 0.1),
                      child: Text(
                        TutorLogicUtils.getInitials(student.name).join(''),
                        style: TextStyle(
                          color: profileColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            student.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${student.id} · Gen. ${student.cohort} · ${student.period}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: appColors.mutedText,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _Badge(label: profile, color: profileColor),
                              _Badge(
                                label: projection,
                                color: _getProjectionColor(appColors, projection),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                Text(
                  student.program,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Metrics
                Row(
                  children: [
                    _MetricCard(
                      label: 'Promedio',
                      value: student.averageGrade.toStringAsFixed(1),
                      icon: Icons.grade_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    _MetricCard(
                      label: 'Asistencia',
                      value: '${student.attendanceRate.round()}%',
                      icon: Icons.event_available_rounded,
                      color: appColors.profileAtypical,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _MetricCard(
                      label: 'Adeudos',
                      value: '${student.delayedSubjects.round()}',
                      icon: Icons.error_outline_rounded,
                      color: appColors.profileCritical,
                    ),
                    const SizedBox(width: 12),
                    _MetricCard(
                      label: 'Cuatrimestre',
                      value: student.semester ?? '$term°',
                      icon: Icons.calendar_today_rounded,
                      color: appColors.profileModerateRisk,
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                
                // Curricular Progress
                Text(
                  'Avance Curricular',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        backgroundColor: appColors.cardBorder,
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${progress.round()}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '~214 créditos de 350 estimados',
                  style: theme.textTheme.bodySmall?.copyWith(color: appColors.mutedText),
                ),

                const SizedBox(height: 32),

                // Trajectory
                Text(
                  'Evaluación de Trayectoria',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _TrajectoryLine(currentTerm: term, risk: trajectoryRisk),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getRiskColor(appColors, trajectoryRisk).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _getRiskColor(appColors, trajectoryRisk).withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: _getRiskColor(appColors, trajectoryRisk),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Estado: $trajectoryRisk',
                          style: TextStyle(
                            color: _getRiskColor(appColors, trajectoryRisk),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Debt Subjects
                Text(
                  'Materias Adeudadas',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (student.delayedSubjects == 0)
                  Text(
                    'El alumno no cuenta con materias adeudadas actualmente.',
                    style: TextStyle(color: appColors.mutedText, fontSize: 13),
                  )
                else ...[
                  _DebtItem(name: 'Matemáticas para Ingeniería', status: 'Reprobada'),
                  _DebtItem(name: 'Física I', status: 'No cursada'),
                  if (student.delayedSubjects > 2)
                    _DebtItem(name: 'Inglés IV', status: 'Reprobada'),
                ],

                const SizedBox(height: 40),
                
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Cerrar revisión'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getProfileColor(AppThemeColors colors, String profile) {
    if (profile.contains('Regular')) return colors.profileRegular;
    if (profile.contains('Atípico')) return colors.profileAtypical;
    if (profile.contains('Crítico')) return colors.profileCritical;
    if (profile.contains('Riesgo')) return colors.profileModerateRisk;
    return colors.mutedText;
  }

  Color _getProjectionColor(AppThemeColors colors, String projection) {
    if (projection.contains('normal')) return colors.profileAtypical;
    if (projection.contains('extendida')) return colors.profileModerateRisk;
    return colors.profileCritical;
  }

  Color _getRiskColor(AppThemeColors colors, String risk) {
    return switch (risk) {
      'En tiempo' => colors.profileAtypical,
      'Puede terminar con extensión' => colors.profileModerateRisk,
      'Requiere permiso' => colors.profileCritical,
      'Riesgo alto' => colors.profileCritical,
      _ => colors.mutedText,
    };
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: appColors.mutedText),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrajectoryLine extends StatelessWidget {
  const _TrajectoryLine({required this.currentTerm, required this.risk});
  final int currentTerm;
  final String risk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(12, (index) {
            final term = index + 1;
            final isCurrent = term == currentTerm;
            final isPast = term < currentTerm;

            return Expanded(
              child: Column(
                children: [
                  Container(
                    height: 4,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isCurrent 
                        ? theme.colorScheme.primary 
                        : (isPast ? theme.colorScheme.primary.withValues(alpha: 0.3) : appColors.cardBorder),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$term',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent ? theme.colorScheme.primary : appColors.mutedText,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Carrera Normal (1-9)', style: TextStyle(fontSize: 9, color: appColors.mutedText)),
            Text('Extensión (10-12)', style: TextStyle(fontSize: 9, color: appColors.profileModerateRisk)),
          ],
        ),
      ],
    );
  }
}

class _DebtItem extends StatelessWidget {
  const _DebtItem({required this.name, required this.status});
  final String name;
  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(Icons.circle, color: appColors.profileCritical, size: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: appColors.profileCritical.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              status,
              style: TextStyle(color: appColors.profileCritical, fontSize: 9, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
