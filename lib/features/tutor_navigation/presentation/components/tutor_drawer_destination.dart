import 'package:flutter/material.dart';
import '../models/tutor_navigation_item.dart';

class TutorDrawerDestination extends StatelessWidget {
  final TutorNavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const TutorDrawerDestination({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDrawerDestination(
      icon: Icon(item.iconData),
      selectedIcon: Icon(item.selectedIconData),
      label: Row(
        children: [
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                color: item.enabled
                    ? (isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface)
                    : Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
          if (item.comingSoon)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Próximamente',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
