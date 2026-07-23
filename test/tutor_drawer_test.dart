import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/screens/segmentation_dashboard_v2_page.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_dashboard_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_navigation_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_model_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_search_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_provider.dart';
import 'package:casei_tutorias/features/tutor_navigation/presentation/providers/tutor_navigation_provider.dart';
import 'package:casei_tutorias/features/segmentation/domain/repositories/segmentation_repository.dart';
import 'package:casei_tutorias/features/segmentation/domain/repositories/tutor_dashboard_repository.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_segmentation_model_artifacts_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_tutor_status_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_tutor_students_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_tutor_summary_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/search_tutor_students_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/dashboard_summary_entity.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/segmentation_model_artifacts_entity.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/segmentation_student_entity.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/tutor_status_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:casei_tutorias/core/theme/theme_casei_material3.dart';

void main() {
  testWidgets('Abrir y cerrar el menú lateral', (WidgetTester tester) async {
    // Configurar un tamaño de pantalla muy grande para evitar overflows en los tests
    tester.view.physicalSize = const Size(2500, 2500);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    const securityChannel = MethodChannel(
      'mx.edu.upchiapas.casei_tutorias/security',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(securityChannel, (_) async => null);

    final authRepo = _FakeAuthRepository();
    final segRepo = _FakeSegmentationRepository();
    final tutorRepo = _FakeTutorDashboardRepository();
    final authProvider = AuthProvider(
      LoginUseCase(authRepo),
      RegisterUseCase(authRepo),
      LogoutUseCase(authRepo),
      GetCurrentUserUseCase(authRepo),
    );
    await authProvider.restoreSession();
    addTearDown(authProvider.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: authProvider),
          ChangeNotifierProvider(
            create: (_) => SegmentationProvider(
              GetTutorStatusUseCase(tutorRepo),
              GetTutorStudentsUseCase(tutorRepo),
              GetTutorSummaryUseCase(tutorRepo),
              SearchTutorStudentsUseCase(tutorRepo),
              GetSegmentationModelArtifactsUseCase(segRepo),
            ),
          ),
          ChangeNotifierProxyProvider<
            SegmentationProvider,
            SegmentationDashboardProvider
          >(
            create: (context) => SegmentationDashboardProvider(
              context.read<SegmentationProvider>(),
            ),
            update: (context, source, previous) =>
                SegmentationDashboardProvider(source),
          ),
          ChangeNotifierProvider(
            create: (_) => SegmentationNavigationProvider(),
          ),
          ChangeNotifierProxyProvider<
            SegmentationProvider,
            SegmentationModelProvider
          >(
            create: (context) =>
                SegmentationModelProvider(context.read<SegmentationProvider>()),
            update: (context, source, previous) =>
                SegmentationModelProvider(source),
          ),
          ChangeNotifierProxyProvider<
            SegmentationProvider,
            SegmentationSearchProvider
          >(
            create: (context) => SegmentationSearchProvider(
              context.read<SegmentationProvider>(),
              context.read<AuthProvider>(),
            ),
            update: (context, source, previous) => SegmentationSearchProvider(
              source,
              context.read<AuthProvider>(),
            ),
          ),
          ChangeNotifierProvider(create: (_) => TutorNavigationProvider()),
        ],
        child: MaterialApp(
          theme: MaterialTheme(const TextTheme()).light(),
          home: const SegmentationDashboardV2Page(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final menuButton = find.byTooltip('Abrir menú de navegación');
    expect(menuButton, findsOneWidget);

    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationDrawer), findsOneWidget);
    expect(find.text('CACEI'), findsOneWidget);

    final closeButton = find.byTooltip('Cerrar menú de navegación');
    expect(closeButton, findsOneWidget);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.text('CACEI'), findsNothing);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async => _user;
  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async => _user;
  @override
  Future<void> logout() async {}
  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  }) async => _user;

  static const _user = UserEntity(
    id: 'test-tutor',
    name: 'Diego Velázquez Méndez',
    email: 'tutor@test.com',
    role: 'tutor',
  );
}

class _FakeSegmentationRepository implements SegmentationRepository {
  @override
  Future<SegmentationModelArtifactsEntity> getModelArtifacts() async =>
      const SegmentationModelArtifactsEntity(
        metrics: [],
        experiments: [],
        pcaPoints: [],
        artifacts: [],
      );

  @override
  Future<DashboardSummaryEntity> getSummary({String? role}) async =>
      const DashboardSummaryEntity(
        totalStudents: 10,
        averageGrade: 8.5,
        attendanceRate: 90.0,
        riskStudents: 2,
        clusters: [],
      );

  @override
  Future<List<SegmentationStudentEntity>> getStudents({
    String? role,
    String? profile,
    String? program,
    String? query,
  }) async => [];
}

class _FakeTutorDashboardRepository implements TutorDashboardRepository {
  @override
  Future<TutorStatusEntity> getTutorStatus(String userId) async =>
      const TutorStatusEntity(state: TutorState.modelReady, studentCount: 10);

  @override
  Future<List<SegmentationStudentEntity>> getTutorStudents(
    String userId,
  ) async => [];

  @override
  Future<DashboardSummaryEntity> getTutorSummary(String userId) async =>
      const DashboardSummaryEntity(
        totalStudents: 10,
        averageGrade: 8.5,
        attendanceRate: 90,
        riskStudents: 2,
        clusters: [],
      );

  @override
  Future<List<SegmentationStudentEntity>> searchTutorStudents(
    String userId,
    String query,
  ) async => [];
}
