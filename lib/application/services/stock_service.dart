import '../../domain/entities/mouvement.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/repositories/mouvement_repository.dart';
import '../../domain/repositories/product_repository.dart';

class StockService {
  StockService({
    required ProductRepository products,
    required CategoryRepository categories,
    required MouvementRepository mouvements,
  })  : _products = products,
        _categories = categories,
        _mouvements = mouvements;

  final ProductRepository _products;
  final CategoryRepository _categories;
  final MouvementRepository _mouvements;

  /// Ajoute un produit ; crée la catégorie si elle n'existe pas.
  Future<Product> addProduct({
    required String tenantId,
    required String name,
    required String categoryName,
    required int initialQuantity,
    required int reorderThreshold,
    double unitPrice = 0,
  }) async {
    var category = await _categories.findByName(tenantId, categoryName);
    category ??= await _categories.create(tenantId, categoryName);

    return _products.create(
      Product(
        id: '',
        name: name.trim(),
        categoryId: category.id,
        quantity: initialQuantity,
        reorderThreshold: reorderThreshold,
        unitPrice: unitPrice,
      ),
      tenantId,
    );
  }

  Future<void> stockEntry({
    required String tenantId,
    required String productId,
    required int quantity,
    String? note,
  }) async {
    final product = await _products.getById(tenantId, productId);
    if (product == null) throw Exception('Produit introuvable');
    final newQty = product.quantity + quantity;
    await _products.updateQuantity(tenantId, productId, newQty);
    await _mouvements.create(
      tenantId,
      Mouvement(
        id: '',
        productId: productId,
        type: MouvementType.entree,
        quantity: quantity,
        date: DateTime.now(),
        note: note,
        categoryId: product.categoryId,
      ),
    );
  }

  Future<void> recordSale({
    required String tenantId,
    required String productId,
    required int quantity,
    String? note,
  }) async {
    final product = await _products.getById(tenantId, productId);
    if (product == null) throw Exception('Produit introuvable');
    if (product.quantity < quantity) {
      throw Exception('Stock insuffisant (${product.quantity} disponible)');
    }
    final newQty = product.quantity - quantity;
    await _products.updateQuantity(tenantId, productId, newQty);
    await _mouvements.create(
      tenantId,
      Mouvement(
        id: '',
        productId: productId,
        type: MouvementType.sortie,
        quantity: quantity,
        date: DateTime.now(),
        note: note,
        categoryId: product.categoryId,
        unitPrice: product.unitPrice,
      ),
    );
  }
}
