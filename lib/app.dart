import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'core/security/security_shell.dart';
import 'core/security/secure_storage_service.dart';
import 'core/theme/theme_casei_material3.dart';
import 'features/auth/presentation/components/auth_callback_coordinator.dart';

class CaseiTutoriasApp extends StatelessWidget {
  const CaseiTutoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use a default text theme since we don't have a specific font yet.
    // Material 3 will use its default typography if we pass an empty TextTheme
    // or we can use the one from a default theme.
    final textTheme = Theme.of(context).textTheme;
    final theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      routerConfig: context.read<GoRouter>(),
      title: 'CACEI Tutorías',
      debugShowCheckedModeBanner: false,
      theme: theme.light(),
      darkTheme: theme.dark(),
      themeMode: ThemeMode.system,
      builder: (context, child) {
        return AuthCallbackCoordinator(
          child: SecurityShell(
            secureStorage: context.read<SecureStorageService>(),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
