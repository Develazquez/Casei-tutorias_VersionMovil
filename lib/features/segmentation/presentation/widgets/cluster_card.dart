import 'package:flutter/material.dart';

import '../../domain/entities/cluster_profile_entity.dart';

class ClusterCard extends StatelessWidget {
  const ClusterCard({
    required this.cluster,
    required this.totalStudents,
    super.key,
  });

  final ClusterProfileEntity cluster;
  final int totalStudents;

  @override
  Widget build(BuildContext context) {
    final percentage = totalStudents == 0
        ? 0.0
        : (cluster.studentCount / totalStudents).clamp(0.0, 1.0);
    final color = _clusterColor(cluster.cluster, context);
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Text(
                    'C${cluster.cluster}',
                    style: TextStyle(color: color, fontWeight: FontWeight.w800),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    cluster.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: percentage, color: color),
            const SizedBox(height: 10),
            Text(
              '${cluster.studentCount} estudiantes · ${(percentage * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Prom. ${cluster.averageGrade.toStringAsFixed(1)} · Asist. ${cluster.attendanceRate.toStringAsFixed(1)}% · Rezago ${cluster.delayedSubjects.toStringAsFixed(1)}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _clusterColor(int cluster, BuildContext context) {
    return switch (cluster) {
      1 => Colors.orange.shade700,
      2 => Theme.of(context).colorScheme.error,
      3 => Colors.amber.shade800,
      _ => Theme.of(context).colorScheme.primary,
    };
  }
}
