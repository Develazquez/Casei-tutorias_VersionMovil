import 'package:flutter/material.dart';

import '../features/auth/presentation/screens/auth_checker.dart';
import '../features/auth/presentation/screens/login_page.dart';
import '../features/auth/presentation/screens/register_page.dart';
import '../features/security/presentation/screens/secure_vault_page.dart';
import '../features/segmentation/presentation/screens/segmentation_dashboard_v2_page.dart';
import 'app_screen.dart';

abstract final class AppRouter {
  static String get initialRoute => AppScreen.sessionCheck.route;

  static Map<String, WidgetBuilder> get routes => {
    AppScreen.sessionCheck.route: (_) => const AuthChecker(),
    AppScreen.login.route: (_) => const LoginPage(),
    AppScreen.register.route: (_) => const RegisterPage(),
    AppScreen.segmentation.route: (_) => const SegmentationDashboardV2Page(),
    AppScreen.secureVault.route: (_) => const SecureVaultPage(),
  };
}
