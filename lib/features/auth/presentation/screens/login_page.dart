import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/screen_capture_protection_service.dart';
import '../../../../core/theme/theme_casei_material3.dart';
import '../../../../core/util/view_state.dart';
import '../../../../navigation/app_screen.dart';
import '../components/auth_text_field.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _localError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _applyScreenCaptureProtection(enabled: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _applyScreenCaptureProtection(enabled: false);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _applyScreenCaptureProtection(enabled: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final appColors = theme.extension<AppThemeColors>()!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 460,
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'CACEI - Tutorías',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dashboard de segmentación académica',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: appColors.mutedText,
                        ),
                      ),
                      const SizedBox(height: 32),
                      AuthTextField(
                        controller: _emailController,
                        label: 'Correo institucional',
                        hint: 'usuario@upchiapas.edu.mx',
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      AuthTextField(
                        controller: _passwordController,
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: auth.state == ViewState.loading
                              ? null
                              : () async {
                                  final email = _emailController.text.trim();
                                  final password = _passwordController.text;

                                  if (email.isEmpty || password.isEmpty) {
                                    setState(() => _localError = 'Por favor, ingresa tu correo y contraseña institucional.');
                                    return;
                                  }

                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                                    setState(() => _localError = 'El formato del correo electrónico no es válido.');
                                    return;
                                  }

                                  setState(() => _localError = null);

                                  final ok = await context
                                      .read<AuthProvider>()
                                      .login(
                                        email: email,
                                        password: password,
                                      );
                                  if (!mounted || !ok) return;
                                  await Future<void>.delayed(Duration.zero);
                                  if (!mounted) return;
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppScreen.segmentation.route,
                                  );
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: auth.state == ViewState.loading
                              ? SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: const Text('Entrar'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: auth.state == ViewState.loading
                            ? null
                            : () => Navigator.pushNamed(
                                context,
                                AppScreen.register.route,
                              ),
                        child: Text(
                          'Crear cuenta institucional',
                          style: TextStyle(color: theme.colorScheme.primary),
                        ),
                      ),
                      if (_localError != null || auth.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _localError ?? auth.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onErrorContainer,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _applyScreenCaptureProtection({required bool enabled}) {
    if (!AppConstants.enableScreenCaptureProtection) return;
    unawaited(ScreenCaptureProtectionService.apply(enabled: enabled));
  }
}
