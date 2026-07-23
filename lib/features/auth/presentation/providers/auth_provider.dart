import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/util/view_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider(
    this._loginUseCase,
    this._registerUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase, {
    Stream<bool> authStateChanges = const Stream<bool>.empty(),
  }) {
    _authStateSubscription = authStateChanges.listen(_onAuthStateChanged);
  }

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  StreamSubscription<bool>? _authStateSubscription;
  static const _authTimeout = Duration(seconds: 15);
  static const _tutorOnlyMessage =
      'La aplicación móvil está disponible únicamente para tutores.';

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  UserEntity? _user;
  String? _statusMessage;
  bool _emailConfirmationPending = false;
  bool _authCallbackCompleted = false;
  bool _handlingAuthCallback = false;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  UserEntity? get user => _user;
  bool get isAuthenticated => _user != null;
  String? get statusMessage => _statusMessage;
  bool get emailConfirmationPending => _emailConfirmationPending;

  bool consumeAuthCallbackCompletion() {
    if (!_authCallbackCompleted) return false;
    _authCallbackCompleted = false;
    return true;
  }

  Future<void> restoreSession() async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      final restoredUser = await _getCurrentUserUseCase().timeout(_authTimeout);
      if (restoredUser != null && !restoredUser.isTutor) {
        await _clearUnsupportedSession();
        _errorMessage = _tutorOnlyMessage;
        _state = ViewState.idle;
      } else {
        _user = restoredUser;
        _state = _user == null ? ViewState.idle : ViewState.success;
      }
    } on TimeoutException {
      _user = null;
      _errorMessage = 'La sesión tardó demasiado en restaurarse.';
      _state = ViewState.idle;
    } catch (_) {
      _user = null;
      _errorMessage = 'No fue posible restaurar la sesión.';
      _state = ViewState.idle;
    }
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _statusMessage = null;
    _emailConfirmationPending = false;
    notifyListeners();
    try {
      final loggedInUser = await _loginUseCase(
        email: email,
        password: password,
      ).timeout(_authTimeout);
      if (!loggedInUser.isTutor) {
        await _clearUnsupportedSession();
        _errorMessage = _tutorOnlyMessage;
        _state = ViewState.error;
        notifyListeners();
        return false;
      }
      _user = loggedInUser;
      _state = ViewState.success;
      notifyListeners();
      return true;
    } on TimeoutException {
      _errorMessage =
          'El inicio de sesión tardó demasiado. Revisa tu conexión e intenta de nuevo.';
      _state = ViewState.error;
      notifyListeners();
      return false;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'No fue posible iniciar sesión. Intenta de nuevo.';
      _state = ViewState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String nombre,
    required String apellidos,
    required String role,
    String? telefono,
  }) async {
    _state = ViewState.loading;
    _errorMessage = null;
    _statusMessage = null;
    _emailConfirmationPending = false;
    notifyListeners();
    try {
      final registeredUser = await _registerUseCase(
        email: email,
        password: password,
        nombre: nombre,
        apellidos: apellidos,
        role: role,
        telefono: telefono,
      ).timeout(_authTimeout);
      if (!registeredUser.isTutor) {
        await _clearUnsupportedSession();
        _errorMessage = _tutorOnlyMessage;
        _state = ViewState.error;
        notifyListeners();
        return false;
      }
      _user = registeredUser;
      _state = ViewState.success;
      notifyListeners();
      return true;
    } on EmailConfirmationRequiredException catch (e) {
      _user = null;
      _statusMessage = e.message;
      _emailConfirmationPending = true;
      _state = ViewState.success;
      notifyListeners();
      return true;
    } on TimeoutException {
      _errorMessage =
          'El registro tardó demasiado. Revisa tu conexión e intenta de nuevo.';
      _state = ViewState.error;
      notifyListeners();
      return false;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
      notifyListeners();
      return false;
    } catch (_) {
      _errorMessage = 'No fue posible completar el registro. Intenta de nuevo.';
      _state = ViewState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _logoutUseCase().timeout(_authTimeout);
    } catch (_) {
      // Local state must be cleared even if the remote logout call fails.
    }
    _user = null;
    _statusMessage = null;
    _emailConfirmationPending = false;
    _state = ViewState.idle;
    notifyListeners();
  }

  Future<void> _clearUnsupportedSession() async {
    try {
      await _logoutUseCase().timeout(_authTimeout);
    } catch (_) {
      // Provider state is still cleared when remote sign-out is unavailable.
    }
    _user = null;
  }

  Future<void> _onAuthStateChanged(bool signedIn) async {
    if (!signedIn ||
        _state == ViewState.loading ||
        _user != null ||
        _handlingAuthCallback) {
      return;
    }

    _handlingAuthCallback = true;
    await restoreSession();
    if (_user != null) {
      _emailConfirmationPending = false;
      _statusMessage = null;
      _authCallbackCompleted = true;
      notifyListeners();
    }
    _handlingAuthCallback = false;
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
