import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../domain/entities/category.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(categoriesStreamProvider);

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (items) {
        final list = items.cast<Category>();
        return Scaffold(
          body: list.isEmpty
              ? const Center(child: Text('Aucune catégorie'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final c = list[i];
                    return ListTile(
                      leading: const Icon(Icons.label),
                      title: Text(c.name),
                      subtitle: Text('ID: ${c.id}'),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _addCategory(context, ref),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<void> _addCategory(BuildContext context, WidgetRef ref) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nouvelle catégorie'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nom'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Créer')),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final tenantId = ref.read(tenantIdProvider);
    if (tenantId == null) return;
    try {
      await ref.read(categoryRepositoryProvider).create(tenantId, ctrl.text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}
