import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_auth/ngotools_auth.dart';

void main() {
  test('keeps the sanitized capability set immutable', () {
    final capabilities = <String>['contacts.read'];
    final identity = MobileIdentity(
      id: 'synthetic-user',
      displayName: 'Synthetic User',
      capabilities: capabilities,
    );

    capabilities.add('contacts.write');

    expect(identity.capabilities, {'contacts.read'});
  });
}
