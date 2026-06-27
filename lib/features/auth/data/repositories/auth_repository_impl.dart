import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_supabase_data_source.dart';
import '../mappers/auth_mapper.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final AuthSupabaseDataSource _dataSource;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final dto = await _dataSource.login(email: email, password: password);
    return AuthMapper.toEntity(dto);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  }) async {
    final dto = await _dataSource.register(
      email: email,
      password: password,
      nombre: nombre,
      apellidos: apellidos,
      role: role,
      telefono: telefono,
    );
    return AuthMapper.toEntity(dto);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final dto = await _dataSource.getCurrentUser();
    return dto == null ? null : AuthMapper.toEntity(dto);
  }

  @override
  Future<void> logout() => _dataSource.logout();
}
