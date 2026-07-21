import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/theme_casei_material3.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class TutorDrawerProfile extends StatelessWidget {
  const TutorDrawerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    final String name = user?.name ?? 'CACEI User';
    final String role = user?.role ?? 'Tutor';

    // Obtener iniciales
    String initials = '??';
    if (user != null && user.name.isNotEmpty) {
      final parts = user.name.trim().split(' ');
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      }
    } else if (name != 'CACEI User') {
       initials = name.substring(0, 1).toUpperCase();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              initials,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
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
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  role.substring(0, 1).toUpperCase() + role.substring(1),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appColors.mutedText,
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
