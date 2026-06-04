import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'infrastructure/firebase/firebase_bootstrap.dart';
import 'infrastructure/notifications/low_stock_notifier.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.tryInitialize();
  final notifier = LowStockNotifier();
  await notifier.initialize();
  runApp(
    ProviderScope(
      overrides: [],
      child: StockApp(lowStockNotifier: notifier),
    ),
  );
}
