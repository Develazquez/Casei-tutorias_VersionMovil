import 'package:flutter/material.dart';

import '../../../../core/theme/theme_casei_material3.dart';

class TutorDrawerHeader extends StatelessWidget {
  const TutorDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return DrawerHeader(
      decoration: BoxDecoration(color: theme.colorScheme.surface),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_rounded,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'CACEI',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'Tutor',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: appColors.mutedText,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.close_rounded,
              color: appColors.mutedText,
            ),
            tooltip: 'Cerrar menú de navegación',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
