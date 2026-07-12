import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_casei_material3.dart';
import '../../../domain/entities/segmentation_student_entity.dart';
import '../../util/tutor_logic_utils.dart';
import 'student_academic_detail_bottom_sheet.dart';

class StudentListBottomSheet extends StatefulWidget {
  const StudentListBottomSheet({
    required this.title,
    required this.students,
    this.subtitle,
    this.color,
    super.key,
  });

  final String title;
  final String? subtitle;
  final List<SegmentationStudentEntity> students;
  final Color? color;

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<SegmentationStudentEntity> students,
    String? subtitle,
    Color? color,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StudentListBottomSheet(
        title: title,
        students: students,
        subtitle: subtitle,
        color: color,
      ),
    );
  }

  @override
  State<StudentListBottomSheet> createState() => _StudentListBottomSheetState();
}

class _StudentListBottomSheetState extends State<StudentListBottomSheet> {
  final _searchController = TextEditingController();
  String _genderFilter = 'Todos';
  List<SegmentationStudentEntity> _filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _filteredStudents = widget.students;
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredStudents = widget.students.where((s) {
        final matchesSearch = s.name.toLowerCase().contains(query) || s.id.toLowerCase().contains(query);
        final gender = TutorLogicUtils.getStudentGender(s);
        final matchesGender = _genderFilter == 'Todos' || gender == _genderFilter;
        return matchesSearch && matchesGender;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final effectiveColor = widget.color ?? theme.colorScheme.primary;

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
          
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (widget.subtitle != null)
                            Text(
                              widget.subtitle!,
                              style: theme.textTheme.bodySmall?.copyWith(color: appColors.mutedText),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: effectiveColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.students.length} alumnos',
                        style: TextStyle(color: effectiveColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                
                // Search
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre o matrícula...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.cardBorder),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: appColors.cardBorder),
                    ),
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
                
                const SizedBox(height: 12),
                
                // Gender Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Todos', 'Hombre', 'Mujer'].map((g) {
                      final isSelected = _genderFilter == g;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) {
                              setState(() => _genderFilter = g);
                              _applyFilters();
                            }
                          },
                          showCheckmark: false,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _filteredStudents.isEmpty
                ? Center(
                    child: Text('No se encontraron alumnos.', style: TextStyle(color: appColors.mutedText)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredStudents.length,
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return _StudentListItem(student: student);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StudentListItem extends StatelessWidget {
  const _StudentListItem({required this.student});
  final SegmentationStudentEntity student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;
    final profile = TutorLogicUtils.normalizeProfileLabel(student.profileLabel);
    final profileColor = _getProfileColor(appColors, profile);

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        StudentAcademicDetailBottomSheet.show(context, student);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: appColors.cardBorder.withValues(alpha: 0.5))),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: profileColor.withValues(alpha: 0.1),
              child: Text(
                TutorLogicUtils.getInitials(student.name).join(''),
                style: TextStyle(color: profileColor, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${student.id} · ${student.program}',
                    style: TextStyle(fontSize: 10, color: appColors.mutedText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _SmallBadge(label: 'PROM: ${student.averageGrade.toStringAsFixed(1)}'),
                      const SizedBox(width: 8),
                      _SmallBadge(label: 'ASIST: ${student.attendanceRate.round()}%'),
                      if (student.delayedSubjects > 0) ...[
                        const SizedBox(width: 8),
                        _SmallBadge(
                          label: 'DEUDAS: ${student.delayedSubjects.round()}',
                          color: appColors.profileCritical,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: appColors.cardBorder),
          ],
        ),
      ),
    );
  }

  Color _getProfileColor(AppThemeColors colors, String profile) {
    return switch (profile) {
      'Regular' => colors.profileRegular,
      'Atípico' => colors.profileAtypical,
      'Crítico' => colors.profileCritical,
      'Riesgo moderado' => colors.profileModerateRisk,
      _ => colors.mutedText,
    };
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppThemeColors>()!;
    final effectiveColor = color ?? appColors.mutedText;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(color: effectiveColor, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }
}
