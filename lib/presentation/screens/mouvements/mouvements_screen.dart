import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/repository_providers.dart';
import '../../../domain/entities/mouvement.dart';

class MouvementsScreen extends ConsumerWidget {
  const MouvementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(mouvementsStreamProvider);
    final fmt = DateFormat('dd/MM/yyyy HH:mm');

    return async.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (items) {
        final list = items.cast<Mouvement>();
        return Scaffold(
          body: list.isEmpty
              ? const Center(child: Text('Aucun mouvement enregistré'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final m = list[i];
                    final isSale = m.isSale;
                    return ListTile(
                      leading: Icon(
                        isSale ? Icons.point_of_sale : Icons.add_box,
                        color: isSale ? Colors.red : Colors.green,
                      ),
                      title: Text(
                        isSale ? 'Vente (-${m.quantity})' : 'Entrée (+${m.quantity})',
                      ),
                      subtitle: Text(
                        'Produit ${m.productId}\n${fmt.format(m.date)}'
                        '${m.note != null ? '\n${m.note}' : ''}',
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
        );
      },
    );
  }
}
