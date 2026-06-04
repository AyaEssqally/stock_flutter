abstract class AuthRepository {
  Stream<String?> authStateChanges();
  String? get currentUserId;
  Future<void> signIn({required String email, required String password});
  Future<void> register({required String email, required String password});
  Future<void> signOut();
}
