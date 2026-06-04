import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/product.dart';

class ProductsScreen extends ConsumerWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (products) {
        final list = products.cast<Product>();
        final categories =
            (categoriesAsync.valueOrNull ?? []).cast<Category>();
        final catMap = {for (final c in categories) c.id: c.name};

        return Scaffold(
          body: list.isEmpty
              ? const Center(child: Text('Aucun produit — ajoutez-en un'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final p = list[i];
                    final catName = catMap[p.categoryId] ?? p.categoryId;
                    return ListTile(
                      leading: Icon(
                        p.isLowStock ? Icons.warning_amber : Icons.inventory,
                        color: p.isLowStock ? Colors.orange : null,
                      ),
                      title: Text(p.name),
                      subtitle: Text(
                        '$catName · Stock: ${p.quantity} · Seuil: ${p.reorderThreshold}',
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) => _handleAction(context, ref, p, v),
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'entree', child: Text('Réappro')),
                          PopupMenuItem(value: 'vente', child: Text('Vente')),
                        ],
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddDialog(context, ref, categories),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    Product p,
    String action,
  ) async {
    final qtyCtrl = TextEditingController(text: '1');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(action == 'entree' ? 'Réapprovisionnement' : 'Vente'),
        content: TextField(
          controller: qtyCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Quantité'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('OK')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final qty = int.tryParse(qtyCtrl.text) ?? 0;
    final tenantId = ref.read(tenantIdProvider);
    if (tenantId == null) return;
    final service = ref.read(stockServiceProvider);
    try {
      if (action == 'entree') {
        await service.stockEntry(
          tenantId: tenantId,
          productId: p.id,
          quantity: qty,
        );
      } else {
        await service.recordSale(
          tenantId: tenantId,
          productId: p.id,
          quantity: qty,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _showAddDialog(
    BuildContext context,
    WidgetRef ref,
    List<Category> categories,
  ) async {
    final nameCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    final qtyCtrl = TextEditingController(text: '0');
    final seuilCtrl = TextEditingController(text: '5');
    final priceCtrl = TextEditingController(text: '0');

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouveau produit'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom produit'),
              ),
              TextField(
                controller: catCtrl,
                decoration: InputDecoration(
                  labelText: 'Catégorie',
                  hintText: categories.isNotEmpty
                      ? 'ex: ${categories.first.name}'
                      : 'Nouvelle catégorie créée si absente',
                ),
              ),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock initial'),
              ),
              TextField(
                controller: seuilCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Seuil réappro'),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Prix unitaire'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Ajouter')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final tenantId = ref.read(tenantIdProvider);
    if (tenantId == null) return;
    try {
      await ref.read(stockServiceProvider).addProduct(
            tenantId: tenantId,
            name: nameCtrl.text,
            categoryName: catCtrl.text.isEmpty ? 'Général' : catCtrl.text,
            initialQuantity: int.tryParse(qtyCtrl.text) ?? 0,
            reorderThreshold: int.tryParse(seuilCtrl.text) ?? 5,
            unitPrice: double.tryParse(priceCtrl.text) ?? 0,
          );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
