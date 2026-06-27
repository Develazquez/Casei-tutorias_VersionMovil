import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../firebase_options.dart';
import 'secure_storage_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await _ensureFirebaseInitialized();
    if (message.data['action'] == 'remote_wipe') {
      await SecureStorageService().clearSessionData();
    }
  } catch (_) {
    return;
  }
}

class FirebaseMessagingService {
  FirebaseMessagingService(this._secureStorage);

  final SecureStorageService _secureStorage;
  bool _initialized = false;

  Future<void> initialize() async {
    try {
      await _ensureFirebaseInitialized();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      await FirebaseMessaging.instance.requestPermission();
      _initialized = true;
      await registerCurrentDevice();
      FirebaseMessaging.instance.onTokenRefresh.listen(_saveToken);
      FirebaseMessaging.onMessage.listen(_handleMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    } catch (error) {
      debugPrint('FCM no inicializado: $error');
    }
  }

  Future<void> registerCurrentDevice() async {
    if (!_initialized) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.isEmpty) return;
      await _saveToken(token);
    } catch (error) {
      debugPrint('No fue posible obtener el FCM token: $error');
    }
  }

  Future<void> _saveToken(String token) async {
    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;
      if (user == null) return;

      await client.from('user_devices').upsert({
        'user_id': user.id,
        'fcm_token': token,
        'platform': defaultTargetPlatform.name,
        'last_seen_at': DateTime.now().toUtc().toIso8601String(),
        'revoked_at': null,
      }, onConflict: 'fcm_token');
    } catch (error) {
      debugPrint('No fue posible registrar el dispositivo en Supabase: $error');
    }
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    if (message.data['action'] == 'remote_wipe') {
      await _secureStorage.clearSessionData();
      try {
        await Supabase.instance.client.auth.signOut();
      } catch (_) {
        return;
      }
    }
  }
}

Future<void> _ensureFirebaseInitialized() async {
  if (Firebase.apps.isNotEmpty) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
