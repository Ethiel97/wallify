import 'dart:async';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/features/auth/auth.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._authRemoteDataSource,
    this._firebaseAuthDatasource,
    this._authLocalDataSource,
  );

  final AuthRemoteDataSource _authRemoteDataSource;
  final FirebaseAuthDatasource _firebaseAuthDatasource;
  final AuthLocalDataSource _authLocalDataSource;

  // Use custom backend by default, Firebase as fallback
  bool _useFirebase = false;

  @override
  Future<User?> getCurrentUser() async {
    try {
      if (_useFirebase) {
        final user = await _firebaseAuthDatasource.getCurrentUser();
        return user?.toEntity();
      } else {
        // Try to get user from local storage first
        final localUser = await _authLocalDataSource.getUser();
        if (localUser != null) {
          return localUser.toEntity();
        }

        // If no local user and we have a token, fetch from remote
        final token = await _authLocalDataSource.getToken();
        if (token != null) {
          try {
            final user = await _authRemoteDataSource.fetchMe();
            await _authLocalDataSource.saveUser(user);
            return user.toEntity();
          } catch (e) {
            // Token might be expired, clear it
            await _authLocalDataSource.clearAuthData();
            return null;
          }
        }
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (_useFirebase) {
        final user = await _firebaseAuthDatasource.signInWithEmail(
          email: email,
          password: password,
        );
        return user.toEntity();
      } else {
        final response = await _authRemoteDataSource.login(
          email: email,
          password: password,
        );

        final user =
            UserModel.fromJson(response['user'] as Map<String, dynamic>);
        final token = response['jwt'] as String;

        await _authLocalDataSource.saveToken(token);
        await _authLocalDataSource.saveUser(user);

        return user.toEntity();
      }
    } on AuthException {
      rethrow;
    } catch (e, stack) {
      log(
        'Error signing in with email: $e \n$stack',
        name: 'AuthRepositoryImpl',
      );
      throw AuthException(e.toString());

      //ethiel97@gmail.com
    }
  }

  @override
  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      if (_useFirebase) {
        final user = await _firebaseAuthDatasource.signUpWithEmail(
          email: email,
          password: password,
        );
        return user.toEntity();
      } else {
        final response = await _authRemoteDataSource.register(
          email: email,
          password: password,
          username: username,
        );

        final user =
            UserModel.fromJson(response['user'] as Map<String, dynamic>);
        final token = response['jwt'] as String;

        await _authLocalDataSource.saveToken(token);
        await _authLocalDataSource.saveUser(user);

        return user.toEntity();
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      final user = await _firebaseAuthDatasource.signInWithGoogle();
      return user.toEntity();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (_useFirebase) {
        await _firebaseAuthDatasource.signOut();
      }
      await _authLocalDataSource.clearAuthData();
    } catch (e, stack) {
      log(
        'Error signing out: $e \n$stack',
        name: 'AuthRepositoryImpl',
      );
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      if (_useFirebase) {
        await _firebaseAuthDatasource.resetPassword(email);
      } else {
        await _authRemoteDataSource.resetPassword(email);
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> updateProfile({
    String? username,
    String? email,
  }) async {
    throw const AuthException('Profile update not implemented yet');
  }

  @override
  Stream<User?> get authStateChanges {
    if (_useFirebase) {
      return _firebaseAuthDatasource.authStateChanges.map(
        (user) => user?.toEntity(),
      );
    } else {
      // For custom backend, we'll return a simple stream
      // In a real implementation, you might use WebSockets or periodic checks
      return Stream.fromFuture(getCurrentUser()).asBroadcastStream();
    }
  }

  // Method to switch between Firebase and custom backend
  void setUseFirebase({bool useFirebase = false}) {
    _useFirebase = useFirebase;
  }
}
