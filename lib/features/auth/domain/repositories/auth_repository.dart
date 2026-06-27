import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  });

  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}
