import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failure.dart';
import '../../core/tenant/tenant_context.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../firebase/firebase_bootstrap.dart';

class FirestoreProductRepository implements ProductRepository {
  FirebaseFirestore? get _db =>
      FirebaseBootstrap.initialized ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? _col(String tenantId) {
    if (_db == null) return null;
    return _db!.collection(TenantContext(tenantId: tenantId).productsPath());
  }

  @override
  Stream<List<Product>> watchAll(String tenantId) {
    final col = _col(tenantId);
    if (col == null) return Stream.value([]);
    return col.orderBy('name').snapshots().map(
          (s) => s.docs
              .map((d) => Product.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Stream<List<Product>> watchLowStock(String tenantId) {
    return watchAll(tenantId).map(
      (list) => list.where((p) => p.isLowStock).toList(),
    );
  }

  @override
  Future<Product> create(Product product, String tenantId) async {
    final col = _col(tenantId);
    if (col == null) throw const FirebaseNotConfiguredFailure();
    final id = product.id.isEmpty ? const Uuid().v4() : product.id;
    final p = product.copyWith(id: id, createdAt: DateTime.now());
    await col.doc(id).set(p.toMap());
    return p;
  }

  @override
  Future<void> updateQuantity(
    String tenantId,
    String productId,
    int newQty,
  ) async {
    final col = _col(tenantId);
    if (col == null) throw const FirebaseNotConfiguredFailure();
    await col.doc(productId).update({'quantity': newQty});
  }

  @override
  Future<Product?> getById(String tenantId, String productId) async {
    final col = _col(tenantId);
    if (col == null) return null;
    final doc = await col.doc(productId).get();
    if (!doc.exists) return null;
    return Product.fromMap(doc.id, doc.data()!);
  }
}
