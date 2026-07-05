import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/ui/cacei_ui_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/tutor_navigation_view_model.dart';
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
      onDestinationSelected: (index) {
        final item = viewModel.items[index];

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

        viewModel.setSelectedIndex(index);

        if (item.route != null) {
          Navigator.of(context).pop(); // Cerrar drawer
          if (item.id == 'dashboard') {
            Navigator.pushReplacementNamed(context, item.route!);
          }
        }
      },
      children: [
        const TutorDrawerHeader(),
        ...viewModel.items.map((item) {
          final isSelected =
              viewModel.selectedIndex == viewModel.items.indexOf(item);
          return NavigationDrawerDestination(
            icon: Icon(item.iconData, color: CaceiUiColors.primary),
            selectedIcon:
                Icon(item.selectedIconData, color: CaceiUiColors.primary),
            label: Text(
              item.label + (item.comingSoon ? ' (Próx.)' : ''),
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
                '/login',
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
