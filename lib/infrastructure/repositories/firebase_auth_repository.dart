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
      throw AuthFailure(e.message ?? 'Échec connexion');
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
      throw AuthFailure(e.message ?? 'Échec inscription');
    }
  }

  @override
  Future<void> signOut() async {
    if (_auth != null) await _auth!.signOut();
  }
}
