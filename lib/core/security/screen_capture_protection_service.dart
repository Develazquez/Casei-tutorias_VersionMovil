import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ScreenCaptureProtectionService {
  const ScreenCaptureProtectionService._();

  static const _channel = MethodChannel(
    'mx.edu.upchiapas.casei_tutorias/security',
  );

  static Future<void> apply({required bool enabled}) async {
    if (defaultTargetPlatform != TargetPlatform.android) return;

    try {
      await _channel
          .invokeMethod<void>('setScreenCaptureProtection', {
            'enabled': enabled,
          })
          .timeout(const Duration(seconds: 3));
    } on PlatformException catch (error) {
      debugPrint('No fue posible configurar FLAG_SECURE: $error');
    } catch (error) {
      debugPrint('No fue posible configurar FLAG_SECURE: $error');
    }
  }
}
