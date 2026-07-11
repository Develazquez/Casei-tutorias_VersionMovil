import 'package:flutter/material.dart';

import 'core/security/security_shell.dart';
import 'core/security/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart' as di;
import 'navigation/app_navigator.dart';
import 'navigation/app_router.dart';

class CaseiTutoriasApp extends StatelessWidget {
  const CaseiTutoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: AppNavigator.key,
      title: 'CACEI Tutorías',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        return SecurityShell(
          secureStorage: di.sl<SecureStorageService>(),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: AppRouter.initialRoute,
      routes: AppRouter.routes,
    );
  }
}
