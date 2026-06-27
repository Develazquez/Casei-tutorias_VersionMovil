import 'package:flutter/material.dart';

import '../../domain/entities/segmentation_student_entity.dart';

class StudentList extends StatelessWidget {
  const StudentList({required this.students, super.key});

  final List<SegmentationStudentEntity> students;

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return const Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('No hay estudiantes con esos filtros.')),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Estudiantes segmentados',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text('${students.length} registros'),
              ],
            ),
          ),
          const Divider(height: 1),
          ...students.map(
            (student) => ListTile(
              leading: CircleAvatar(child: Text('C${student.cluster}')),
              title: Text(student.name),
              subtitle: Text(
                '${student.program} · Cohorte ${student.cohort} · ${student.profileLabel}',
              ),
              trailing: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 190),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Prom. ${student.averageGrade.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Asist. ${student.attendanceRate.toStringAsFixed(1)}%',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
