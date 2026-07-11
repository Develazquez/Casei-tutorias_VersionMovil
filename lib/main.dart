import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/security/firebase_messaging_service.dart';
import 'features/auth/presentation/viewmodels/auth_provider.dart';
import 'features/segmentation/presentation/viewmodels/segmentation_provider.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final missingConfiguration = AppConstants.missingRuntimeConfiguration();
  if (missingConfiguration.isNotEmpty) {
    runApp(ConfigurationErrorApp(missing: missingConfiguration));
    return;
  }

  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );
  await di.init();
  if (AppConstants.enableRemoteWipe) {
    await di.sl<FirebaseMessagingService>().initialize();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<SegmentationProvider>()),
      ],
      child: const CaseiTutoriasApp(),
    ),
  );
}

class ConfigurationErrorApp extends StatelessWidget {
  const ConfigurationErrorApp({required this.missing, super.key});

  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Configuración incompleta',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'La app necesita variables públicas de Supabase para iniciar. No uses service role ni claves privadas en móvil.',
                ),
                const SizedBox(height: 16),
                ...missing.map((item) => Text('• $item')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
