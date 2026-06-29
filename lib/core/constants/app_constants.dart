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
  static const bool enableRuntimeSecurityGuards = bool.fromEnvironment(
    'ENABLE_RUNTIME_SECURITY_GUARDS',
    defaultValue: true,
  );
}
