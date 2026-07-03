class AppConstants {
  const AppConstants._();

  static const String appName = 'CASEI Tutorías';
  static const String apiBaseUrl = 'http://localhost:8000/api/v1';
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://msgqdkhjdpidwbhwnhgr.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1zZ3Fka2hqZHBpZHdiaHduaGdyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzkxNTkxMDcsImV4cCI6MjA5NDczNTEwN30.LGYFlUNfavCKqOYef3fEojUe0Njdhw9a73y3hNBCeAE',
  );
  static const bool enableScreenCaptureProtection = bool.fromEnvironment(
    'ENABLE_SCREEN_CAPTURE_PROTECTION',
    defaultValue: true,
  );
  static const bool enableFakeGpsGuard = bool.fromEnvironment(
    'ENABLE_FAKE_GPS_GUARD',
    defaultValue: true,
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
  static const String segmentationStorageBucket = String.fromEnvironment(
    'SEGMENTATION_STORAGE_BUCKET',
    defaultValue: 'academic-segmentation',
  );
  static const String segmentationStoragePrefix = String.fromEnvironment(
    'SEGMENTATION_STORAGE_PREFIX',
    defaultValue: 'latest',
  );
}
