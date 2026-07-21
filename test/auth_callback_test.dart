import 'dart:async';

import 'package:casei_tutorias/core/constants/app_constants.dart';
import 'package:casei_tutorias/core/errors/failures.dart';
import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('usa el deep link móvil como redirect de confirmación', () {
    expect(AppConstants.authEmailRedirectUrl, 'com.casei://callback/auth');
  });

  test(
    'expone el registro pendiente de confirmación como resultado válido',
    () async {
      final repository = _FakeAuthRepository(
        registerError: const EmailConfirmationRequiredException(
          'Cuenta creada. Revisa tu correo.',
        ),
      );
      final provider = _buildProvider(repository);
      addTearDown(provider.dispose);

      final result = await provider.register(
        email: 'tutor@upchiapas.edu.mx',
        password: 'Password123!',
        nombre: 'Tutor',
        apellidos: 'Prueba',
        role: 'tutor',
      );

      expect(result, isTrue);
      expect(provider.emailConfirmationPending, isTrue);
      expect(provider.statusMessage, 'Cuenta creada. Revisa tu correo.');
      expect(provider.user, isNull);
    },
  );

  test('restaura la sesión cuando Supabase confirma el deep link', () async {
    final authChanges = StreamController<bool>.broadcast();
    final repository = _FakeAuthRepository(currentUser: _user);
    final provider = _buildProvider(
      repository,
      authStateChanges: authChanges.stream,
    );
    addTearDown(() async {
      provider.dispose();
      await authChanges.close();
    });

    authChanges.add(true);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(provider.user, _user);
    expect(provider.isAuthenticated, isTrue);
    expect(provider.consumeAuthCallbackCompletion(), isTrue);
    expect(provider.consumeAuthCallbackCompletion(), isFalse);
  });
}

AuthProvider _buildProvider(
  AuthRepository repository, {
  Stream<bool> authStateChanges = const Stream<bool>.empty(),
}) {
  return AuthProvider(
    LoginUseCase(repository),
    RegisterUseCase(repository),
    LogoutUseCase(repository),
    GetCurrentUserUseCase(repository),
    authStateChanges: authStateChanges,
  );
}

class _FakeAuthRepository implements AuthRepository {
  const _FakeAuthRepository({this.currentUser, this.registerError});

  final UserEntity? currentUser;
  final AppException? registerError;

  @override
  Future<UserEntity?> getCurrentUser() async => currentUser;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return currentUser ?? _user;
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
  }) async {
    final error = registerError;
    if (error != null) throw error;
    return currentUser ?? _user;
  }
}

const _user = UserEntity(
  id: 'confirmed-user',
  name: 'Tutor Confirmado',
  email: 'tutor@upchiapas.edu.mx',
  role: 'tutor',
);
