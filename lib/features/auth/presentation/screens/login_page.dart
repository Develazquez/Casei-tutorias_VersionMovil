import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/security/screen_capture_protection_service.dart';
import '../../../../core/theme/cacei_ui_colors.dart';
import '../../../../core/util/view_state.dart';
import '../../../../navigation/app_screen.dart';
import '../components/auth_text_field.dart';
import '../viewmodels/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
    return Scaffold(
      backgroundColor: CaceiUiColors.background,
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
                      const Icon(
                        Icons.school_outlined,
                        size: 64,
                        color: CaceiUiColors.primary,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'CACEI - Tutorías',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: CaceiUiColors.titleText,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Dashboard de segmentación académica',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: CaceiUiColors.secondaryText,
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
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 48,
                        child: FilledButton.icon(
                          onPressed: auth.state == ViewState.loading
                              ? null
                              : () async {
                                  final ok = await context
                                      .read<AuthProvider>()
                                      .login(
                                        email: _emailController.text,
                                        password: _passwordController.text,
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
                            backgroundColor: CaceiUiColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: auth.state == ViewState.loading
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
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
                        child: const Text(
                          'Crear cuenta institucional',
                          style: TextStyle(color: CaceiUiColors.primary),
                        ),
                      ),
                      if (auth.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            auth.errorMessage!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
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
