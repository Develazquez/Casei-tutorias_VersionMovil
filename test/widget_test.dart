import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/pages/login_page.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
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
