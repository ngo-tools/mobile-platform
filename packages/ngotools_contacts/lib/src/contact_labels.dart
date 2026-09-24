import 'contact_models.dart';

/// Localized labels consumed by the contact views.
final class ContactLabels {
  /// Creates a complete set of contact labels.
  const ContactLabels({
    required this.title,
    required this.searchHint,
    required this.searchAction,
    required this.clearSearch,
    required this.sortLabel,
    required this.sortLastName,
    required this.sortName,
    required this.sortRecentlyUpdated,
    required this.emptyTitle,
    required this.emptyMessage,
    required this.noResultsTitle,
    required this.noResultsMessage,
    required this.errorMessage,
    required this.retry,
    required this.loadMore,
    required this.loading,
    required this.cachedMessage,
    required this.unknownContact,
    required this.detailsTitle,
    required this.contactInformation,
    required this.email,
    required this.birthday,
    required this.addresses,
    required this.noDetails,
  });

  /// German contact labels.
  static const german = ContactLabels(
    title: 'Kontakte',
    searchHint: 'Kontakte durchsuchen',
    searchAction: 'Suchen',
    clearSearch: 'Suche löschen',
    sortLabel: 'Sortierung',
    sortLastName: 'Nachname',
    sortName: 'Name',
    sortRecentlyUpdated: 'Zuletzt geändert',
    emptyTitle: 'Noch keine Kontakte',
    emptyMessage: 'Für diesen Zugang sind keine Kontakte verfügbar.',
    noResultsTitle: 'Keine Treffer',
    noResultsMessage: 'Passe den Suchbegriff an und versuche es erneut.',
    errorMessage: 'Die Kontakte konnten nicht geladen werden.',
    retry: 'Erneut versuchen',
    loadMore: 'Weitere laden',
    loading: 'Kontakte werden geladen',
    cachedMessage:
        'Offline-Kopie der letzten erfolgreichen Aktualisierung wird angezeigt.',
    unknownContact: 'Unbenannter Kontakt',
    detailsTitle: 'Kontaktdetails',
    contactInformation: 'Kontaktinformationen',
    email: 'E-Mail',
    birthday: 'Geburtstag',
    addresses: 'Adressen',
    noDetails: 'Keine weiteren Angaben verfügbar.',
  );

  /// English contact labels.
  static const english = ContactLabels(
    title: 'Contacts',
    searchHint: 'Search contacts',
    searchAction: 'Search',
    clearSearch: 'Clear search',
    sortLabel: 'Sort order',
    sortLastName: 'Last name',
    sortName: 'Name',
    sortRecentlyUpdated: 'Recently updated',
    emptyTitle: 'No contacts yet',
    emptyMessage: 'No contacts are available to this account.',
    noResultsTitle: 'No results',
    noResultsMessage: 'Adjust the search term and try again.',
    errorMessage: 'Contacts could not be loaded.',
    retry: 'Try again',
    loadMore: 'Load more',
    loading: 'Loading contacts',
    cachedMessage: 'Showing an offline copy from the last successful update.',
    unknownContact: 'Unnamed contact',
    detailsTitle: 'Contact details',
    contactInformation: 'Contact information',
    email: 'Email',
    birthday: 'Birthday',
    addresses: 'Addresses',
    noDetails: 'No additional details are available.',
  );

  final String title;
  final String searchHint;
  final String searchAction;
  final String clearSearch;
  final String sortLabel;
  final String sortLastName;
  final String sortName;
  final String sortRecentlyUpdated;
  final String emptyTitle;
  final String emptyMessage;
  final String noResultsTitle;
  final String noResultsMessage;
  final String errorMessage;
  final String retry;
  final String loadMore;
  final String loading;
  final String cachedMessage;
  final String unknownContact;
  final String detailsTitle;
  final String contactInformation;
  final String email;
  final String birthday;
  final String addresses;
  final String noDetails;

  /// Returns the localized label for [sort].
  String sortNameFor(ContactsSort sort) => switch (sort) {
    ContactsSort.lastName => sortLastName,
    ContactsSort.name => sortName,
    ContactsSort.recentlyUpdated => sortRecentlyUpdated,
  };
}
