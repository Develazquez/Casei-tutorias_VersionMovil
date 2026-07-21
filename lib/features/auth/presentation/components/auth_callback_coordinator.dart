import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../../../../navigation/app_navigator.dart';
import '../../../../navigation/app_screen.dart';
import '../providers/auth_provider.dart';

class AuthCallbackCoordinator extends StatefulWidget {
  const AuthCallbackCoordinator({required this.child, super.key});

  final Widget child;

  @override
  State<AuthCallbackCoordinator> createState() =>
      _AuthCallbackCoordinatorState();
}

class _AuthCallbackCoordinatorState extends State<AuthCallbackCoordinator> {
  AuthProvider? _authProvider;
  bool _navigationScheduled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = context.read<AuthProvider>();
    if (identical(provider, _authProvider)) return;
    _authProvider?.removeListener(_handleAuthChange);
    _authProvider = provider..addListener(_handleAuthChange);
  }

  void _handleAuthChange() {
    final provider = _authProvider;
    if (provider == null ||
        _navigationScheduled ||
        !provider.consumeAuthCallbackCompletion()) {
      return;
    }

    _navigationScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigationScheduled = false;
      AppNavigator.key.currentState?.pushNamedAndRemoveUntil(
        AppScreen.segmentation.route,
        (_) => false,
      );
    });
  }

  @override
  void dispose() {
    _authProvider?.removeListener(_handleAuthChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
