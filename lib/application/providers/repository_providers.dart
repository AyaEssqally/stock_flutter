import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/mouvement_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../../infrastructure/repositories/firebase_auth_repository.dart';
import '../../infrastructure/repositories/firestore_category_repository.dart';
import '../../infrastructure/repositories/firestore_mouvement_repository.dart';
import '../../infrastructure/repositories/firestore_product_repository.dart';
import '../services/stock_service.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => FirestoreCategoryRepository(),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => FirestoreProductRepository(),
);

final mouvementRepositoryProvider = Provider<MouvementRepository>(
  (ref) => FirestoreMouvementRepository(),
);

final stockServiceProvider = Provider<StockService>((ref) {
  return StockService(
    products: ref.watch(productRepositoryProvider),
    categories: ref.watch(categoryRepositoryProvider),
    mouvements: ref.watch(mouvementRepositoryProvider),
  );
});

final authStateProvider = StreamProvider<String?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final tenantIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

final categoriesStreamProvider = StreamProvider((ref) {
  final tenantId = ref.watch(tenantIdProvider);
  if (tenantId == null) return Stream.value(<dynamic>[]);
  return ref.watch(categoryRepositoryProvider).watchAll(tenantId);
});

final productsStreamProvider = StreamProvider((ref) {
  final tenantId = ref.watch(tenantIdProvider);
  if (tenantId == null) return Stream.value(<dynamic>[]);
  return ref.watch(productRepositoryProvider).watchAll(tenantId);
});

final lowStockStreamProvider = StreamProvider((ref) {
  final tenantId = ref.watch(tenantIdProvider);
  if (tenantId == null) return Stream.value(<dynamic>[]);
  return ref.watch(productRepositoryProvider).watchLowStock(tenantId);
});

final mouvementsStreamProvider = StreamProvider((ref) {
  final tenantId = ref.watch(tenantIdProvider);
  if (tenantId == null) return Stream.value(<dynamic>[]);
  return ref.watch(mouvementRepositoryProvider).watchAll(tenantId);
});
