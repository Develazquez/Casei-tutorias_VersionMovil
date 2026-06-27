import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/errors/failures.dart';
import '../../../../core/security/firebase_messaging_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_dto.dart';

class AuthSupabaseDataSource {
  const AuthSupabaseDataSource(
    this._client,
    this._tokenStorage,
    this._messagingService,
  );

  final supabase.SupabaseClient _client;
  final TokenStorage _tokenStorage;
  final FirebaseMessagingService _messagingService;

  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      final session = response.session;
      if (user == null || session == null) {
        throw const AuthException('No se pudo iniciar sesión.');
      }

      final profile = await _fetchProfile(user.id);
      final dto = _dtoFromProfile(
        profile,
        token: session.accessToken,
        fallbackEmail: user.email ?? email.trim(),
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      await _messagingService.registerCurrentDevice();
      return dto;
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message);
    } on supabase.PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<UserDto> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  }) async {
    if (role == 'alumno') {
      throw const ValidationException(
        'Los alumnos no pueden registrarse directamente. Deben ser importados por el Director.',
      );
    }

    try {
      final response = await _client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      final user = response.user;
      final session = response.session;
      if (user == null) {
        throw const AuthException('No se pudo crear la cuenta.');
      }

      if (session == null) {
        throw const AuthException(
          'Cuenta creada. Revisa tu correo para confirmar el acceso antes de iniciar sesión.',
        );
      }

      final profile = await _client
          .from('profiles')
          .upsert({
            'id': user.id,
            'email': user.email ?? email.trim(),
            'nombre': nombre.trim(),
            'apellidos': apellidos.trim(),
            'telefono': _emptyToNull(telefono),
            'rol': role,
            'activo': true,
          })
          .select()
          .single();

      final dto = _dtoFromProfile(
        Map<String, dynamic>.from(profile),
        token: session.accessToken,
        fallbackEmail: user.email ?? email.trim(),
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      await _messagingService.registerCurrentDevice();
      return dto;
    } on supabase.AuthException catch (e) {
      throw AuthException(e.message);
    } on supabase.PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  Future<UserDto?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      final session = _client.auth.currentSession;
      if (user == null || session == null) return null;

      final profile = await _fetchProfile(user.id);
      final dto = _dtoFromProfile(
        profile,
        token: session.accessToken,
        fallbackEmail: user.email ?? '',
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      await _messagingService.registerCurrentDevice();
      return dto;
    } on supabase.PostgrestException {
      return null;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
    await _tokenStorage.clear();
  }

  Future<Map<String, dynamic>> _fetchProfile(String userId) async {
    final profile = await _client
        .from('profiles')
        .select('id, nombre, apellidos, email, rol, telefono, activo')
        .eq('id', userId)
        .single();

    return Map<String, dynamic>.from(profile);
  }

  UserDto _dtoFromProfile(
    Map<String, dynamic> profile, {
    required String token,
    required String fallbackEmail,
  }) {
    final nombre = profile['nombre']?.toString().trim() ?? '';
    final apellidos = profile['apellidos']?.toString().trim() ?? '';
    final fullName = [nombre, apellidos].where((value) => value.isNotEmpty);

    return UserDto(
      id: profile['id'].toString(),
      name: fullName.join(' ').trim(),
      email: profile['email']?.toString() ?? fallbackEmail,
      role: profile['rol']?.toString() ?? 'tutor',
      token: token,
    );
  }

  String? _emptyToNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
