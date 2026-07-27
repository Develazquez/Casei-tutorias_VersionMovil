import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/data/datasources/auth_supabase_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/auth_state_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/auth_state_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/watch_auth_state_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/security/data/repositories/secure_vault_repository_impl.dart';
import '../../features/security/domain/repositories/secure_vault_repository.dart';
import '../../features/security/domain/usecases/clear_secure_vault_usecase.dart';
import '../../features/security/domain/usecases/read_secure_vault_usecase.dart';
import '../../features/security/domain/usecases/save_secure_vault_usecase.dart';
import '../../features/security/presentation/providers/secure_vault_provider.dart';
import '../../features/segmentation/data/datasources/segmentation_remote_data_source.dart';
import '../../features/segmentation/data/datasources/segmentation_supabase_storage_data_source.dart';
import '../../features/segmentation/data/datasources/tutor_supabase_data_source.dart';
import '../../features/segmentation/data/repositories/segmentation_repository_impl.dart';
import '../../features/segmentation/data/repositories/tutor_dashboard_repository_impl.dart';
import '../../features/segmentation/domain/repositories/segmentation_repository.dart';
import '../../features/segmentation/domain/repositories/tutor_dashboard_repository.dart';
import '../../features/segmentation/domain/usecases/get_dashboard_summary_usecase.dart';
import '../../features/segmentation/domain/usecases/get_segmentation_model_artifacts_usecase.dart';
import '../../features/segmentation/domain/usecases/get_segmentation_students_usecase.dart';
import '../../features/segmentation/domain/usecases/get_tutor_status_usecase.dart';
import '../../features/segmentation/domain/usecases/get_tutor_students_usecase.dart';
import '../../features/segmentation/domain/usecases/get_tutor_summary_usecase.dart';
import '../../features/segmentation/domain/usecases/search_tutor_students_usecase.dart';
import '../../features/segmentation/presentation/providers/segmentation_dashboard_provider.dart';
import '../../features/segmentation/presentation/providers/segmentation_model_provider.dart';
import '../../features/segmentation/presentation/providers/segmentation_navigation_provider.dart';
import '../../features/segmentation/presentation/providers/segmentation_provider.dart';
import '../../features/segmentation/presentation/providers/segmentation_search_provider.dart';
import '../../features/tutor_navigation/presentation/providers/tutor_navigation_provider.dart';
import '../network/http_client.dart';
import '../security/firebase_messaging_service.dart';
import '../security/secure_storage_service.dart';
import '../storage/token_storage.dart';
import '../tenant/tenant_provider.dart';

class AppProviders extends StatelessWidget {
  const AppProviders({
    required this.supabaseClient,
    required this.secureStorage,
    required this.messagingService,
    required this.child,
    super.key,
  });

  final SupabaseClient supabaseClient;
  final SecureStorageService secureStorage;
  final FirebaseMessagingService messagingService;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SupabaseClient>.value(value: supabaseClient),
        Provider<SecureStorageService>.value(value: secureStorage),
        Provider<FirebaseMessagingService>.value(value: messagingService),
        Provider<http.Client>(
          create: (_) => http.Client(),
          dispose: (_, client) => client.close(),
        ),
        Provider<TokenStorage>(
          create: (context) =>
              TokenStorage(context.read<SecureStorageService>()),
        ),
        Provider<HttpClient>(
          create: (context) => HttpClient(
            context.read<http.Client>(),
            context.read<TokenStorage>(),
          ),
        ),
        Provider<AuthSupabaseDataSource>(
          create: (context) => AuthSupabaseDataSource(
            context.read<SupabaseClient>(),
            context.read<TokenStorage>(),
            context.read<FirebaseMessagingService>(),
          ),
        ),
        Provider<AuthRepository>(
          create: (context) =>
              AuthRepositoryImpl(context.read<AuthSupabaseDataSource>()),
        ),
        Provider<AuthStateRepository>(
          create: (context) =>
              AuthStateRepositoryImpl(context.read<AuthSupabaseDataSource>()),
        ),
        Provider<LoginUseCase>(
          create: (context) => LoginUseCase(context.read<AuthRepository>()),
        ),
        Provider<RegisterUseCase>(
          create: (context) => RegisterUseCase(context.read<AuthRepository>()),
        ),
        Provider<LogoutUseCase>(
          create: (context) => LogoutUseCase(context.read<AuthRepository>()),
        ),
        Provider<GetCurrentUserUseCase>(
          create: (context) =>
              GetCurrentUserUseCase(context.read<AuthRepository>()),
        ),
        Provider<WatchAuthStateUseCase>(
          create: (context) =>
              WatchAuthStateUseCase(context.read<AuthStateRepository>()),
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<LoginUseCase>(),
            context.read<RegisterUseCase>(),
            context.read<LogoutUseCase>(),
            context.read<GetCurrentUserUseCase>(),
            authStateChanges: context.read<WatchAuthStateUseCase>()(),
          ),
        ),
        ChangeNotifierProvider<TenantProvider>(
          create: (_) => TenantProvider(),
        ),
        Provider<SecureVaultRepository>(
          create: (context) =>
              SecureVaultRepositoryImpl(context.read<SecureStorageService>()),
        ),
        Provider<ReadSecureVaultUseCase>(
          create: (context) =>
              ReadSecureVaultUseCase(context.read<SecureVaultRepository>()),
        ),
        Provider<SaveSecureVaultUseCase>(
          create: (context) =>
              SaveSecureVaultUseCase(context.read<SecureVaultRepository>()),
        ),
        Provider<ClearSecureVaultUseCase>(
          create: (context) =>
              ClearSecureVaultUseCase(context.read<SecureVaultRepository>()),
        ),
        ChangeNotifierProvider<SecureVaultProvider>(
          create: (context) => SecureVaultProvider(
            context.read<ReadSecureVaultUseCase>(),
            context.read<SaveSecureVaultUseCase>(),
            context.read<ClearSecureVaultUseCase>(),
          ),
        ),
        Provider<SegmentationSupabaseStorageDataSource>(
          create: (context) => SegmentationSupabaseStorageDataSource(
            context.read<SupabaseClient>(),
          ),
        ),
        Provider<SegmentationRepository>(
          create: (context) => SegmentationRepositoryImpl(
            context.read<SegmentationSupabaseStorageDataSource>(),
          ),
        ),
        Provider<SegmentationRemoteDataSource>(
          create: (context) => SegmentationRemoteDataSourceImpl(
            context.read<http.Client>(),
            context.read<TokenStorage>(),
          ),
        ),
        Provider<TutorSupabaseDataSource>(
          create: (context) => TutorSupabaseDataSource(
            context.read<SupabaseClient>(),
          ),
        ),
        Provider<TutorDashboardRepository>(
          create: (context) => TutorDashboardRepositoryImpl(
            context.read<SegmentationRemoteDataSource>(),
            context.read<TutorSupabaseDataSource>(),
          ),
        ),
        Provider<GetTutorStatusUseCase>(
          create: (context) => GetTutorStatusUseCase(
            context.read<TutorDashboardRepository>(),
          ),
        ),
        Provider<GetTutorStudentsUseCase>(
          create: (context) => GetTutorStudentsUseCase(
            context.read<TutorDashboardRepository>(),
          ),
        ),
        Provider<GetTutorSummaryUseCase>(
          create: (context) => GetTutorSummaryUseCase(
            context.read<TutorDashboardRepository>(),
          ),
        ),
        Provider<SearchTutorStudentsUseCase>(
          create: (context) => SearchTutorStudentsUseCase(
            context.read<TutorDashboardRepository>(),
          ),
        ),
        Provider<GetDashboardSummaryUseCase>(
          create: (context) => GetDashboardSummaryUseCase(
            context.read<SegmentationRepository>(),
          ),
        ),
        Provider<GetSegmentationStudentsUseCase>(
          create: (context) => GetSegmentationStudentsUseCase(
            context.read<SegmentationRepository>(),
          ),
        ),
        Provider<GetSegmentationModelArtifactsUseCase>(
          create: (context) => GetSegmentationModelArtifactsUseCase(
            context.read<SegmentationRepository>(),
          ),
        ),
        ChangeNotifierProvider<SegmentationProvider>(
          create: (context) => SegmentationProvider(
            context.read<GetTutorStatusUseCase>(),
            context.read<GetTutorStudentsUseCase>(),
            context.read<GetTutorSummaryUseCase>(),
            context.read<SearchTutorStudentsUseCase>(),
            context.read<GetSegmentationModelArtifactsUseCase>(),
          ),
        ),
        ChangeNotifierProvider<SegmentationDashboardProvider>(
          create: (context) => SegmentationDashboardProvider(
            context.read<SegmentationProvider>(),
          ),
        ),
        ChangeNotifierProvider<SegmentationModelProvider>(
          create: (context) =>
              SegmentationModelProvider(context.read<SegmentationProvider>()),
        ),
        ChangeNotifierProvider<SegmentationSearchProvider>(
          create: (context) =>
              SegmentationSearchProvider(
                context.read<SegmentationProvider>(),
                context.read<AuthProvider>(),
              ),
        ),
        ChangeNotifierProvider<SegmentationNavigationProvider>(
          create: (_) => SegmentationNavigationProvider(),
        ),
        ChangeNotifierProvider<TutorNavigationProvider>(
          create: (_) => TutorNavigationProvider(),
        ),
      ],
      child: child,
    );
  }
}
