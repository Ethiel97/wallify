import 'package:equatable/equatable.dart';
import 'package:wallinice/core/utils/utils.dart';
import 'package:wallinice/features/auth/auth.dart';

class AuthState extends Equatable {
  const AuthState({
    this.user = const ValueWrapper(),
    this.loginStatus = const ValueWrapper(),
    this.registerStatus = const ValueWrapper(),
    this.resetPasswordStatus = const ValueWrapper(),
  });

  final ValueWrapper<User> user;
  final ValueWrapper<String> loginStatus;
  final ValueWrapper<String> registerStatus;
  final ValueWrapper<String> resetPasswordStatus;

  bool get isAuthenticated =>
      user.isSuccess && (user.value?.isAuthenticated ?? false);

  bool get isUnauthenticated =>
      user.status == Status.initial || (user.isSuccess && !isAuthenticated);

  bool get isAuthenticating =>
      loginStatus.isLoading || registerStatus.isLoading;

  AuthState copyWith({
    ValueWrapper<User>? user,
    ValueWrapper<String>? loginStatus,
    ValueWrapper<String>? registerStatus,
    ValueWrapper<String>? resetPasswordStatus,
  }) {
    return AuthState(
      user: user ?? this.user,
      loginStatus: loginStatus ?? this.loginStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
    );
  }

  @override
  List<Object?> get props => [
        user,
        loginStatus,
        registerStatus,
        resetPasswordStatus,
      ];
}
