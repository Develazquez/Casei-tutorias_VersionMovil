import '../../domain/entities/user_entity.dart';
import '../models/user_dto.dart';

class AuthMapper {
  const AuthMapper._();

  static UserEntity toEntity(UserDto dto) {
    return UserEntity(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      role: dto.role,
    );
  }
}
