import 'package:flutter/material.dart';

import '../../../../core/ui/cacei_ui_colors.dart';

class TutorDrawerHeader extends StatelessWidget {
  const TutorDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: CaceiUiColors.cardSurface,
      ),
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
                  color: CaceiUiColors.avatarBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: CaceiUiColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'CACEI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: CaceiUiColors.primary,
                    ),
              ),
              Text(
                'Tutor',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CaceiUiColors.secondaryText,
                    ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: CaceiUiColors.secondaryText),
            tooltip: 'Cerrar menú de navegación',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
