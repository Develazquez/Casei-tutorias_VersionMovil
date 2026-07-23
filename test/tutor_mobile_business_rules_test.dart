import 'package:casei_tutorias/features/auth/domain/entities/user_entity.dart';
import 'package:casei_tutorias/features/auth/domain/repositories/auth_repository.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/login_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/logout_usecase.dart';
import 'package:casei_tutorias/features/auth/domain/usecases/register_usecase.dart';
import 'package:casei_tutorias/features/auth/presentation/providers/auth_provider.dart';
import 'package:casei_tutorias/features/segmentation/domain/entities/segmentation_student_entity.dart';
import 'package:casei_tutorias/features/segmentation/presentation/providers/segmentation_navigation_provider.dart';
import 'package:casei_tutorias/features/segmentation/presentation/util/tutor_logic_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rechaza una sesión móvil con rol distinto de tutor', () async {
    final repository = _FakeAuthRepository(_director);
    final provider = _buildProvider(repository);
    addTearDown(provider.dispose);

    final result = await provider.login(
      email: _director.email,
      password: 'secret',
    );

    expect(result, isFalse);
    expect(provider.isAuthenticated, isFalse);
    expect(provider.errorMessage, contains('únicamente para tutores'));
    expect(repository.logoutCalls, 1);
  });

  test('acepta una sesión móvil con rol tutor', () async {
    final repository = _FakeAuthRepository(_tutor);
    final provider = _buildProvider(repository);
    addTearDown(provider.dispose);

    final result = await provider.login(
      email: _tutor.email,
      password: 'secret',
    );

    expect(result, isTrue);
    expect(provider.user, same(_tutor));
    expect(repository.logoutCalls, 0);
  });

  test('la navegación de segmentación solo admite dashboard y búsqueda', () {
    final provider = SegmentationNavigationProvider();
    addTearDown(provider.dispose);

    provider.setTab(1);
    expect(provider.currentTabIndex, 1);

    provider.setTab(2);
    expect(provider.currentTabIndex, 1);
  });

  test('no infiere sexo cuando el backend no entrega el campo', () {
    expect(TutorLogicUtils.getStudentGender(_student), 'Sin dato');
  });
}

AuthProvider _buildProvider(AuthRepository repository) {
  return AuthProvider(
    LoginUseCase(repository),
    RegisterUseCase(repository),
    LogoutUseCase(repository),
    GetCurrentUserUseCase(repository),
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this.user);

  final UserEntity user;
  int logoutCalls = 0;

  @override
  Future<UserEntity?> getCurrentUser() async => user;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async => user;

  @override
  Future<void> logout() async {
    logoutCalls += 1;
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  }) async => user;
}

const _tutor = UserEntity(
  id: 'tutor-id',
  name: 'Tutora de prueba',
  email: 'tutor@example.com',
  role: 'tutor',
);

const _director = UserEntity(
  id: 'director-id',
  name: 'Director de prueba',
  email: 'director@example.com',
  role: 'director',
);

const _student = SegmentationStudentEntity(
  id: 'student-id',
  name: 'Nombre sin dato institucional',
  program: 'Software',
  cohort: '2024',
  period: '2026-1',
  cluster: 0,
  profileLabel: 'Sin segmentación',
  averageGrade: 80,
  attendanceRate: 90,
  delayedSubjects: 0,
  membershipScore: 0,
);
