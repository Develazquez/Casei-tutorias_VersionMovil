import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/security/firebase_messaging_service.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../../core/util/auth_error_mapper.dart';
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
  static const _networkTimeout = Duration(seconds: 12);
  static const _mobileRole = 'tutor';

  Stream<bool> watchSignedIn() {
    return _client.auth.onAuthStateChange
        .where((change) => change.event == supabase.AuthChangeEvent.signedIn)
        .map((change) => change.session != null);
  }

  Future<UserDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth
          .signInWithPassword(email: email.trim(), password: password)
          .timeout(_networkTimeout);

      final user = response.user;
      final session = response.session;
      if (user == null || session == null) {
        throw const AuthException('No se pudo iniciar sesión.');
      }

      final profile = await _fetchProfile(user);
      final dto = _dtoFromProfile(
        profile,
        token: session.accessToken,
        fallbackEmail: user.email ?? email.trim(),
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      unawaited(_messagingService.registerCurrentDevice());
      return dto;
    } on AuthException {
      await _discardUnauthorizedSession();
      rethrow;
    } on supabase.AuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e.message));
    } on supabase.PostgrestException catch (e) {
      throw ServerException(e.message);
    } on TimeoutException {
      throw const ServerException('El servidor tardó demasiado en responder.');
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
    if (role.trim().toLowerCase() != _mobileRole) {
      throw const ValidationException(
        'La aplicación móvil está disponible únicamente para tutores.',
      );
    }

    try {
      final response = await _client.auth
          .signUp(
            email: email.trim(),
            password: password,
            emailRedirectTo: AppConstants.authEmailRedirectUrl,
            data: {
              'nombre': nombre.trim(),
              'apellidos': apellidos.trim(),
              'telefono': _emptyToNull(telefono),
              'rol': _mobileRole,
              'activo': true,
            },
          )
          .timeout(_networkTimeout);

      final user = response.user;
      final session = response.session;
      if (user == null) {
        throw const AuthException('No se pudo crear la cuenta.');
      }

      if (session == null) {
        throw const EmailConfirmationRequiredException(
          'Cuenta creada. Revisa tu correo y confirma el acceso para volver a la app.',
        );
      }

      final profile = await _fetchProfile(user);

      final dto = _dtoFromProfile(
        profile,
        token: session.accessToken,
        fallbackEmail: user.email ?? email.trim(),
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      unawaited(_messagingService.registerCurrentDevice());
      return dto;
    } on AuthException {
      await _discardUnauthorizedSession();
      rethrow;
    } on supabase.AuthException catch (e) {
      throw AuthException(AuthErrorMapper.map(e.message));
    } on supabase.PostgrestException catch (e) {
      throw ServerException(e.message);
    } on TimeoutException {
      throw const ServerException('El servidor tardó demasiado en responder.');
    }
  }

  Future<UserDto?> getCurrentUser() async {
    try {
      final user = _client.auth.currentUser;
      final session = _client.auth.currentSession;
      if (user == null || session == null) return null;

      final profile = await _fetchProfile(user).timeout(_networkTimeout);
      final dto = _dtoFromProfile(
        profile,
        token: session.accessToken,
        fallbackEmail: user.email ?? '',
      );
      await _tokenStorage.saveSession(token: dto.token, role: dto.role);
      unawaited(_messagingService.registerCurrentDevice());
      return dto;
    } on AuthException {
      await _discardUnauthorizedSession();
      return null;
    } on supabase.PostgrestException {
      return null;
    } on TimeoutException {
      return null;
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut().timeout(_networkTimeout);
    await _tokenStorage.clear();
  }

  Future<Map<String, dynamic>> _fetchProfile(supabase.User user) async {
    final profile = await _client
        .from('profiles')
        .select('id, nombre, apellidos, email, rol, telefono, activo')
        .eq('id', user.id)
        .maybeSingle()
        .timeout(_networkTimeout);

    if (profile != null) {
      return Map<String, dynamic>.from(profile);
    }

    throw const AuthException(
      'Tu cuenta no tiene un perfil institucional válido en CACEI.',
    );
  }

  UserDto _dtoFromProfile(
    Map<String, dynamic> profile, {
    required String token,
    required String fallbackEmail,
  }) {
    final role = profile['rol']?.toString().trim().toLowerCase() ?? '';
    final isActive = profile['activo'] == true;
    if (!isActive) {
      throw const AuthException(
        'Tu cuenta institucional está inactiva. Contacta al administrador.',
      );
    }
    if (role != _mobileRole) {
      throw const AuthException(
        'La aplicación móvil está disponible únicamente para tutores.',
      );
    }

    final nombre = profile['nombre']?.toString().trim() ?? '';
    final apellidos = profile['apellidos']?.toString().trim() ?? '';
    final fullName = [nombre, apellidos].where((value) => value.isNotEmpty);

    return UserDto(
      id: profile['id'].toString(),
      name: fullName.join(' ').trim(),
      email: profile['email']?.toString() ?? fallbackEmail,
      role: role,
      token: token,
    );
  }

  Future<void> _discardUnauthorizedSession() async {
    try {
      await _client.auth.signOut().timeout(_networkTimeout);
    } catch (_) {
      // The local credential is cleared even when remote sign-out is unavailable.
    }
    await _tokenStorage.clear();
  }

  String? _emptyToNull(String? value) {
    final text = value?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
