import 'package:flutter/material.dart';

import '../../../../core/security/secure_vault_service.dart';
import '../../../../injection_container.dart';

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
  final _vaultService = sl<SecureVaultService>();

  bool _loading = true;
  bool _saving = false;
  String? _message;

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
    return Scaffold(
      appBar: AppBar(title: const Text('Baúl encriptado')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
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
                    'La información se guarda con el almacén seguro del dispositivo.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  TextField(
                    controller: _passwordController,
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
                    onPressed: _saving ? null : _saveVault,
                    icon: _saving
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.lock),
                    label: const Text('Guardar en baúl'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _clearVault,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Vaciar baúl'),
                  ),
                  if (_message != null) ...[
                    const SizedBox(height: 12),
                    Text(_message!, textAlign: TextAlign.center),
                  ],
                ],
              ),
      ),
    );
  }

  Future<void> _loadVault() async {
    final data = await _vaultService.readVault();
    if (!mounted) return;
    _passwordController.text = data.savedPassword;
    _notesController.text = data.privateNotes;
    _phoneController.text = data.phoneNumber;
    _cardController.text = data.cardNumber;
    setState(() => _loading = false);
  }

  Future<void> _saveVault() async {
    setState(() {
      _saving = true;
      _message = null;
    });
    await _vaultService.saveVault(
      SecureVaultData(
        savedPassword: _passwordController.text,
        privateNotes: _notesController.text,
        phoneNumber: _phoneController.text,
        cardNumber: _cardController.text,
      ),
    );
    if (!mounted) return;
    setState(() {
      _saving = false;
      _message = 'Datos guardados de forma segura.';
    });
  }

  Future<void> _clearVault() async {
    setState(() {
      _saving = true;
      _message = null;
    });
    await _vaultService.clearVault();
    _passwordController.clear();
    _notesController.clear();
    _phoneController.clear();
    _cardController.clear();
    if (!mounted) return;
    setState(() {
      _saving = false;
      _message = 'Baúl encriptado vaciado.';
    });
  }
}
