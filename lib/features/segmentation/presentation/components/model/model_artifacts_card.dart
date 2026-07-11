import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../../../../core/theme/segmentation_dashboard_colors.dart';

class ModelArtifactsCard extends StatelessWidget {
  const ModelArtifactsCard({required this.artifacts, super.key});

  final List<ModelArtifactItem> artifacts;

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
          const Text(
            'Historial de artefactos',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: SegmentationDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...artifacts.map((a) => _ArtifactTile(item: a)),
        ],
      ),
    );
  }
}

class _ArtifactTile extends StatelessWidget {
  const _ArtifactTile({required this.item});
  final ModelArtifactItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'La consulta de este artefacto estará disponible próximamente.',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: SegmentationDashboardColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getIcon(item.type),
                color: SegmentationDashboardColors.primaryBlue,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: SegmentationDashboardColors.textPrimary,
                    ),
                  ),
                  Text(
                    item.fileName,
                    style: const TextStyle(
                      fontSize: 10,
                      color: SegmentationDashboardColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              item.createdAt.split(' ')[0], // Solo fecha
              style: const TextStyle(
                fontSize: 10,
                color: SegmentationDashboardColors.textSecondary,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: SegmentationDashboardColors.border,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String type) {
    return switch (type) {
      'CSV' => Icons.table_chart_outlined,
      'MD' => Icons.description_outlined,
      'JSON' => Icons.code_rounded,
      _ => Icons.insert_drive_file_outlined,
    };
  }
}
