import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_components/app_loading_indicator.dart';
import '../../domain/entities/secure_vault_data.dart';
import '../providers/secure_vault_provider.dart';

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
  @override
  void initState() {
    super.initState();
    _loadVault();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _notesController.dispose();
    _phoneController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SecureVaultProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Baúl encriptado')),
      body: SafeArea(
        child: provider.isLoading
            ? const Center(child: AppLoadingIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Datos confidenciales',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.isEnabled
                        ? 'La información se guarda con el almacén seguro del dispositivo.'
                        : 'El baúl está desactivado temporalmente.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _passwordController,
                    enabled: provider.isEnabled,
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
                    enabled: provider.isEnabled,
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
                    enabled: provider.isEnabled,
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
                    enabled: provider.isEnabled,
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
                    onPressed: provider.isSaving || !provider.isEnabled
                        ? null
                        : _saveVault,
                    icon: provider.isSaving
                        ? const AppLoadingIndicator(size: 18)
                        : const Icon(Icons.lock),
                    label: const Text('Guardar en baúl'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: provider.isSaving || !provider.isEnabled
                        ? null
                        : _clearVault,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Vaciar baúl'),
                  ),
                  if (provider.message != null) ...[
                    const SizedBox(height: 12),
                    Text(provider.message!, textAlign: TextAlign.center),
                  ],
                ],
              ),
      ),
    );
  }

  Future<void> _loadVault() async {
    final provider = context.read<SecureVaultProvider>();
    await provider.load();
    if (!mounted) return;
    final data = provider.data;
    _passwordController.text = data.savedPassword;
    _notesController.text = data.privateNotes;
    _phoneController.text = data.phoneNumber;
    _cardController.text = data.cardNumber;
  }

  Future<void> _saveVault() async {
    await context.read<SecureVaultProvider>().save(
      SecureVaultData(
        savedPassword: _passwordController.text,
        privateNotes: _notesController.text,
        phoneNumber: _phoneController.text,
        cardNumber: _cardController.text,
      ),
    );
  }

  Future<void> _clearVault() async {
    await context.read<SecureVaultProvider>().clear();
    _passwordController.clear();
    _notesController.clear();
    _phoneController.clear();
    _cardController.clear();
  }
}
