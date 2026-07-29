import 'package:casei_tutorias/core/di/app_providers.dart';
import 'package:casei_tutorias/core/security/firebase_messaging_service.dart';
import 'package:casei_tutorias/core/security/secure_storage_service.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/features/security/presentation/providers/secure_vault_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_dashboard_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_model_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_navigation_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_search_provider.dart';
import 'package:casei_tutorias/features/tutor_navigation/presentation/providers/tutor_navigation_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('resuelve automáticamente los providers de la aplicación', (
    tester,
  ) async {
    final secureStorage = SecureStorageService();
    final messagingService = FirebaseMessagingService(secureStorage);
    final supabaseClient = SupabaseClient(
      'https://example.supabase.co',
      'test-anon-key',
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );

    var resolved = false;

    await tester.pumpWidget(
      AppProviders(
        supabaseClient: supabaseClient,
        secureStorage: secureStorage,
        messagingService: messagingService,
        child: Builder(
          builder: (context) {
            context.read<AuthProvider>();
            context.read<GoRouter>();
            context.read<SecureVaultProvider>();
            context.read<SegmentationProvider>();
            context.read<SegmentationDashboardProvider>();
            context.read<SegmentationModelProvider>();
            context.read<SegmentationSearchProvider>();
            context.read<SegmentationNavigationProvider>();
            context.read<TutorNavigationProvider>();
            resolved = true;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
