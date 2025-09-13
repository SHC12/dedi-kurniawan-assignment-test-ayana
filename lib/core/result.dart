sealed class Result<F, V> {
  const Result();
  R fold<R>(R Function(F failure) left, R Function(V value) right);
  bool get isSuccess => this is Ok<F, V>;
}

class Ok<F, V> extends Result<F, V> {
  final V value;
  const Ok(this.value);
  @override
  R fold<R>(R Function(F failure) left, R Function(V value) right) => right(value);
}

class Err<F, V> extends Result<F, V> {
  final F failure;
  const Err(this.failure);
  @override
  R fold<R>(R Function(F failure) left, R Function(V value) right) => left(failure);
}
