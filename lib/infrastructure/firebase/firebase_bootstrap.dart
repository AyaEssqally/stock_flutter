import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show debugPrint, defaultTargetPlatform, kIsWeb, TargetPlatform;

import '../../firebase_options.dart';

class FirebaseBootstrap {
  static bool initialized = false;
  static String? initError;

  static Future<bool> tryInitialize() async {
    if (initialized) return true;
    try {
      if (DefaultFirebaseOptions.isConfigured) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else if (!kIsWeb &&
          defaultTargetPlatform == TargetPlatform.android) {
        // Android : google-services.json peut suffire sans firebase_options.dart
        await Firebase.initializeApp();
      } else {
        initError =
            'Firebase options placeholder — exécutez flutterfire configure.';
        return false;
      }
      initialized = true;
      initError = null;
      return true;
    } catch (e, st) {
      initError = e.toString();
      debugPrint('Firebase init error: $e\n$st');
      return false;
    }
  }
}
