import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_chat/src/diff_list.dart';

void main() {
  test('applies every diff variant in order', () {
    final result = applyDiffs<String>(const [], const [
      ListReset(['b', 'c']),
      ListPushFront('a'),
      ListPushBack('d'),
      ListAppend(['e', 'f']),
      ListInsert(2, 'x'),
      ListSet(0, 'A'),
      ListRemove(2),
      ListPopBack(),
      ListPopFront(),
      ListTruncate(2),
    ]);

    expect(result, ['b', 'c']);
  });

  test('clears the list', () {
    expect(applyDiffs(['a', 'b'], const [ListClear<String>()]), isEmpty);
  });

  test('keeps the input untouched and returns an unmodifiable list', () {
    final input = ['a'];
    final result = applyDiffs(input, const [ListPushBack('b')]);

    expect(input, ['a']);
    expect(() => result.add('c'), throwsUnsupportedError);
  });

  test('throws on an index outside the list', () {
    expect(
      () => applyDiffs(const ['a'], const [ListRemove<String>(3)]),
      throwsRangeError,
    );
  });
}
