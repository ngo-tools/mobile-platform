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
    required this.newContact,
    required this.editContact,
    required this.saveDraft,
    required this.submitDraft,
    required this.confirmTitle,
    required this.confirmMessage,
    required this.cancel,
    required this.confirm,
    required this.person,
    required this.organization,
    required this.name,
    required this.firstName,
    required this.lastName,
    required this.salutation,
    required this.titleField,
    required this.gender,
    required this.genderNotSpecified,
    required this.genderMale,
    required this.genderFemale,
    required this.genderDiverse,
    required this.localSaved,
    required this.submitting,
    required this.saved,
    required this.unsent,
    required this.validationFailure,
    required this.versionConflict,
    required this.draftLimit,
    required this.storageError,
    required this.done,
    required this.drafts,
    required this.noDrafts,
    required this.discardDraft,
    required this.confirmDiscard,
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
    newContact: 'Kontakt anlegen',
    editContact: 'Kontakt bearbeiten',
    saveDraft: 'Entwurf speichern',
    submitDraft: 'Entwurf senden',
    confirmTitle: 'Kontakt wirklich senden?',
    confirmMessage:
        'Prüfe die Zusammenfassung. Erst die Bestätigung überträgt den Entwurf.',
    cancel: 'Abbrechen',
    confirm: 'Bestätigen und senden',
    person: 'Person',
    organization: 'Organisation',
    name: 'Name',
    firstName: 'Vorname',
    lastName: 'Nachname',
    salutation: 'Anrede',
    titleField: 'Titel',
    gender: 'Geschlecht',
    genderNotSpecified: 'Keine Angabe',
    genderMale: 'Männlich',
    genderFemale: 'Weiblich',
    genderDiverse: 'Divers',
    localSaved: 'Der Entwurf wurde verschlüsselt auf diesem Gerät gespeichert.',
    submitting: 'Der bestätigte Entwurf wird gesendet.',
    saved: 'Der Kontakt wurde auf dem Server gespeichert.',
    unsent:
        'Nicht gesendet. Prüfe die Verbindung und starte den Versand manuell erneut.',
    validationFailure:
        'Der Server hat die Angaben abgelehnt. Der Entwurf bleibt erhalten.',
    versionConflict:
        'Der Kontakt wurde zwischenzeitlich geändert. Der Entwurf bleibt zum Vergleichen erhalten.',
    draftLimit:
        'Es sind bereits 50 Entwürfe gespeichert. Lösche einen Entwurf, bevor Du einen neuen anlegst.',
    storageError: 'Der Entwurf konnte nicht lokal gespeichert werden.',
    done: 'Fertig',
    drafts: 'Entwürfe',
    noDrafts: 'Keine gespeicherten Entwürfe.',
    discardDraft: 'Entwurf verwerfen',
    confirmDiscard: 'Diesen lokalen Entwurf wirklich verwerfen?',
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
    newContact: 'Create contact',
    editContact: 'Edit contact',
    saveDraft: 'Save draft',
    submitDraft: 'Submit draft',
    confirmTitle: 'Submit this contact?',
    confirmMessage:
        'Review the summary. The draft is transferred only after confirmation.',
    cancel: 'Cancel',
    confirm: 'Confirm and submit',
    person: 'Person',
    organization: 'Organization',
    name: 'Name',
    firstName: 'First name',
    lastName: 'Last name',
    salutation: 'Salutation',
    titleField: 'Title',
    gender: 'Gender',
    genderNotSpecified: 'Not specified',
    genderMale: 'Male',
    genderFemale: 'Female',
    genderDiverse: 'Diverse',
    localSaved: 'The draft was stored encrypted on this device.',
    submitting: 'The confirmed draft is being submitted.',
    saved: 'The contact was saved on the server.',
    unsent: 'Not sent. Check the connection and retry the submission manually.',
    validationFailure:
        'The server rejected these details. The draft remains available.',
    versionConflict:
        'The contact changed in the meantime. The draft remains available for comparison.',
    draftLimit:
        'There are already 50 saved drafts. Delete one before creating another.',
    storageError: 'The draft could not be stored locally.',
    done: 'Done',
    drafts: 'Drafts',
    noDrafts: 'No saved drafts.',
    discardDraft: 'Discard draft',
    confirmDiscard: 'Discard this local draft?',
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
  final String newContact;
  final String editContact;
  final String saveDraft;
  final String submitDraft;
  final String confirmTitle;
  final String confirmMessage;
  final String cancel;
  final String confirm;
  final String person;
  final String organization;
  final String name;
  final String firstName;
  final String lastName;
  final String salutation;
  final String titleField;
  final String gender;
  final String genderNotSpecified;
  final String genderMale;
  final String genderFemale;
  final String genderDiverse;
  final String localSaved;
  final String submitting;
  final String saved;
  final String unsent;
  final String validationFailure;
  final String versionConflict;
  final String draftLimit;
  final String storageError;
  final String done;
  final String drafts;
  final String noDrafts;
  final String discardDraft;
  final String confirmDiscard;

  /// Returns the localized label for [sort].
  String sortNameFor(ContactsSort sort) => switch (sort) {
    ContactsSort.lastName => sortLastName,
    ContactsSort.name => sortName,
    ContactsSort.recentlyUpdated => sortRecentlyUpdated,
  };
}
