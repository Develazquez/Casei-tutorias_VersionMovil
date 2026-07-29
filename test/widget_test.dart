import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/screens/login_page.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/navigation/app_router.dart';
import 'package:casei_tutorias/navigation/app_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('renders login page', (WidgetTester tester) async {
    const securityChannel = MethodChannel(
      'mx.edu.upchiapas.casei_tutorias/security',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(securityChannel, (_) async => null);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(securityChannel, null),
    );

    final repository = _FakeAuthRepository();

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AuthProvider(
          LoginUseCase(repository),
          RegisterUseCase(repository),
          LogoutUseCase(repository),
          GetCurrentUserUseCase(repository),
        ),
        child: const MaterialApp(home: LoginPage()),
      ),
    );

    expect(find.text('CACEI - Tutorías'), findsOneWidget);
    expect(find.text('Dashboard de segmentación académica'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('redirige rutas protegidas al login sin sesión', (
    WidgetTester tester,
  ) async {
    const securityChannel = MethodChannel(
      'mx.edu.upchiapas.casei_tutorias/security',
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(securityChannel, (_) async => null);
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(securityChannel, null),
    );

    final repository = _FakeAuthRepository();
    final authProvider = AuthProvider(
      LoginUseCase(repository),
      RegisterUseCase(repository),
      LogoutUseCase(repository),
      GetCurrentUserUseCase(repository),
    );
    final router = AppRouter.create(authProvider);
    addTearDown(router.dispose);
    addTearDown(authProvider.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: authProvider,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      AppScreen.login.route,
    );

    router.go(AppScreen.secureVault.route);
    await tester.pumpAndSettle();

    expect(
      router.routeInformationProvider.value.uri.path,
      AppScreen.login.route,
    );
    expect(find.byType(LoginPage), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<UserEntity?> getCurrentUser() async => null;

  @override
  Future<UserEntity> login({required String email, required String password}) {
    return Future.value(_user);
  }

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
  }) {
    return Future.value(_user);
  }

  static const _user = UserEntity(
    id: 'test-user',
    name: 'Usuario de prueba',
    email: 'test@upchiapas.edu.mx',
    role: 'tutor',
  );
}
