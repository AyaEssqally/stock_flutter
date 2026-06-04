import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stock_flutter/app.dart';
import 'package:stock_flutter/infrastructure/notifications/low_stock_notifier.dart';

void main() {
  testWidgets('StockApp affiche titre connexion ou setup', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: StockApp(lowStockNotifier: LowStockNotifier()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(
      find.textContaining('Stock').evaluate().isNotEmpty ||
          find.textContaining('Firebase').evaluate().isNotEmpty,
      isTrue,
    );
  });
}
