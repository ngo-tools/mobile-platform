import 'package:flutter_test/flutter_test.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:ngotools_testing/ngotools_testing.dart';

void main() {
  test('uses only reserved invalid hosts', () {
    final hosts = MobileEnvironment.values.map(
      (environment) => SyntheticMobileFixture.configuration
          .forEnvironment(environment)
          .apiBaseUrl
          .host,
    );

    expect(hosts, everyElement(endsWith('.invalid')));
  });

  test('exposes only synthetic runtime capabilities', () {
    expect(SyntheticMobileFixture.capabilities.hasFeature('contacts'), isTrue);
    expect(SyntheticMobileFixture.capabilities.canImport('contacts'), isTrue);
  });

  test('synthetic contacts use reserved addresses', () async {
    const repository = SyntheticContactsRepository();
    final contacts = await repository.search(const ContactSearch());

    expect(contacts.items, isNotEmpty);
    expect(
      contacts.items.where((contact) => contact.email != null),
      everyElement(
        predicate<ContactRecord>(
          (contact) => contact.email!.endsWith('@example.invalid'),
        ),
      ),
    );
  });
}
