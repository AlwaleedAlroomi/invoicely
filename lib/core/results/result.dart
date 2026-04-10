import 'package:invoicely/core/errors/failure.dart';

sealed class Result<T> {
  const Result();
  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
}

/// Represents a successful operation, holding the expected data.
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Represents a failed operation, holding the error payload.
class Error<T> extends Result<T> {
  final AppFailure failure;
  const Error(this.failure);
}
