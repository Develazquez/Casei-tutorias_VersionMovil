import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/common_components/app_loading_indicator.dart';
import '../../../../core/util/view_state.dart';
import '../../../../navigation/app_screen.dart';
import '../viewmodels/auth_provider.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  Future<void> _check() async {
    final auth = context.read<AuthProvider>();
    await auth.restoreSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      auth.isAuthenticated
          ? AppScreen.segmentation.route
          : AppScreen.login.route,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthProvider>().state;
    return Scaffold(
      body: Center(
        child: state == ViewState.loading
            ? const AppLoadingIndicator()
            : const Text('Preparando CACEI Tutorías...'),
      ),
    );
  }
}
