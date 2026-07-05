import 'package:flutter/material.dart';

import 'core/navigation/app_navigator.dart';
import 'core/security/security_shell.dart';
import 'core/security/secure_storage_service.dart';
import 'injection_container.dart' as di;
import 'features/auth/presentation/pages/auth_checker.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/security/presentation/pages/secure_vault_page.dart';
import 'features/segmentation/presentation/pages/segmentation_dashboard_v2_page.dart';

class CaseiTutoriasApp extends StatelessWidget {
  const CaseiTutoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.key,
      title: 'CACEI Tutorías',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      builder: (context, child) {
        return SecurityShell(
          secureStorage: di.sl<SecureStorageService>(),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthChecker(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/segmentation': (_) => const SegmentationDashboardV2Page(),
        '/security/vault': (_) => const SecureVaultPage(),
      },
    );
  }
}
