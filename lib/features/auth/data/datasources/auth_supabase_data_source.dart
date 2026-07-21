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
  static const _supportedRoles = {'director', 'tutor', 'docente', 'alumno'};

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
    if (!_supportedRoles.contains(role)) {
      throw const ValidationException('El rol seleccionado no es válido.');
    }
    if (role == 'alumno') {
      throw const ValidationException(
        'Los alumnos no pueden registrarse directamente. Deben ser importados por el Director.',
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
              'rol': role,
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

    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final metadataRole = metadata['rol']?.toString() ?? '';
    final role =
        _supportedRoles.contains(metadataRole) && metadataRole != 'alumno'
        ? metadataRole
        : 'tutor';

    final createdProfile = await _client
        .from('profiles')
        .upsert({
          'id': user.id,
          'email': user.email ?? '',
          'nombre': metadata['nombre']?.toString().trim() ?? '',
          'apellidos': metadata['apellidos']?.toString().trim() ?? '',
          'telefono': _emptyToNull(metadata['telefono']?.toString()),
          'rol': role,
          'activo': true,
        })
        .select('id, nombre, apellidos, email, rol, telefono, activo')
        .single()
        .timeout(_networkTimeout);

    return Map<String, dynamic>.from(createdProfile);
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
