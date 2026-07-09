import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../theme/segmentation_dashboard_colors.dart';

class ExperimentResultsTable extends StatelessWidget {
  const ExperimentResultsTable({required this.experiments, super.key});

  final List<ModelExperimentResult> experiments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        horizontalMargin: 0,
        headingRowHeight: 32,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 40,
        columns: const [
          DataColumn(label: Text('Rep.', style: _headStyle)),
          DataColumn(label: Text('K', style: _headStyle)),
          DataColumn(label: Text('Silh.', style: _headStyle)),
          DataColumn(label: Text('Davies', style: _headStyle)),
          DataColumn(label: Text('Min/Max', style: _headStyle)),
        ],
        rows: experiments.map((e) {
          final color = e.selected
              ? SegmentationDashboardColors.selectionBackground
              : null;
          return DataRow(
            color: WidgetStateProperty.all(color),
            cells: [
              DataCell(Text(e.representation, style: _cellStyle)),
              DataCell(Text('${e.k}', style: _cellStyle)),
              DataCell(
                Text(e.silhouette.toStringAsFixed(3), style: _cellStyle),
              ),
              DataCell(
                Text(e.daviesBouldin.toStringAsFixed(3), style: _cellStyle),
              ),
              DataCell(Text('${e.minSize}/${e.maxSize}', style: _cellStyle)),
            ],
          );
        }).toList(),
      ),
    );
  }

  static const _headStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: SegmentationDashboardColors.textSecondary,
  );
  static const _cellStyle = TextStyle(
    fontSize: 10,
    color: SegmentationDashboardColors.textPrimary,
  );
}
