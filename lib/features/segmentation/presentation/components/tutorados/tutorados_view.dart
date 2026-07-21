import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../../domain/entities/segmentation_student_entity.dart';
import '../../providers/segmentation_dashboard_provider.dart';
import '../../providers/segmentation_provider.dart';
import '../../util/tutor_logic_utils.dart';
import '../common/student_academic_detail_bottom_sheet.dart';
import '../common/student_list_bottom_sheet.dart';
import '../dashboard/student_summary_card.dart';

class TutoradosView extends StatefulWidget {
  const TutoradosView({super.key});

  @override
  State<TutoradosView> createState() => _TutoradosViewState();
}

class _TutoradosViewState extends State<TutoradosView> {
  String _viewType = 'Alumnos'; // Alumnos or Generaciones

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final dashboardData = context.watch<SegmentationDashboardProvider>().data;
    final segmentationProvider = context.watch<SegmentationProvider>();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alumnos tutorados',
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Consulta, seguimiento y análisis de los estudiantes asignados.',
                    style: TextStyle(fontSize: 12, color: appColors.mutedText),
                  ),
                ],
              ),
            ),
            _buildExportActions(context),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Summary Cards
        Row(
          children: [
            Expanded(
              child: StudentSummaryCard(
                label: 'Tutorados',
                count: dashboardData.totalStudents,
                description: 'Total asignado',
                icon: Icons.people_outline_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StudentSummaryCard(
                label: 'En Riesgo',
                count: dashboardData.urgentTrackingCount,
                description: 'Atención especial',
                icon: Icons.warning_amber_rounded,
                color: appColors.profileCritical,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Filters Section
        _buildFilters(context, segmentationProvider),
        
        const SizedBox(height: 24),
        
        // View Toggle
        Row(
          children: [
            Expanded(
              child: _ViewToggleBtn(
                label: 'Vista por Alumno',
                isActive: _viewType == 'Alumnos',
                onTap: () => setState(() => _viewType = 'Alumnos'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _ViewToggleBtn(
                label: 'Vista por Generación',
                isActive: _viewType == 'Generaciones',
                onTap: () => setState(() => _viewType = 'Generaciones'),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        if (_viewType == 'Alumnos')
          _buildStudentList(context, segmentationProvider.students)
        else
          _buildGenerationList(context, dashboardData.generationMetrics),
          
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildExportActions(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert_rounded),
      itemBuilder: (context) => [
        const PopupMenuItem(
          child: Row(children: [Icon(Icons.print_outlined, size: 18), SizedBox(width: 8), Text('Imprimir')]),
        ),
        const PopupMenuItem(
          child: Row(children: [Icon(Icons.picture_as_pdf_outlined, size: 18), SizedBox(width: 8), Text('Exportar PDF')]),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context, SegmentationProvider provider) {
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
          TextField(
            decoration: InputDecoration(
              hintText: 'Buscar por nombre o matrícula...',
              prefixIcon: const Icon(Icons.search_rounded),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onChanged: provider.changeSearchQuery,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildDropdown(
                  label: 'Perfil',
                  value: provider.selectedProfile,
                  items: provider.profiles,
                  onChanged: (v) => provider.changeProfile(v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDropdown(
                  label: 'Programa',
                  value: provider.selectedProgram,
                  items: provider.programs,
                  onChanged: (v) => provider.changeProgram(v!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          items: items.map((i) => DropdownMenuItem(
            value: i, 
            child: Text(
              i, 
              style: const TextStyle(fontSize: 11), 
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          )).toList(),
          onChanged: onChanged,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList(BuildContext context, List<SegmentationStudentEntity> students) {
    if (students.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No se encontraron alumnos que coincidan con los criterios de búsqueda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ),
      );
    }
    return Column(
      children: students.map((s) => _StudentListTile(student: s)).toList(),
    );
  }

  Widget _buildGenerationList(BuildContext context, List<dynamic> metrics) {
    return Column(
      children: metrics.map((m) => _GenerationCard(metric: m)).toList(),
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  const _ViewToggleBtn({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentListTile extends StatelessWidget {
  const _StudentListTile({required this.student});
  final SegmentationStudentEntity student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final profile = TutorLogicUtils.normalizeProfileLabel(student.profileLabel);
    final profileColor = _getProfileColor(appColors, profile);

    return InkWell(
      onTap: () => StudentAcademicDetailBottomSheet.show(context, student),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: appColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: appColors.cardBorder),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: profileColor.withValues(alpha: 0.1),
              child: Text(
                TutorLogicUtils.getInitials(student.name).join(''),
                style: TextStyle(color: profileColor, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('${student.id} · Gen. ${student.cohort}', style: TextStyle(fontSize: 10, color: appColors.mutedText)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(student.averageGrade.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                _ProfileBadge(label: profile, color: profileColor),
              ],
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right_rounded, color: appColors.cardBorder),
          ],
        ),
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
}

class _ProfileBadge extends StatelessWidget {
  const _ProfileBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(color: color, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _GenerationCard extends StatelessWidget {
  const _GenerationCard({required this.metric});
  final dynamic metric;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: appColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: appColors.cardBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Generación ${metric.generation}', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('${metric.totalCount} alumnos', style: TextStyle(fontSize: 12, color: appColors.mutedText)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _MetricItem(label: 'Hombres', value: '${metric.maleCount}', color: appColors.genderMale),
              _MetricItem(label: 'Mujeres', value: '${metric.femaleCount}', color: appColors.genderFemale),
              _MetricItem(label: 'Críticos', value: '${metric.students.where((s) => s.profileLabel.contains('Crítico')).length}', color: appColors.profileCritical),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              StudentListBottomSheet.show(
                context,
                title: 'Generación ${metric.generation}',
                subtitle: '${metric.totalCount} alumnos · ${metric.maleCount} hombres · ${metric.femaleCount} mujeres',
                students: metric.students,
              );
            },
            child: const Text('Ver alumnos de esta generación'),
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ],
    );
  }
}
