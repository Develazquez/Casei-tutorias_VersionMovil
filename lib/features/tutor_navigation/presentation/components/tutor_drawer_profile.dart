import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/cacei_ui_colors.dart';
import '../../../auth/presentation/viewmodels/auth_provider.dart';

class TutorDrawerProfile extends StatelessWidget {
  const TutorDrawerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    // Datos mock si no hay usuario real (según instrucciones)
    final String name = user?.name ?? 'Diego Velázquez Méndez'; // Mock
    final String role = user?.role ?? 'Tutor'; // Mock

    // Obtener iniciales
    String initials = 'DV';
    if (user != null && user.name.isNotEmpty) {
      final parts = user.name.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: CaceiUiColors.primary,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: CaceiUiColors.titleText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role.substring(0, 1).toUpperCase() + role.substring(1),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: CaceiUiColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
