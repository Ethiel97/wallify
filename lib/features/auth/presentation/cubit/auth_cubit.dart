import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wallinice/core/errors/errors.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/auth/auth.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthState()) {
    _initializeAuth();
    _subscribeToAuthChanges();
  }

  final AuthRepository _authRepository;
  StreamSubscription<User?>? _authSubscription;

  Future<void> _initializeAuth() async {
    try {
      emit(state.copyWith(user: state.user.toLoading()));

      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(user: state.user.toSuccess(user)));
      } else {
        emit(state.copyWith(user: const ValueWrapper<User>()));
      }
    } catch (e) {
      emit(
        state.copyWith(
          user: state.user.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  void _subscribeToAuthChanges() {
    _authSubscription?.cancel();
    _authSubscription = _authRepository.authStateChanges.listen(
      (user) {
        if (user != null) {
          emit(state.copyWith(user: state.user.toSuccess(user)));
        } else {
          emit(state.copyWith(user: const ValueWrapper<User>()));
        }
      },
      onError: (error) {
        emit(
          state.copyWith(
            user: state.user.toError(
              ErrorDetails(message: error.toString()),
            ),
          ),
        );
      },
    );
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(loginStatus: state.loginStatus.toLoading()));

      final user = await _authRepository.signInWithEmail(
        email: email,
        password: password,
      );

      emit(
        state.copyWith(
          user: state.user.toSuccess(user),
          loginStatus: state.loginStatus.toSuccess('Sign in successful'),
        ),
      );
    } on AuthException catch (e) {
      emit(
        state.copyWith(
          loginStatus: state.loginStatus.toError(
            ErrorDetails(message: e.message.toString()),
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          loginStatus: state.loginStatus.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? username,
  }) async {
    try {
      emit(state.copyWith(registerStatus: state.registerStatus.toLoading()));

      final user = await _authRepository.signUpWithEmail(
        email: email,
        password: password,
        username: username,
      );

      emit(
        state.copyWith(
          user: state.user.toSuccess(user),
          registerStatus:
              state.registerStatus.toSuccess('Registration successful'),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          registerStatus: state.registerStatus.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(state.copyWith(loginStatus: state.loginStatus.toLoading()));

      final user = await _authRepository.signInWithGoogle();

      emit(
        state.copyWith(
          user: state.user.toSuccess(user),
          loginStatus: state.loginStatus.toSuccess('Google sign in successful'),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          loginStatus: state.loginStatus.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      emit(
        state.copyWith(
          resetPasswordStatus: state.resetPasswordStatus.toLoading(),
        ),
      );

      await _authRepository.resetPassword(email);

      emit(
        state.copyWith(
          resetPasswordStatus: state.resetPasswordStatus.toSuccess(
            'Password reset email sent',
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          resetPasswordStatus: state.resetPasswordStatus.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
      emit(state.copyWith(user: const ValueWrapper<User>()));
    } catch (e) {
      emit(
        state.copyWith(
          user: state.user.toError(
            ErrorDetails(message: e.toString()),
          ),
        ),
      );
    }
  }

  void clearLoginStatus() {
    emit(state.copyWith(loginStatus: null.toInitial()));
  }

  void clearRegisterStatus() {
    emit(state.copyWith(registerStatus: null.toInitial()));
  }

  void clearResetPasswordStatus() {
    emit(state.copyWith(resetPasswordStatus: null.toInitial()));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
