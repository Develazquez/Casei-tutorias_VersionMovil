class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String token;

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'].toString(),
      name: json['name'].toString(),
      email: json['email'].toString(),
      role: json['role'].toString(),
      token: json['token'].toString(),
    );
  }
}
