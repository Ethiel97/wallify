import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/features/auth/auth.dart';

abstract class FirebaseAuthDatasource {
  Future<UserModel?> getCurrentUser();

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> signInWithGoogle();

  Future<void> signOut();

  Future<void> resetPassword(String email);

  Stream<UserModel?> get authStateChanges;
}

@LazySingleton(as: FirebaseAuthDatasource)
class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  FirebaseAuthDatasourceImpl(this._firebaseAuth);

  final firebase_auth.FirebaseAuth _firebaseAuth;

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _firebaseAuth.currentUser;
      return user != null ? _mapFirebaseUserToModel(user) : null;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw const AuthException('Sign in failed');
      }

      return _mapFirebaseUserToModel(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user == null) {
        throw const AuthException('Sign up failed');
      }

      return _mapFirebaseUserToModel(result.user!);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    throw const AuthException('Google sign in not implemented yet');
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      return user != null ? _mapFirebaseUserToModel(user) : null;
    });
  }

  UserModel _mapFirebaseUserToModel(firebase_auth.User user) {
    return UserModel(
      id: user.uid,
      email: user.email,
      username: user.displayName,
      confirmed: user.emailVerified,
      provider: 'firebase',
      createdAt: user.metadata.creationTime?.toIso8601String(),
      updatedAt: user.metadata.lastSignInTime?.toIso8601String(),
      blocked: false,
    );
  }

  String _mapFirebaseAuthError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      default:
        return e.message ?? 'An authentication error occurred.';
    }
  }
}
