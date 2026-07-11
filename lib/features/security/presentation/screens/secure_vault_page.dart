import 'package:flutter/material.dart';

import '../../../../core/common_components/app_loading_indicator.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/secure_vault_data.dart';
import '../viewmodels/secure_vault_view_model.dart';

class SecureVaultPage extends StatefulWidget {
  const SecureVaultPage({super.key});

  @override
  State<SecureVaultPage> createState() => _SecureVaultPageState();
}

class _SecureVaultPageState extends State<SecureVaultPage> {
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cardController = TextEditingController();
  late final SecureVaultViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<SecureVaultViewModel>();
    _loadVault();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _notesController.dispose();
    _phoneController.dispose();
    _cardController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppBar(title: const Text('Baúl encriptado')),
        body: SafeArea(
          child: _viewModel.isLoading
              ? const Center(child: AppLoadingIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Datos confidenciales',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _viewModel.isEnabled
                          ? 'La información se guarda con el almacén seguro del dispositivo.'
                          : 'El baúl está desactivado temporalmente.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _passwordController,
                      enabled: _viewModel.isEnabled,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña guardada',
                        prefixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      enabled: _viewModel.isEnabled,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Notas privadas',
                        prefixIcon: Icon(Icons.notes),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneController,
                      enabled: _viewModel.isEnabled,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono',
                        prefixIcon: Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _cardController,
                      enabled: _viewModel.isEnabled,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Tarjeta',
                        prefixIcon: Icon(Icons.credit_card),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: _viewModel.isSaving || !_viewModel.isEnabled
                          ? null
                          : _saveVault,
                      icon: _viewModel.isSaving
                          ? const AppLoadingIndicator(size: 18)
                          : const Icon(Icons.lock),
                      label: const Text('Guardar en baúl'),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _viewModel.isSaving || !_viewModel.isEnabled
                          ? null
                          : _clearVault,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Vaciar baúl'),
                    ),
                    if (_viewModel.message != null) ...[
                      const SizedBox(height: 12),
                      Text(_viewModel.message!, textAlign: TextAlign.center),
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _loadVault() async {
    await _viewModel.load();
    if (!mounted) return;
    final data = _viewModel.data;
    _passwordController.text = data.savedPassword;
    _notesController.text = data.privateNotes;
    _phoneController.text = data.phoneNumber;
    _cardController.text = data.cardNumber;
  }

  Future<void> _saveVault() async {
    await _viewModel.save(
      SecureVaultData(
        savedPassword: _passwordController.text,
        privateNotes: _notesController.text,
        phoneNumber: _phoneController.text,
        cardNumber: _cardController.text,
      ),
    );
  }

  Future<void> _clearVault() async {
    await _viewModel.clear();
    _passwordController.clear();
    _notesController.clear();
    _phoneController.clear();
    _cardController.clear();
  }
}
