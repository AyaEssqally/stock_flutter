import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseBootstrap {
  static bool initialized = false;
  static String? initError;

  static Future<bool> tryInitialize() async {
    if (initialized) return true;
    if (!DefaultFirebaseOptions.isConfigured) {
      initError = 'Firebase options placeholder — exécutez flutterfire configure.';
      return false;
    }
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
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
