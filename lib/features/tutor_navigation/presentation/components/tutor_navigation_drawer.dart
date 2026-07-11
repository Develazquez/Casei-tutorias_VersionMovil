import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/cacei_ui_colors.dart';
import '../../../../navigation/app_screen.dart';
import '../../../auth/presentation/viewmodels/auth_provider.dart';
import '../models/tutor_navigation_item.dart';
import '../viewmodels/tutor_navigation_view_model.dart';
import 'tutor_drawer_header.dart';
import 'tutor_drawer_profile.dart';

class TutorNavigationDrawer extends StatelessWidget {
  const TutorNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TutorNavigationViewModel>();

    return NavigationDrawer(
      backgroundColor: CaceiUiColors.cardSurface,
      indicatorColor: CaceiUiColors.selectionBackground,
      selectedIndex: viewModel.selectedIndex,
      children: [
        const TutorDrawerHeader(),
        ...viewModel.items.map((item) {
          final isSelected =
              viewModel.selectedIndex == viewModel.items.indexOf(item);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: ListTile(
              selected: isSelected,
              enabled: item.enabled || item.comingSoon,
              selectedTileColor: CaceiUiColors.selectionBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              leading: Icon(
                isSelected ? item.selectedIconData : item.iconData,
                color: item.enabled
                    ? CaceiUiColors.primary
                    : CaceiUiColors.secondaryText,
              ),
              title: Text(
                item.label + (item.comingSoon ? ' (Próx.)' : ''),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Roboto',
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: item.enabled
                      ? (isSelected
                            ? CaceiUiColors.primary
                            : CaceiUiColors.titleText)
                      : CaceiUiColors.secondaryText,
                ),
              ),
              onTap: () => _selectDestination(context, viewModel, item),
            ),
          );
        }),
        const Divider(indent: 28, endIndent: 28, color: CaceiUiColors.border),
        const TutorDrawerProfile(),
        const Divider(indent: 28, endIndent: 28, color: CaceiUiColors.border),
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 16),
          child: ListTile(
            onTap: () => _showLogoutDialog(context),
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
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
    TutorNavigationViewModel viewModel,
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

    final index = viewModel.items.indexOf(item);
    viewModel.setSelectedIndex(index);

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
            child: const Text('Confirmar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
