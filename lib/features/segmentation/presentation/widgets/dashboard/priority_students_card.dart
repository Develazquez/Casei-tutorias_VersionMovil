import 'package:flutter/material.dart';
import '../../../domain/entities/segmentation_student_entity.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class PriorityStudentsCard extends StatelessWidget {
  const PriorityStudentsCard({
    required this.students,
    required this.criticalCount,
    super.key,
  });

  final List<SegmentationStudentEntity> students;
  final int criticalCount;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Alumnos prioritarios',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: SegmentationDashboardColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: SegmentationDashboardColors.redCritical.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$criticalCount críticos',
                  style: const TextStyle(
                    color: SegmentationDashboardColors.redCritical,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (students.isEmpty)
            const Center(
              child: Text(
                'No hay alumnos prioritarios.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            )
          else
            ...students.map((s) => _PriorityStudentTile(student: s)),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () {}, // No implementado aún
              child: const Text(
                'Ver lista completa',
                style: TextStyle(
                  fontSize: 12,
                  color: SegmentationDashboardColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityStudentTile extends StatelessWidget {
  const _PriorityStudentTile({required this.student});
  final SegmentationStudentEntity student;

  @override
  Widget build(BuildContext context) {
    final isCritical = student.profileLabel.contains('Crítico');
    final color = isCritical
        ? SegmentationDashboardColors.redCritical
        : SegmentationDashboardColors.orangeRisk;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Text(
              _getInitials(student.name),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
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
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: SegmentationDashboardColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${student.program} · Sem. 4', // Mock semestre por falta de campo
                  style: const TextStyle(
                    fontSize: 10,
                    color: SegmentationDashboardColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isCritical ? 'CRÍTICO' : 'RIESGO',
              style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_right_rounded,
            color: SegmentationDashboardColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name[0];
  }
}
