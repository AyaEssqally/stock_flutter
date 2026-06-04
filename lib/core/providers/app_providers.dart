import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/firebase/firebase_bootstrap.dart';
import '../../infrastructure/notifications/low_stock_notifier.dart';

final firebaseReadyProvider = Provider<bool>(
  (ref) => FirebaseBootstrap.initialized,
);

final lowStockNotifierProvider = Provider<LowStockNotifier>((ref) {
  return LowStockNotifier();
});
