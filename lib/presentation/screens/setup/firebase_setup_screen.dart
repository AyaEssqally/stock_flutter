import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../infrastructure/firebase/firebase_bootstrap.dart';

class FirebaseSetupScreen extends ConsumerWidget {
  const FirebaseSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuration Firebase')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.cloud_off, size: 64, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'Firebase n\'est pas encore configuré',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              FirebaseBootstrap.initError ??
                  'Remplacez les placeholders dans lib/firebase_options.dart '
                  'ou exécutez flutterfire configure (voir GUIDE_FR.md).',
            ),
            const SizedBox(height: 24),
            const Text('Étapes rapides :'),
            const SizedBox(height: 8),
            const Text('1. Créer un projet Firebase Console'),
            const Text('2. Activer Auth (email/mot de passe) et Firestore'),
            const Text('3. dart pub global activate flutterfire_cli'),
            const Text('4. flutterfire configure'),
            const Text('5. Redémarrer l\'application'),
            const Spacer(),
            FilledButton.icon(
              onPressed: () async {
                final ok = await FirebaseBootstrap.tryInitialize();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? 'Firebase initialisé — reconnectez-vous'
                            : 'Échec : ${FirebaseBootstrap.initError}',
                      ),
                    ),
                  );
                  if (ok) context.go('/login');
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer l\'initialisation'),
            ),
          ],
        ),
      ),
    );
  }
}
