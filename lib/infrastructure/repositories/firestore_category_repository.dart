import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failure.dart';
import '../../core/tenant/tenant_context.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../firebase/firebase_bootstrap.dart';

class FirestoreCategoryRepository implements CategoryRepository {
  FirebaseFirestore? get _db =>
      FirebaseBootstrap.initialized ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? _col(String tenantId) {
    if (_db == null) return null;
    return _db!.collection(TenantContext(tenantId: tenantId).categoriesPath());
  }

  @override
  Stream<List<Category>> watchAll(String tenantId) {
    final col = _col(tenantId);
    if (col == null) return Stream.value([]);
    return col.orderBy('name').snapshots().map(
          (s) => s.docs
              .map((d) => Category.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<Category> create(String tenantId, String name) async {
    final col = _col(tenantId);
    if (col == null) throw const FirebaseNotConfiguredFailure();
    final id = const Uuid().v4();
    final cat = Category(
      id: id,
      name: name.trim(),
      createdAt: DateTime.now(),
    );
    await col.doc(id).set(cat.toMap());
    return cat;
  }

  @override
  Future<Category?> findByName(String tenantId, String name) async {
    final col = _col(tenantId);
    if (col == null) return null;
    final q = await col
        .where('name', isEqualTo: name.trim())
        .limit(1)
        .get();
    if (q.docs.isEmpty) return null;
    final d = q.docs.first;
    return Category.fromMap(d.id, d.data());
  }
}
