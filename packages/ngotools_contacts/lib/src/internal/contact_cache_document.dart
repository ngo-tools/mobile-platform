import '../contact_models.dart';

/// Mutable in-memory representation of one decrypted cache document.
final class ContactCacheDocument {
  ContactCacheDocument({
    Map<int, CachedContactValue>? contacts,
    Map<int, CachedContactValue>? details,
    Map<String, CachedSearchValue>? searches,
    Map<String, ContactDraft>? drafts,
  }) : contacts = contacts ?? {},
       details = details ?? {},
       searches = searches ?? {},
       drafts = drafts ?? {};

  factory ContactCacheDocument.fromJson(Map<String, Object?> json) {
    final documentVersion = json['version'];

    if (documentVersion != version) {
      throw const FormatException('Unsupported contact cache version.');
    }

    final contacts = _decodeContactValues(json['contacts']);
    final details = _decodeContactValues(json['details']);
    final searches = _decodeSearchValues(json['searches']);
    final drafts = _decodeDrafts(json['drafts']);

    return ContactCacheDocument(
      contacts: contacts,
      details: details,
      searches: searches,
      drafts: drafts,
    );
  }

  static const version = 2;

  final Map<int, CachedContactValue> contacts;
  final Map<int, CachedContactValue> details;
  final Map<String, CachedSearchValue> searches;
  final Map<String, ContactDraft> drafts;

  Map<String, Object?> toJson() => {
    'version': version,
    'contacts': {
      for (final entry in contacts.entries)
        entry.key.toString(): entry.value.toJson(),
    },
    'details': {
      for (final entry in details.entries)
        entry.key.toString(): entry.value.toJson(),
    },
    'searches': {
      for (final entry in searches.entries) entry.key: entry.value.toJson(),
    },
    'drafts': {
      for (final entry in drafts.entries) entry.key: _encodeDraft(entry.value),
    },
  };

  static Map<int, CachedContactValue> _decodeContactValues(Object? value) {
    final map = _objectMap(value);
    final result = <int, CachedContactValue>{};

    for (final entry in map.entries) {
      final id = int.tryParse(entry.key);

      if (id == null || id < 1) {
        throw const FormatException('Invalid cached contact key.');
      }

      final cached = CachedContactValue.fromJson(_objectMap(entry.value));

      if (cached.contact.id != id) {
        throw const FormatException('Cached contact key mismatch.');
      }

      result[id] = cached;
    }

    return result;
  }

  static Map<String, CachedSearchValue> _decodeSearchValues(Object? value) {
    final map = _objectMap(value);

    return {
      for (final entry in map.entries)
        entry.key: CachedSearchValue.fromJson(_objectMap(entry.value)),
    };
  }

  static Map<String, ContactDraft> _decodeDrafts(Object? value) {
    final map = _objectMap(value);
    final result = <String, ContactDraft>{};

    for (final entry in map.entries) {
      final draft = _decodeDraft(_objectMap(entry.value));

      if (draft.localId != entry.key) {
        throw const FormatException('Cached draft key mismatch.');
      }

      result[entry.key] = draft;
    }

    return result;
  }
}

/// One cached contact projection and its successful-fetch timestamp.
final class CachedContactValue {
  const CachedContactValue({required this.contact, required this.storedAt});

  factory CachedContactValue.fromJson(Map<String, Object?> json) =>
      CachedContactValue(
        contact: _decodeContact(_objectMap(json['contact'])),
        storedAt: _requiredDateTime(json, 'stored_at'),
      );

  final ContactRecord contact;
  final DateTime storedAt;

  Map<String, Object?> toJson() => {
    'contact': _encodeContact(contact),
    'stored_at': storedAt.toUtc().toIso8601String(),
  };
}

/// Cached pagination metadata pointing to encrypted contact records.
final class CachedSearchValue {
  const CachedSearchValue({
    required this.contactIds,
    required this.page,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.storedAt,
  });

  factory CachedSearchValue.fromJson(Map<String, Object?> json) {
    final rawIds = json['contact_ids'];
    final page = json['page'];
    final perPage = json['per_page'];
    final total = json['total'];
    final lastPage = json['last_page'];

    if (rawIds is! List<Object?> ||
        !rawIds.every((value) => value is int && value > 0) ||
        page is! int ||
        page < 1 ||
        perPage is! int ||
        perPage < 1 ||
        total is! int ||
        total < 0 ||
        lastPage is! int ||
        lastPage < 1) {
      throw const FormatException('Invalid cached contact search.');
    }

    return CachedSearchValue(
      contactIds: List<int>.unmodifiable(rawIds.cast<int>()),
      page: page,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      storedAt: _requiredDateTime(json, 'stored_at'),
    );
  }

  final List<int> contactIds;
  final int page;
  final int perPage;
  final int total;
  final int lastPage;
  final DateTime storedAt;

  Map<String, Object?> toJson() => {
    'contact_ids': contactIds,
    'page': page,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
    'stored_at': storedAt.toUtc().toIso8601String(),
  };
}

Map<String, Object?> _encodeDraft(ContactDraft draft) => {
  'local_id': draft.localId,
  'idempotency_key': draft.idempotencyKey,
  'kind': draft.kind.name,
  'created_at': draft.createdAt.toUtc().toIso8601String(),
  'updated_at': draft.updatedAt.toUtc().toIso8601String(),
  if (draft.contactId != null) 'contact_id': draft.contactId,
  if (draft.baseVersion != null) 'base_version': draft.baseVersion,
  if (draft.name != null) 'name': draft.name,
  if (draft.firstName != null) 'first_name': draft.firstName,
  if (draft.lastName != null) 'last_name': draft.lastName,
  if (draft.email != null) 'email': draft.email,
  if (draft.salutation != null) 'salutation': draft.salutation,
  if (draft.title != null) 'title': draft.title,
  if (draft.gender != null) 'gender': draft.gender,
  if (draft.birthday != null)
    'birthday': draft.birthday!.toIso8601String().split('T').first,
  'state': draft.state.name,
};

ContactDraft _decodeDraft(Map<String, Object?> json) {
  final localId = json['local_id'];
  final idempotencyKey = json['idempotency_key'];
  final kindName = json['kind'];
  final stateName = json['state'];
  final contactId = _optionalInt(json, 'contact_id');

  if (localId is! String ||
      !_isUuid(localId) ||
      idempotencyKey is! String ||
      !_isUuid(idempotencyKey) ||
      kindName is! String ||
      stateName is! String ||
      (contactId != null && contactId < 1)) {
    throw const FormatException('Invalid cached contact draft.');
  }

  final kind = ContactDraftKind.values
      .where((candidate) => candidate.name == kindName)
      .firstOrNull;
  final state = ContactDraftState.values
      .where((candidate) => candidate.name == stateName)
      .firstOrNull;
  final baseVersion = _optionalString(json, 'base_version');

  if (kind == null ||
      state == null ||
      (contactId == null) != (baseVersion == null) ||
      (baseVersion != null && !_isVersion(baseVersion))) {
    throw const FormatException('Invalid cached contact draft state.');
  }

  return ContactDraft(
    localId: localId,
    idempotencyKey: idempotencyKey,
    kind: kind,
    createdAt: _requiredDateTime(json, 'created_at'),
    updatedAt: _requiredDateTime(json, 'updated_at'),
    contactId: contactId,
    baseVersion: baseVersion,
    name: _optionalString(json, 'name'),
    firstName: _optionalString(json, 'first_name'),
    lastName: _optionalString(json, 'last_name'),
    email: _optionalString(json, 'email'),
    salutation: _optionalString(json, 'salutation'),
    title: _optionalString(json, 'title'),
    gender: _optionalString(json, 'gender'),
    birthday: _optionalDateTime(json, 'birthday'),
    state: state,
  );
}

Map<String, Object?> _encodeContact(ContactRecord contact) => {
  'id': contact.id,
  'kind': contact.kind.name,
  'version': contact.version,
  if (contact.name != null) 'name': contact.name,
  if (contact.firstName != null) 'first_name': contact.firstName,
  if (contact.lastName != null) 'last_name': contact.lastName,
  if (contact.email != null) 'email': contact.email,
  if (contact.salutation != null) 'salutation': contact.salutation,
  if (contact.title != null) 'title': contact.title,
  if (contact.gender != null) 'gender': contact.gender,
  if (contact.birthday != null) 'birthday': contact.birthday!.toIso8601String(),
  if (contact.activeAddressId != null)
    'active_address_id': contact.activeAddressId,
  if (contact.updatedAt != null)
    'updated_at': contact.updatedAt!.toUtc().toIso8601String(),
  'addresses': contact.addresses.map(_encodeAddress).toList(growable: false),
};

ContactRecord _decodeContact(Map<String, Object?> json) {
  final id = json['id'];
  final kindName = json['kind'];
  final version = json['version'];
  final rawAddresses = json['addresses'];

  if (id is! int ||
      id < 1 ||
      kindName is! String ||
      version is! String ||
      !_isVersion(version) ||
      rawAddresses is! List<Object?>) {
    throw const FormatException('Invalid cached contact.');
  }

  final kind = ContactKind.values
      .where((candidate) => candidate.name == kindName)
      .firstOrNull;

  if (kind == null) {
    throw const FormatException('Invalid cached contact kind.');
  }

  final activeAddressId = _optionalInt(json, 'active_address_id');

  if (activeAddressId != null && activeAddressId < 1) {
    throw const FormatException('Invalid cached active address.');
  }

  return ContactRecord(
    id: id,
    kind: kind,
    version: version,
    name: _optionalString(json, 'name'),
    firstName: _optionalString(json, 'first_name'),
    lastName: _optionalString(json, 'last_name'),
    email: _optionalString(json, 'email'),
    salutation: _optionalString(json, 'salutation'),
    title: _optionalString(json, 'title'),
    gender: _optionalString(json, 'gender'),
    birthday: _optionalDateTime(json, 'birthday'),
    activeAddressId: activeAddressId,
    updatedAt: _optionalDateTime(json, 'updated_at'),
    addresses: rawAddresses
        .map((value) => _decodeAddress(_objectMap(value)))
        .toList(growable: false),
  );
}

Map<String, Object?> _encodeAddress(ContactAddress address) => {
  'id': address.id,
  if (address.type != null) 'type': address.type,
  if (address.line1 != null) 'line1': address.line1,
  if (address.line2 != null) 'line2': address.line2,
  if (address.postalCode != null) 'postal_code': address.postalCode,
  if (address.city != null) 'city': address.city,
  if (address.state != null) 'state': address.state,
  if (address.country != null) 'country': address.country,
};

ContactAddress _decodeAddress(Map<String, Object?> json) {
  final id = json['id'];

  if (id is! int || id < 1) {
    throw const FormatException('Invalid cached contact address.');
  }

  return ContactAddress(
    id: id,
    type: _optionalString(json, 'type'),
    line1: _optionalString(json, 'line1'),
    line2: _optionalString(json, 'line2'),
    postalCode: _optionalString(json, 'postal_code'),
    city: _optionalString(json, 'city'),
    state: _optionalString(json, 'state'),
    country: _optionalString(json, 'country'),
  );
}

Map<String, Object?> _objectMap(Object? value) {
  if (value is! Map<String, Object?>) {
    throw const FormatException('Invalid contact cache object.');
  }

  return value;
}

String? _optionalString(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value == null) {
    return null;
  }

  if (value is! String) {
    throw const FormatException('Invalid cached string.');
  }

  return value;
}

int? _optionalInt(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value == null) {
    return null;
  }

  if (value is! int) {
    throw const FormatException('Invalid cached integer.');
  }

  return value;
}

DateTime? _optionalDateTime(Map<String, Object?> json, String key) {
  final value = json[key];

  if (value == null) {
    return null;
  }

  if (value is! String) {
    throw const FormatException('Invalid cached timestamp.');
  }

  final parsed = DateTime.tryParse(value);

  if (parsed == null) {
    throw const FormatException('Invalid cached timestamp.');
  }

  return parsed;
}

DateTime _requiredDateTime(Map<String, Object?> json, String key) =>
    _optionalDateTime(json, key) ??
    (throw const FormatException('Missing cached timestamp.'));

bool _isUuid(String value) => RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
).hasMatch(value);

bool _isVersion(String value) => RegExp(r'^[a-f0-9]{64}$').hasMatch(value);
