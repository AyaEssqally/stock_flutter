import '../entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchAll(String tenantId);
  Future<Category> create(String tenantId, String name);
  Future<Category?> findByName(String tenantId, String name);
}
