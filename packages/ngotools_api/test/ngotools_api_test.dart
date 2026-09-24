import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_api/ngotools_api.dart';

void main() {
  test('orders semantic contract versions', () {
    final supported = MobileContractVersion.parse('2.4.0');
    final required = MobileContractVersion.parse('2.3.9');

    expect(supported.compareTo(required), greaterThan(0));
    expect(supported.toString(), '2.4.0');
  });

  test('rejects malformed contract versions', () {
    expect(
      () => MobileContractVersion.parse('2.4'),
      throwsA(isA<FormatException>()),
    );
  });
}
