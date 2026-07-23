import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class TutorSupabaseDataSource {
  const TutorSupabaseDataSource(this._client);
  final supabase.SupabaseClient _client;

  Future<List<String>> getTutorGroupIds(String userId) async {
    try {
      final response = await _client
          .from('grupos')
          .select('id')
          .eq('tutor_id', userId);

      return (response as List).map((g) => g['id'].toString()).toList();
    } catch (_) {
      return [];
    }
  }

  Future<int> getTutorStudentScopeCount(String userId) async {
    try {
      final response = await _client
          .from('tutor_student_scope')
          .select('id')
          .eq('tutor_id', userId)
          .eq('active', true);

      return (response as List).length;
    } catch (_) {
      // La tabla podría no existir en algunas instalaciones aún
      return 0;
    }
  }

  Future<int> getCargaAcademicaCount(List<String> groupIds) async {
    if (groupIds.isEmpty) return 0;

    try {
      final response = await _client
          .from('carga_academica')
          .select('id')
          .inFilter('grupo_id', groupIds);

      return (response as List).length;
    } catch (_) {
      return 0;
    }
  }
}
