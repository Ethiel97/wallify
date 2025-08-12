import 'package:wallinice/features/auth/auth.dart';

abstract class AuthRepository {
  Future<User?> getCurrentUser();
  Future<User> signInWithEmail({
    required String email,
    required String password,
  });
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  });
  Future<User> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> updateProfile({
    String? username,
    String? email,
  });
  Stream<User?> get authStateChanges;
}
