import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'tenant_entity.dart';

/// Provides the current tenant context for the authenticated user.
///
/// After a successful login, call [loadTenant] to fetch the tenant record
/// from Supabase based on the `tenant_id` claim in the user's `app_metadata`.
class TenantProvider extends ChangeNotifier {
  TenantEntity? _tenant;
  bool _loading = false;
  String? _error;

  TenantEntity? get tenant => _tenant;
  bool get loading => _loading;
  String? get error => _error;
  String? get tenantId => _tenant?.id;

  /// Loads the tenant for the currently authenticated user.
  ///
  /// Reads `app_metadata.tenant_id` from the Supabase user and fetches the
  /// corresponding row from the `tenants` table.
  Future<void> loadTenant(supabase.SupabaseClient client) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final user = client.auth.currentUser;
      if (user == null) {
        _tenant = null;
        _loading = false;
        notifyListeners();
        return;
      }

      final appMetadata = user.appMetadata;
      final tenantId = appMetadata?['tenant_id'] as String?;

      if (tenantId == null || tenantId.isEmpty) {
        _error = 'El usuario no tiene un tenant asignado.';
        _tenant = null;
        _loading = false;
        notifyListeners();
        return;
      }

      final response = await client
          .from('tenants')
          .select('id, slug, nombre, logo_url, dominio_email, config')
          .eq('id', tenantId)
          .single();

      _tenant = TenantEntity.fromJson(response);
      _error = null;
    } catch (e) {
      debugPrint('TenantProvider.loadTenant error: $e');
      _error = 'No fue posible cargar la información del tenant.';
      _tenant = null;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Clears the tenant state (call on logout).
  void clear() {
    _tenant = null;
    _error = null;
    _loading = false;
    notifyListeners();
  }
}
