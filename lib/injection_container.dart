import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/http/http_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_supabase_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/segmentation/data/datasources/segmentation_mock_data_source.dart';
import 'features/segmentation/data/repositories/segmentation_repository_impl.dart';
import 'features/segmentation/domain/repositories/segmentation_repository.dart';
import 'features/segmentation/domain/usecases/get_dashboard_summary_usecase.dart';
import 'features/segmentation/domain/usecases/get_segmentation_students_usecase.dart';
import 'features/segmentation/presentation/providers/segmentation_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl
    ..registerLazySingleton<http.Client>(() => http.Client())
    ..registerLazySingleton<TokenStorage>(() => TokenStorage())
    ..registerLazySingleton<HttpClient>(() => HttpClient(sl(), sl()))
    ..registerLazySingleton<SupabaseClient>(() => Supabase.instance.client)
    ..registerLazySingleton<AuthSupabaseDataSource>(
      () => AuthSupabaseDataSource(sl(), sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerFactory(() => AuthProvider(sl(), sl(), sl(), sl()))
    ..registerLazySingleton<SegmentationMockDataSource>(
      () => SegmentationMockDataSource(),
    )
    ..registerLazySingleton<SegmentationRepository>(
      () => SegmentationRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetDashboardSummaryUseCase(sl()))
    ..registerLazySingleton(() => GetSegmentationStudentsUseCase(sl()))
    ..registerFactory(() => SegmentationProvider(sl(), sl()));
}
