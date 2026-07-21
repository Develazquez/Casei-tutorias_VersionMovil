import 'package:flutter/material.dart';
import '../../models/segmentation_model_data.dart';
import '../../../../../core/theme/theme_casei_material3.dart';

class ExperimentResultsTable extends StatelessWidget {
  const ExperimentResultsTable({required this.experiments, super.key});

  final List<ModelExperimentResult> experiments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        horizontalMargin: 0,
        headingRowHeight: 32,
        dataRowMinHeight: 32,
        dataRowMaxHeight: 40,
        columns: [
          DataColumn(label: Text('Rep.', style: _headStyle(appColors))),
          DataColumn(label: Text('K', style: _headStyle(appColors))),
          DataColumn(label: Text('Silh.', style: _headStyle(appColors))),
          DataColumn(label: Text('Davies', style: _headStyle(appColors))),
          DataColumn(label: Text('Min/Max', style: _headStyle(appColors))),
        ],
        rows: experiments.map((e) {
          final color = e.selected
              ? theme.colorScheme.primaryContainer
              : null;
          return DataRow(
            color: WidgetStateProperty.all(color),
            cells: [
              DataCell(Text(e.representation, style: _cellStyle(theme))),
              DataCell(Text('${e.k}', style: _cellStyle(theme))),
              DataCell(
                Text(e.silhouette.toStringAsFixed(3), style: _cellStyle(theme)),
              ),
              DataCell(
                Text(e.daviesBouldin.toStringAsFixed(3), style: _cellStyle(theme)),
              ),
              DataCell(Text('${e.minSize}/${e.maxSize}', style: _cellStyle(theme))),
            ],
          );
        }).toList(),
      ),
    );
  }

  TextStyle _headStyle(AppThemeColors appColors) => TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: appColors.mutedText,
  );
  
  TextStyle _cellStyle(ThemeData theme) => TextStyle(
    fontSize: 10,
    color: theme.colorScheme.onSurface,
  );
}
