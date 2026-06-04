import 'package:firebase_auth/firebase_auth.dart';

import '../../core/errors/failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../firebase/firebase_bootstrap.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuth? get _auth =>
      FirebaseBootstrap.initialized ? FirebaseAuth.instance : null;

  @override
  Stream<String?> authStateChanges() {
    if (_auth == null) return Stream.value(null);
    return _auth!.authStateChanges().map((u) => u?.uid);
  }

  @override
  String? get currentUserId => _auth?.currentUser?.uid;

  void _ensureReady() {
    if (_auth == null) {
      throw const FirebaseNotConfiguredFailure();
    }
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _ensureReady();
    try {
      await _auth!.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_authErrorMessage(e));
    }
  }

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    _ensureReady();
    try {
      await _auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(_authErrorMessage(e));
    }
  }

  static String _authErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'operation-not-allowed':
        return 'Firebase : activez « Email/Mot de passe » dans Authentication → Sign-in method.';
      case 'weak-password':
        return 'Mot de passe trop faible (minimum 6 caractères).';
      case 'email-already-in-use':
        return 'Email déjà utilisé — allez sur Connexion.';
      case 'invalid-email':
        return 'Adresse email invalide.';
      case 'network-request-failed':
        return 'Pas de réseau sur l’émulateur / la machine.';
      case 'configuration-not-found':
        return 'Projet Firebase mal configuré — vérifiez google-services.json et la console.';
      default:
        final detail = e.message;
        if (detail != null && detail.isNotEmpty && detail != 'Error') {
          return detail;
        }
        return 'Auth (${e.code}) — voir Firebase Console → Authentication.';
    }
  }

  @override
  Future<void> signOut() async {
    if (_auth != null) await _auth!.signOut();
  }
}
