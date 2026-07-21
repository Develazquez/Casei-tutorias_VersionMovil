class AppConstants {
  const AppConstants._();

  static const String appName = 'CACEI Tutorías';
  
  static const String _envApiBaseUrl = String.fromEnvironment(
    'ACADEMIC_SEGMENTATION_API_URL',
    defaultValue: 'http://127.0.0.1:8000',
  );
  
  static const String apiBaseUrl = '$_envApiBaseUrl/api/v1';

  static const String segmentationApiUrl = '$apiBaseUrl/cacei/segmentation';

  static const String _expoSupabaseUrl = String.fromEnvironment(
    'EXPO_PUBLIC_SUPABASE_URL',
  );
  static const String _flutterSupabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
  );
  static const String supabaseUrl = _expoSupabaseUrl == ''
      ? _flutterSupabaseUrl
      : _expoSupabaseUrl;

  static const String _expoSupabaseAnonKey = String.fromEnvironment(
    'EXPO_PUBLIC_SUPABASE_ANON_KEY',
  );
  static const String _flutterSupabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );
  static const String supabaseAnonKey = _expoSupabaseAnonKey == ''
      ? _flutterSupabaseAnonKey
      : _expoSupabaseAnonKey;

  static const String authEmailRedirectUrl = String.fromEnvironment(
    'AUTH_EMAIL_REDIRECT_URL',
    defaultValue: 'com.casei://callback/auth',
  );

  static const bool enableScreenCaptureProtection = bool.fromEnvironment(
    'ENABLE_SCREEN_CAPTURE_PROTECTION',
    defaultValue: true,
  );
  static const bool enableFakeGpsGuard = bool.fromEnvironment(
    'ENABLE_FAKE_GPS_GUARD',
    defaultValue: false,
  );
  static const bool enableInactivitySessionTimeout = bool.fromEnvironment(
    'ENABLE_INACTIVITY_SESSION_TIMEOUT',
    defaultValue: true,
  );
  static const bool enableEncryptedSecureStorage = bool.fromEnvironment(
    'ENABLE_ENCRYPTED_SECURE_STORAGE',
    defaultValue: true,
  );
  static const bool enableSecureVault = bool.fromEnvironment(
    'ENABLE_SECURE_VAULT',
    defaultValue: true,
  );
  static const bool enableRemoteWipe = bool.fromEnvironment(
    'ENABLE_REMOTE_WIPE',
    defaultValue: true,
  );
  static const bool enableRaspGuard = bool.fromEnvironment(
    'ENABLE_RASP_GUARD',
    defaultValue: true,
  );
  static const String _expoSegmentationStorageBucket = String.fromEnvironment(
    'EXPO_PUBLIC_SEGMENTATION_STORAGE_BUCKET',
  );
  static const String _flutterSegmentationStorageBucket =
      String.fromEnvironment('SEGMENTATION_STORAGE_BUCKET');
  static const String segmentationStorageBucket =
      _expoSegmentationStorageBucket == ''
      ? (_flutterSegmentationStorageBucket == ''
            ? 'academic-segmentation'
            : _flutterSegmentationStorageBucket)
      : _expoSegmentationStorageBucket;

  static const String _expoSegmentationStoragePrefix = String.fromEnvironment(
    'EXPO_PUBLIC_SEGMENTATION_STORAGE_PREFIX',
  );
  static const String _flutterSegmentationStoragePrefix =
      String.fromEnvironment('SEGMENTATION_STORAGE_PREFIX');
  static const String segmentationStoragePrefix =
      _expoSegmentationStoragePrefix == ''
      ? (_flutterSegmentationStoragePrefix == ''
            ? ''
            : _flutterSegmentationStoragePrefix)
      : _expoSegmentationStoragePrefix;

  static List<String> missingRuntimeConfiguration() {
    final missing = <String>[];
    if (supabaseUrl.trim().isEmpty) {
      missing.add('EXPO_PUBLIC_SUPABASE_URL o SUPABASE_URL');
    }
    if (supabaseAnonKey.trim().isEmpty) {
      missing.add('EXPO_PUBLIC_SUPABASE_ANON_KEY o SUPABASE_ANON_KEY');
    }
    return missing;
  }
}
