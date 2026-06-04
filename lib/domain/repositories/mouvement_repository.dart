import '../entities/mouvement.dart';

abstract class MouvementRepository {
  Stream<List<Mouvement>> watchAll(String tenantId);
  Stream<List<Mouvement>> watchByDateRange(
    String tenantId, {
    required DateTime start,
    required DateTime end,
  });
  Future<Mouvement> create(String tenantId, Mouvement mouvement);
}
