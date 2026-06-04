import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'application/providers/repository_providers.dart';
import 'core/providers/app_providers.dart';
import 'core/router/app_router.dart';
import 'domain/entities/product.dart';
import 'infrastructure/notifications/low_stock_notifier.dart';

class StockApp extends ConsumerStatefulWidget {
  const StockApp({super.key, required this.lowStockNotifier});

  final LowStockNotifier lowStockNotifier;

  @override
  ConsumerState<StockApp> createState() => _StockAppState();
}

class _StockAppState extends ConsumerState<StockApp> {
  @override
  Widget build(BuildContext context) {
    ref.listen(lowStockStreamProvider, (prev, next) {
      final list = next.valueOrNull;
      if (list != null) {
        widget.lowStockNotifier.checkAndNotify(
          list.cast<Product>(),
        );
      }
    });

    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      title: 'Stock Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
