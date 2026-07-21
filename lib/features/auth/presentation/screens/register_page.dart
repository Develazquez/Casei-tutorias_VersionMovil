import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/util/view_state.dart';
import '../../../../navigation/app_screen.dart';
import '../components/auth_text_field.dart';
import '../providers/auth_provider.dart';

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
                    'Registro CACEI',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usa tu correo institucional para crear una cuenta vinculada al backend de CACEI.',
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
                      'Los alumnos se importan desde el panel del Director en CACEI.',
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
                        : () => Navigator.pushReplacementNamed(
                            context,
                            AppScreen.login.route,
                          ),
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

    final nombre = _nameController.text.trim();
    final apellidos = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final telefono = _phoneController.text.trim();

    if (nombre.isEmpty ||
        apellidos.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      setState(
        () => _localError =
            'Por favor, completa todos los campos obligatorios para continuar.',
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(
        () => _localError = 'El formato del correo electrónico no es válido.',
      );
      return;
    }

    if (password.length < 6) {
      setState(
        () => _localError =
            'La contraseña debe tener al menos 6 caracteres por seguridad.',
      );
      return;
    }

    if (password != confirmPassword) {
      setState(
        () => _localError =
            'Las contraseñas no coinciden. Por favor, verifícalas.',
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      email: email,
      password: password,
      nombre: nombre,
      apellidos: apellidos,
      role: _role,
      telefono: telefono,
    );

    if (!mounted || !ok) return;
    if (auth.emailConfirmationPending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.statusMessage ??
                'Revisa tu correo para confirmar el acceso y volver a la app.',
          ),
        ),
      );
      Navigator.pushReplacementNamed(context, AppScreen.login.route);
      return;
    }
    Navigator.pushReplacementNamed(context, AppScreen.segmentation.route);
  }
}
