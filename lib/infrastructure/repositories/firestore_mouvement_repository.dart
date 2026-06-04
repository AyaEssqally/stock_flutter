import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../core/errors/failure.dart';
import '../../core/tenant/tenant_context.dart';
import '../../domain/entities/mouvement.dart';
import '../../domain/repositories/mouvement_repository.dart';
import '../firebase/firebase_bootstrap.dart';

class FirestoreMouvementRepository implements MouvementRepository {
  FirebaseFirestore? get _db =>
      FirebaseBootstrap.initialized ? FirebaseFirestore.instance : null;

  CollectionReference<Map<String, dynamic>>? _col(String tenantId) {
    if (_db == null) return null;
    return _db!.collection(TenantContext(tenantId: tenantId).mouvementsPath());
  }

  @override
  Stream<List<Mouvement>> watchAll(String tenantId) {
    final col = _col(tenantId);
    if (col == null) return Stream.value([]);
    return col.orderBy('date', descending: true).snapshots().map(
          (s) => s.docs
              .map((d) => Mouvement.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Stream<List<Mouvement>> watchByDateRange(
    String tenantId, {
    required DateTime start,
    required DateTime end,
  }) {
    final col = _col(tenantId);
    if (col == null) return Stream.value([]);
    return col
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (s) => s.docs
              .map((d) => Mouvement.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<Mouvement> create(String tenantId, Mouvement mouvement) async {
    final col = _col(tenantId);
    if (col == null) throw const FirebaseNotConfiguredFailure();
    final id = mouvement.id.isEmpty ? const Uuid().v4() : mouvement.id;
    final m = Mouvement(
      id: id,
      productId: mouvement.productId,
      type: mouvement.type,
      quantity: mouvement.quantity,
      date: mouvement.date,
      note: mouvement.note,
      categoryId: mouvement.categoryId,
      unitPrice: mouvement.unitPrice,
    );
    await col.doc(id).set(m.toMap());
    return m;
  }
}
