import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../application/services/dashboard_service.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/mouvement.dart';
import '../../../domain/entities/product.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  DateTime _start = DateTime.now().subtract(const Duration(days: 30));
  DateTime _end = DateTime.now();

  Future<void> _pickRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(start: _start, end: _end),
    );
    if (range != null) {
      setState(() {
        _start = range.start;
        _end = range.end.add(const Duration(hours: 23, minutes: 59));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsStreamProvider);
    final mouvementsAsync = ref.watch(mouvementsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final fmt = DateFormat('dd/MM/yyyy');

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (productsRaw) {
        final products = productsRaw.cast<Product>();
        final mouvements =
            (mouvementsAsync.valueOrNull ?? []).cast<Mouvement>();
        final categories =
            (categoriesAsync.valueOrNull ?? []).cast<Category>();
        final catNames = {for (final c in categories) c.id: c.name};

        final stats = DashboardService.compute(
          products: products,
          mouvements: mouvements,
          categoryNamesById: catNames,
          start: _start,
          end: _end,
        );

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Période : ${fmt.format(_start)} → ${fmt.format(_end)}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: _pickRange,
                    icon: const Icon(Icons.date_range),
                    tooltip: 'Changer la plage de dates',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _StatCard(
                title: 'Stock total (unités)',
                value: '${stats.totalStockUnits}',
                icon: Icons.inventory,
              ),
              _StatCard(
                title: 'Ventes (période)',
                value: '${stats.salesCount}',
                icon: Icons.shopping_cart,
              ),
              _StatCard(
                title: 'Chiffre estimé',
                value: '${stats.salesRevenue.toStringAsFixed(2)} MAD',
                icon: Icons.euro,
              ),
              const SizedBox(height: 24),
              Text(
                'Top ventes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (stats.topProducts.isEmpty)
                const Text('Aucune vente sur la période')
              else
                ...stats.topProducts.map(
                  (t) => ListTile(
                    dense: true,
                    title: Text(t.productName),
                    trailing: Text('${t.quantitySold} u.'),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Ventes par catégorie',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (stats.salesByCategory.isEmpty)
                const Text('—')
              else
                ...stats.salesByCategory.entries.map(
                  (e) => ListTile(
                    dense: true,
                    title: Text(e.key),
                    trailing: Text('${e.value} u.'),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
