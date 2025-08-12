import 'package:equatable/equatable.dart';

enum Status {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == Status.loading;

  bool get isSuccess => this == Status.success;

  bool get isError => this == Status.error;

  bool get isInitial => this == Status.initial;
}

class ErrorDetails extends Equatable {
  /// A class that represents error details.
  ///
  const ErrorDetails({
    required this.message,
    this.errorCode,
    this.stackTrace,
  });

  const ErrorDetails.empty()
      : message = '',
        errorCode = null,
        stackTrace = null;

  final String message;
  final int? errorCode;
  final StackTrace? stackTrace;

  @override
  List<Object?> get props => [
        errorCode,
        message,
        stackTrace,
      ];
}

class ValueWrapper<T> extends Equatable {
  const ValueWrapper({
    this.error,
    this.status = Status.initial,
    this.statusMessage,
    this.value,
  });

  T? call() => value;

  final ErrorDetails? error;

  final Status status;

  final String? statusMessage;

  final T? value;

  T get data => value!;

  bool get hasData => value != null;

  bool get isError => status.isError;

  bool get isInitial => status.isInitial;

  bool get isLoading => status.isLoading;

  bool get isSuccess => status.isSuccess;

  ValueWrapper<T> copyWith({
    ErrorDetails? error,
    Status? status,
    String? statusMessage,
    T? value,
  }) =>
      ValueWrapper<T>(
        error: error ?? this.error,
        status: status ?? this.status,
        statusMessage: statusMessage ?? this.statusMessage,
        value: value ?? this.value,
      );

  ValueWrapper<T> toError([
    ErrorDetails? error,
    String? statusMessage,
  ]) =>
      copyWith(
        error: error,
        status: Status.error,
        statusMessage: statusMessage,
        value: value,
      );

  ValueWrapper<T> toInitial([
    T? value,
    ErrorDetails? error,
  ]) =>
      copyWith(
        status: Status.initial,
        value: value,
        error: error,
      );

  ValueWrapper<T> toLoading([
    T? value,
    String? statusMessage,
  ]) =>
      copyWith(
        status: Status.loading,
        statusMessage: statusMessage,
        value: value,
      );

  ValueWrapper<T> toSuccess([
    T? value,
    String? statusMessage,
  ]) =>
      copyWith(
        status: Status.success,
        statusMessage: statusMessage,
        value: value,
      );

  @override
  String toString() => isError
      ? 'Error(${error?.message} ${error?.stackTrace})'
      : '(${status.name}) ValueWrapper($value)';

  bool get isComplete => status.isSuccess || status.isError;

  @override
  List<Object?> get props => [
        error,
        status,
        statusMessage,
        value,
      ];
}

extension ValueWrapperExtension<T> on ValueWrapper<T> {
  /// Returns the result of the [when] function.
  /// based on each possible [Status] of the [ValueWrapper]
  W when<W>({
    required W Function() initial,
    required W Function(T? oldValue) loading,
    required W Function(T value) success,
    required W Function(ErrorDetails errorDetails, T? oldValue) error,
  }) =>
      switch (status) {
        Status.initial => initial(),
        Status.loading => loading(value),
        Status.success => success(value as T),
        Status.error => error(
            this.error ?? const ErrorDetails.empty(),
            value,
          ),
      };

  /// Returns the result of the [maybeWhen] function.
  ///
  /// It is similar to [when], but it allows you to provide
  /// a default [orElse] value
  /// for when the status does not match any of the provided cases.
  W maybeWhen<W>({
    required W Function() orElse,
    W Function()? initial,
    W Function(T? oldValue)? loading,
    W Function(T value)? success,
    W Function(ErrorDetails errorDetails, T? oldValue)? error,
  }) =>
      switch (status) {
        Status.initial => initial?.call() ?? orElse(),
        Status.loading => loading?.call(value) ?? orElse(),
        Status.success => success?.call(value as T) ?? orElse(),
        Status.error =>
          error?.call(this.error ?? const ErrorDetails.empty(), value) ??
              orElse(),
      };

  /// Returns the result of the [map] function.
  /// which transforms the value of the [ValueWrapper]
  ValueWrapper<R> map<R>(R Function(T value) transform) {
    if (status.isError || hasData == false) {
      return ValueWrapper<R>(
        error: error,
        status: status,
        statusMessage: statusMessage,
      );
    }

    return ValueWrapper(
      error: error,
      status: status,
      statusMessage: statusMessage,
      value: transform(value as T),
    );
  }
}

/// This extension provides a way to convert an [Object?] to a [ValueWrapper<T>]
/// by using the [toSuccess], [toError], [toLoading], and [toInitial] methods.
extension ValueWrapperObj on Object? {
  ValueWrapper<T> toSuccess<T>() => ValueWrapper<T>(
        status: Status.success,
        value: this as T?,
      );

  ValueWrapper<T> toError<T>([
    ErrorDetails? error,
    String? statusMessage,
  ]) =>
      ValueWrapper<T>(
        error: error,
        status: Status.error,
        statusMessage: statusMessage,
        value: this as T?,
      );

  ValueWrapper<T> toLoading<T>([
    String? statusMessage,
  ]) =>
      ValueWrapper<T>(
        status: Status.loading,
        statusMessage: statusMessage,
        value: this as T?,
      );

  ValueWrapper<T> toInitial<T>([
    T? value,
    ErrorDetails? error,
  ]) =>
      ValueWrapper<T>(
        value: value ?? this as T?,
        error: error,
      );
}
