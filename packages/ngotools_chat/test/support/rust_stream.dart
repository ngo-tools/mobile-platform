/// Mimics a generated Rust stream: an `async*` generator that waits for
/// events and only ends once the Rust side closes it.
Stream<T> rustLikeStream<T>(Stream<T> source) async* {
  await for (final value in source) {
    yield value;
  }
}
