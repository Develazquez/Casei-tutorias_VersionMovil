import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/constants/app_constants.dart';
import 'core/security/firebase_messaging_service.dart';
import 'core/security/security_shell.dart';
import 'core/security/secure_storage_service.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/segmentation/presentation/providers/segmentation_provider.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    publishableKey: AppConstants.supabaseAnonKey,
  );
  await di.init();
  await di.sl<FirebaseMessagingService>().initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => di.sl<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => di.sl<SegmentationProvider>()),
      ],
      child: SecurityShell(
        secureStorage: di.sl<SecureStorageService>(),
        child: const CaseiTutoriasApp(),
      ),
    ),
  );
}
