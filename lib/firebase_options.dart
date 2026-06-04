// Généré à partir de android/app/google-services.json (projet stock-flutter-e1ae4).
// Pour d'autres plateformes : `dart pub global activate flutterfire_cli` puis `flutterfire configure`.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static const String _placeholderApiKey = 'YOUR_API_KEY';
  static const String _placeholderProjectId = 'YOUR_PROJECT_ID';

  static bool get isConfigured {
    final opts = currentPlatform;
    return opts.apiKey != _placeholderApiKey &&
        opts.projectId != _placeholderProjectId;
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError('Linux non configuré — lancez flutterfire configure.');
      default:
        throw UnsupportedError('Plateforme non supportée.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBcWNnzesS1kBMrIFsC5FNoVW__l9u3YHg',
    appId: '1:236998397282:android:8f77962a7d22de2ca1303b',
    messagingSenderId: '236998397282',
    projectId: 'stock-flutter-e1ae4',
    authDomain: 'stock-flutter-e1ae4.firebaseapp.com',
    storageBucket: 'stock-flutter-e1ae4.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBcWNnzesS1kBMrIFsC5FNoVW__l9u3YHg',
    appId: '1:236998397282:android:8f77962a7d22de2ca1303b',
    messagingSenderId: '236998397282',
    projectId: 'stock-flutter-e1ae4',
    storageBucket: 'stock-flutter-e1ae4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.appspot.com',
    iosBundleId: 'com.esisa.stock.stockFlutter',
  );

  static const FirebaseOptions macos = ios;

  /// Même projet Firebase que Android (démo bureau Windows).
  static const FirebaseOptions windows = android;
}
