import '../../domain/entities/mouvement.dart';
import '../../domain/entities/product.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalStockUnits,
    required this.salesCount,
    required this.salesRevenue,
    required this.topProducts,
    required this.salesByCategory,
  });

  final int totalStockUnits;
  final int salesCount;
  final double salesRevenue;
  final List<TopProductSale> topProducts;
  final Map<String, int> salesByCategory;
}

class TopProductSale {
  const TopProductSale({
    required this.productId,
    required this.productName,
    required this.quantitySold,
  });

  final String productId;
  final String productName;
  final int quantitySold;
}

class DashboardService {
  static DashboardStats compute({
    required List<Product> products,
    required List<Mouvement> mouvements,
    required Map<String, String> categoryNamesById,
    required DateTime start,
    required DateTime end,
  }) {
    final inRange = mouvements.where((m) {
      return !m.date.isBefore(start) && !m.date.isAfter(end);
    }).toList();

    final sales = inRange.where((m) => m.isSale).toList();
    final productNames = {for (final p in products) p.id: p.name};

    final topMap = <String, int>{};
    var revenue = 0.0;
    for (final s in sales) {
      topMap[s.productId] = (topMap[s.productId] ?? 0) + s.quantity;
      revenue += s.quantity * (s.unitPrice ?? 0);
    }

    final topProducts = topMap.entries
        .map(
          (e) => TopProductSale(
            productId: e.key,
            productName: productNames[e.key] ?? e.key,
            quantitySold: e.value,
          ),
        )
        .toList()
      ..sort((a, b) => b.quantitySold.compareTo(a.quantitySold));

    final byCategory = <String, int>{};
    for (final s in sales) {
      final catId = s.categoryId ?? 'unknown';
      final label = categoryNamesById[catId] ?? catId;
      byCategory[label] = (byCategory[label] ?? 0) + s.quantity;
    }

    return DashboardStats(
      totalStockUnits: products.fold(0, (sum, p) => sum + p.quantity),
      salesCount: sales.length,
      salesRevenue: revenue,
      topProducts: topProducts.take(5).toList(),
      salesByCategory: byCategory,
    );
  }
}
