import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/providers/repository_providers.dart';

class HomeShell extends ConsumerWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  int _indexFromLocation(String loc) {
    if (loc.contains('categories')) return 1;
    if (loc.contains('mouvements')) return 2;
    if (loc.contains('dashboard')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(loc);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion de stock'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authRepositoryProvider).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.go('/home/products');
            case 1:
              context.go('/home/categories');
            case 2:
              context.go('/home/mouvements');
            case 3:
              context.go('/home/dashboard');
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.inventory_2), label: 'Produits'),
          NavigationDestination(icon: Icon(Icons.category), label: 'Catégories'),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz),
            label: 'Mouvements',
          ),
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        ],
      ),
    );
  }
}
