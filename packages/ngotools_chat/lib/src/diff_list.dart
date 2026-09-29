/// A change to a list, mirroring `eyeball_im::VectorDiff` on the Rust side.
sealed class ListDiff<T> {
  const ListDiff();
}

final class ListAppend<T> extends ListDiff<T> {
  const ListAppend(this.values);

  final List<T> values;
}

final class ListClear<T> extends ListDiff<T> {
  const ListClear();
}

final class ListPushFront<T> extends ListDiff<T> {
  const ListPushFront(this.value);

  final T value;
}

final class ListPushBack<T> extends ListDiff<T> {
  const ListPushBack(this.value);

  final T value;
}

final class ListPopFront<T> extends ListDiff<T> {
  const ListPopFront();
}

final class ListPopBack<T> extends ListDiff<T> {
  const ListPopBack();
}

final class ListInsert<T> extends ListDiff<T> {
  const ListInsert(this.index, this.value);

  final int index;
  final T value;
}

final class ListSet<T> extends ListDiff<T> {
  const ListSet(this.index, this.value);

  final int index;
  final T value;
}

final class ListRemove<T> extends ListDiff<T> {
  const ListRemove(this.index);

  final int index;
}

final class ListTruncate<T> extends ListDiff<T> {
  const ListTruncate(this.length);

  final int length;
}

final class ListReset<T> extends ListDiff<T> {
  const ListReset(this.values);

  final List<T> values;
}

/// Applies [diffs] to [current] and returns a new, unmodifiable list.
List<T> applyDiffs<T>(List<T> current, Iterable<ListDiff<T>> diffs) {
  final next = List<T>.of(current);

  for (final diff in diffs) {
    switch (diff) {
      case ListAppend<T>(:final values):
        next.addAll(values);
      case ListClear<T>():
        next.clear();
      case ListPushFront<T>(:final value):
        next.insert(0, value);
      case ListPushBack<T>(:final value):
        next.add(value);
      case ListPopFront<T>():
        next.removeAt(0);
      case ListPopBack<T>():
        next.removeLast();
      case ListInsert<T>(:final index, :final value):
        next.insert(index, value);
      case ListSet<T>(:final index, :final value):
        next[index] = value;
      case ListRemove<T>(:final index):
        next.removeAt(index);
      case ListTruncate<T>(:final length):
        next.length = length;
      case ListReset<T>(:final values):
        next
          ..clear()
          ..addAll(values);
    }
  }

  return List.unmodifiable(next);
}
