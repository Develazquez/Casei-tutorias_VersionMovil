import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'fake_gps_guard.dart';
import 'secure_storage_service.dart';
import 'session_guard.dart';
import 'usb_debug_guard.dart';

class SecurityShell extends StatelessWidget {
  const SecurityShell({
    required this.child,
    required this.secureStorage,
    super.key,
  });

  final Widget child;
  final SecureStorageService secureStorage;

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = context.select<AuthProvider, bool>(
      (auth) => auth.isAuthenticated,
    );
    final fakeGpsGuardEnabled =
        isAuthenticated && AppConstants.enableFakeGpsGuard;
    final raspGuardEnabled = isAuthenticated && AppConstants.enableRaspGuard;
    final inactivityTimeoutEnabled =
        isAuthenticated && AppConstants.enableInactivitySessionTimeout;

    return UsbDebugGuard(
      enabled: raspGuardEnabled,
      child: FakeGpsGuard(
        enabled: fakeGpsGuardEnabled,
        child: SessionGuard(
          enabled: inactivityTimeoutEnabled,
          secureStorage: secureStorage,
          child: child,
        ),
      ),
    );
  }
}
