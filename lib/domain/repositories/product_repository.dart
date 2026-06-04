import '../entities/product.dart';

abstract class ProductRepository {
  Stream<List<Product>> watchAll(String tenantId);
  Stream<List<Product>> watchLowStock(String tenantId);
  Future<Product> create(Product product, String tenantId);
  Future<void> updateQuantity(String tenantId, String productId, int newQty);
  Future<Product?> getById(String tenantId, String productId);
}
