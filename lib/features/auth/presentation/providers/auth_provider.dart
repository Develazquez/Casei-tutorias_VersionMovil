import 'package:flutter/foundation.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/utils/view_state.dart';
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
    this._getCurrentUserUseCase,
  );

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  ViewState _state = ViewState.idle;
  String? _errorMessage;
  UserEntity? _user;

  ViewState get state => _state;
  String? get errorMessage => _errorMessage;
  UserEntity? get user => _user;
  bool get isAuthenticated => _user != null;

  Future<void> restoreSession() async {
    _state = ViewState.loading;
    notifyListeners();
    _user = await _getCurrentUserUseCase();
    _state = _user == null ? ViewState.idle : ViewState.success;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _user = await _loginUseCase(email: email, password: password);
      _state = ViewState.success;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
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
    notifyListeners();
    try {
      _user = await _registerUseCase(
        email: email,
        password: password,
        nombre: nombre,
        apellidos: apellidos,
        role: role,
        telefono: telefono,
      );
      _state = ViewState.success;
      notifyListeners();
      return true;
    } on AppException catch (e) {
      _errorMessage = e.message;
      _state = ViewState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _logoutUseCase();
    _user = null;
    _state = ViewState.idle;
    notifyListeners();
  }
}
