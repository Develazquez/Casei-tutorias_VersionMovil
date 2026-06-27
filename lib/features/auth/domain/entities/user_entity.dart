class UserEntity {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  final String id;
  final String name;
  final String email;
  final String role;

  bool get isDirector => role == 'director';
  bool get isTutor => role == 'tutor';
}
