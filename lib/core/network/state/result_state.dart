abstract class ResultState<T> {
  const ResultState();
}

class Idle<T> extends ResultState<T?> {}

class Loading<T> extends ResultState<T?> {}

class Success<T> extends ResultState<T?> {
  final T? data;
  const Success(this.data);
}

class Error<T> extends ResultState<T?> {
  final String message;
  final Exception? error;
  const Error(this.message, {this.error});
}
