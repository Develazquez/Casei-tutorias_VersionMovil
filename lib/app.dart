import 'package:flutter/material.dart';

import 'features/auth/presentation/pages/auth_checker.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/segmentation/presentation/pages/segmentation_dashboard_page.dart';

class CaseiTutoriasApp extends StatelessWidget {
  const CaseiTutoriasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CASEI Tutorías',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF1E88E5),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const AuthChecker(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/segmentation': (_) => const SegmentationDashboardPage(),
      },
    );
  }
}
