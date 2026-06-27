import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/providers/auth_provider.dart';
import '../navigation/app_navigator.dart';
import 'secure_storage_service.dart';

class SessionGuard extends StatefulWidget {
  const SessionGuard({
    required this.child,
    required this.secureStorage,
    this.timeout = const Duration(minutes: 10),
    super.key,
  });

  final Widget child;
  final SecureStorageService secureStorage;
  final Duration timeout;

  @override
  State<SessionGuard> createState() => _SessionGuardState();
}

class _SessionGuardState extends State<SessionGuard> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthProvider, bool>(
      (auth) => auth.isAuthenticated,
    );
    if (isAuthenticated && (_timer == null || !_timer!.isActive)) {
      _resetTimer();
    }
    if (!isAuthenticated) {
      _timer?.cancel();
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _resetTimer(),
      onPointerMove: (_) => _resetTimer(),
      onPointerUp: (_) => _resetTimer(),
      child: widget.child,
    );
  }

  void _resetTimer() {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;
    _timer?.cancel();
    _timer = Timer(widget.timeout, _expireSession);
  }

  Future<void> _expireSession() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isAuthenticated) return;
    await widget.secureStorage.writeSessionValue(
      'last_inactivity_at',
      DateTime.now().toIso8601String(),
    );
    await auth.logout();
    AppNavigator.key.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (_) => false,
    );
  }
}
