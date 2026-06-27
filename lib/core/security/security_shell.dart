import 'package:flutter/material.dart';

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
    return UsbDebugGuard(
      child: FakeGpsGuard(
        child: SessionGuard(secureStorage: secureStorage, child: child),
      ),
    );
  }
}
