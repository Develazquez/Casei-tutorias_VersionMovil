/// Represents a tenant (institution/campus) in the multi-tenant architecture.
class TenantEntity {
  const TenantEntity({
    required this.id,
    required this.slug,
    required this.nombre,
    this.logoUrl,
    this.dominioEmail,
    this.config = const {},
  });

  final String id;
  final String slug;
  final String nombre;
  final String? logoUrl;
  final String? dominioEmail;
  final Map<String, dynamic> config;

  factory TenantEntity.fromJson(Map<String, dynamic> json) {
    return TenantEntity(
      id: json['id'] as String,
      slug: json['slug'] as String,
      nombre: json['nombre'] as String,
      logoUrl: json['logo_url'] as String?,
      dominioEmail: json['dominio_email'] as String?,
      config: json['config'] is Map<String, dynamic>
          ? json['config'] as Map<String, dynamic>
          : const {},
    );
  }
}
