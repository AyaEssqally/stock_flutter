/// Contexte multi-tenant : chaque utilisateur authentifié = un tenant (son UID).
class TenantContext {
  const TenantContext({required this.tenantId});
  final String tenantId;

  String productsPath() => 'tenants/$tenantId/products';
  String categoriesPath() => 'tenants/$tenantId/categories';
  String mouvementsPath() => 'tenants/$tenantId/mouvements';
}
