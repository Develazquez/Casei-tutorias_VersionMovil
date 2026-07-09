import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/pages/segmentation_dashboard_page.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_provider.dart';
import 'package:casei_tutorias/features/segmentation/domain/repositories/segmentation_repository.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/usecases/get_segmentation_students_usecase.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/dashboard_summary_entity.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/segmentation_student_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

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

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(
              LoginUseCase(authRepo),
              RegisterUseCase(authRepo),
              LogoutUseCase(authRepo),
              GetCurrentUserUseCase(authRepo),
            )..restoreSession(),
          ),
          ChangeNotifierProvider(
            create: (_) => SegmentationProvider(
              GetDashboardSummaryUseCase(segRepo),
              GetSegmentationStudentsUseCase(segRepo),
            ),
          ),
        ],
        child: const MaterialApp(home: SegmentationDashboardPage()),
      ),
    );

    await tester.pumpAndSettle();

    // 1. El botón Icons.menu_rounded está visible.
    final menuButton = find.byTooltip('Abrir menú de navegación');
    expect(menuButton, findsOneWidget);

    // 2. Pulsar el botón abre el drawer.
    await tester.tap(menuButton);
    await tester.pumpAndSettle();

    // Verificar si el NavigationDrawer está presente
    expect(find.byType(NavigationDrawer), findsOneWidget);

    expect(find.textContaining('CACEI'), findsOneWidget);
    expect(find.text('Tutor'), findsAtLeastNWidgets(1));

    // 3. El drawer contiene la opción de navegación disponible actualmente.
    expect(find.textContaining('Segmentación Tutorados'), findsOneWidget);

    // 4. Pulsar el botón de cierre cierra el drawer.
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
