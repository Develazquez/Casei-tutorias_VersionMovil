import 'package:flutter/foundation.dart';

import '../../domain/entities/secure_vault_data.dart';
import '../../domain/usecases/clear_secure_vault_usecase.dart';
import '../../domain/usecases/read_secure_vault_usecase.dart';
import '../../domain/usecases/save_secure_vault_usecase.dart';

class SecureVaultViewModel extends ChangeNotifier {
  SecureVaultViewModel(this._read, this._save, this._clear);

  final ReadSecureVaultUseCase _read;
  final SaveSecureVaultUseCase _save;
  final ClearSecureVaultUseCase _clear;

  SecureVaultData _data = SecureVaultData.empty;
  bool _loading = true;
  bool _saving = false;
  String? _message;

  SecureVaultData get data => _data;
  bool get isEnabled => _read.isEnabled;
  bool get isLoading => _loading;
  bool get isSaving => _saving;
  String? get message => _message;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    _data = await _read();
    _loading = false;
    notifyListeners();
  }

  Future<void> save(SecureVaultData data) async {
    _saving = true;
    _message = null;
    notifyListeners();
    await _save(data);
    _data = data;
    _saving = false;
    _message = 'Datos guardados de forma segura.';
    notifyListeners();
  }

  Future<void> clear() async {
    _saving = true;
    _message = null;
    notifyListeners();
    await _clear();
    _data = SecureVaultData.empty;
    _saving = false;
    _message = 'Baúl encriptado vaciado.';
    notifyListeners();
  }
}
