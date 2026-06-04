import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/entities/product.dart';

class LowStockNotifier {
  LowStockNotifier() : _plugin = FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _ready = false;
  final Set<String> _notifiedIds = {};

  Future<void> initialize() async {
    if (kIsWeb) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _ready = true;
  }

  Future<void> checkAndNotify(List<Product> lowStock) async {
    if (!_ready || kIsWeb) return;
    for (final p in lowStock) {
      if (_notifiedIds.contains(p.id)) continue;
      _notifiedIds.add(p.id);
      await _plugin.show(
        p.id.hashCode,
        'Stock bas — ${p.name}',
        'Quantité ${p.quantity} (seuil ${p.reorderThreshold}). Réapprovisionnement conseillé.',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'low_stock_channel',
            'Alertes stock',
            channelDescription: 'Produits sous seuil de réapprovisionnement',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
    final currentIds = lowStock.map((p) => p.id).toSet();
    _notifiedIds.removeWhere((id) => !currentIds.contains(id));
  }
}
