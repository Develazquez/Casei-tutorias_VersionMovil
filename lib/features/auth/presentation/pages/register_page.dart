import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/view_state.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _role = 'tutor';
  String? _localError;

  static const _roles = {
    'director': 'Director',
    'tutor': 'Tutor',
    'docente': 'Docente',
    'encargado': 'Encargado',
    'alumno': 'Alumno',
  };

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLoading = auth.state == ViewState.loading;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 52,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Registro CASEI',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usa tu correo institucional para crear una cuenta vinculada al backend de CASEI.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  AuthTextField(
                    controller: _nameController,
                    label: 'Nombre',
                    icon: Icons.badge_outlined,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _lastNameController,
                    label: 'Apellidos',
                    icon: Icons.badge,
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _emailController,
                    label: 'Correo institucional',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _phoneController,
                    label: 'Teléfono',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: const InputDecoration(
                      labelText: 'Rol institucional',
                      prefixIcon: Icon(Icons.admin_panel_settings_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: _roles.entries
                        .map(
                          (entry) => DropdownMenuItem(
                            value: entry.key,
                            child: Text(entry.value),
                          ),
                        )
                        .toList(),
                    onChanged: isLoading
                        ? null
                        : (value) => setState(() => _role = value ?? _role),
                  ),
                  if (_role == 'alumno') ...[
                    const SizedBox(height: 10),
                    Text(
                      'Los alumnos se importan desde el panel del Director en CASEI.',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Contraseña',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 12),
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar contraseña',
                    icon: Icons.lock_reset,
                    obscureText: true,
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: isLoading ? null : _submit,
                    icon: isLoading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.person_add_alt),
                    label: const Text('Crear cuenta'),
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Ya tengo cuenta'),
                  ),
                  if (_localError != null || auth.errorMessage != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _localError ?? auth.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _localError = null);

    if (_nameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => _localError = 'Completa los campos obligatorios.');
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _localError = 'Las contraseñas no coinciden.');
      return;
    }

    final ok = await context.read<AuthProvider>().register(
      email: _emailController.text,
      password: _passwordController.text,
      nombre: _nameController.text,
      apellidos: _lastNameController.text,
      role: _role,
      telefono: _phoneController.text,
    );

    if (!mounted || !ok) return;
    Navigator.pushReplacementNamed(context, '/segmentation');
  }
}
