import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_casei_material3.dart';
import '../../../../navigation/app_screen.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../models/tutor_navigation_item.dart';
import '../providers/tutor_navigation_provider.dart';
import 'tutor_drawer_header.dart';
import 'tutor_drawer_profile.dart';

class TutorNavigationDrawer extends StatelessWidget {
  const TutorNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TutorNavigationProvider>();
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return NavigationDrawer(
      backgroundColor: theme.colorScheme.surface,
      indicatorColor: theme.colorScheme.primaryContainer,
      selectedIndex: provider.selectedIndex,
      children: [
        const TutorDrawerHeader(),
        ...provider.items.map((item) {
          final isSelected =
              provider.selectedIndex == provider.items.indexOf(item);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: ListTile(
              selected: isSelected,
              enabled: item.enabled || item.comingSoon,
              selectedTileColor: theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              leading: Icon(
                isSelected ? item.selectedIconData : item.iconData,
                color: item.enabled
                    ? (isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant)
                    : appColors.mutedText,
              ),
              title: Text(
                item.label + (item.comingSoon ? ' (Próx.)' : ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: item.enabled
                      ? (isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface)
                      : appColors.mutedText,
                ),
              ),
              onTap: () => _selectDestination(context, provider, item),
            ),
          );
        }),
        Divider(indent: 28, endIndent: 28, color: theme.colorScheme.outlineVariant),
        const TutorDrawerProfile(),
        Divider(indent: 28, endIndent: 28, color: theme.colorScheme.outlineVariant),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
          child: ListTile(
            onTap: () => _showLogoutDialog(context),
            leading: Icon(Icons.logout_rounded, color: theme.colorScheme.error),
            title: Text(
              'Cerrar sesión',
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  void _selectDestination(
    BuildContext context,
    TutorNavigationProvider provider,
    TutorNavigationItem item,
  ) {
    if (!item.enabled) {
      if (item.comingSoon) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Esta sección estará disponible próximamente en la versión móvil.',
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final index = provider.items.indexOf(item);
    provider.setSelectedIndex(index);

    if (item.route != null) {
      Navigator.of(context).pop();
      if (item.id == 'dashboard') {
        Navigator.pushReplacementNamed(context, item.route!);
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Deseas cerrar la sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppScreen.login.route,
                (route) => false,
              );
            },
            child: Text('Confirmar', style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
