import 'dart:async';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:uuid/uuid.dart';

import 'generated/api/contacts_api.dart';
import 'generated/api/runtime_api.dart';
import 'generated/model/contact.dart' as generated;
import 'generated/model/contact_response.dart' as generated;
import 'generated/model/contact_search_request.dart' as generated;
import 'generated/model/contact_search_term.dart' as generated;
import 'generated/model/contact_sort.dart' as generated;
import 'generated/model/create_contact_request.dart' as generated;
import 'generated/model/import_capability.dart' as generated;
import 'generated/model/update_contact_request.dart' as generated;
import 'internal/mobile_api_interceptors.dart';
import 'mobile_api_problem.dart';
import 'mobile_contact.dart';
import 'mobile_runtime_capabilities.dart';

/// Connects the protected authentication session to an HTTP client.
typedef MobileApiAuthorizer = void Function(Dio client);

/// Secure typed access to the NGO.Tools mobile runtime API.
final class NgoToolsMobileApi implements MobileContactsApi {
  /// Creates the production API pipeline for one fixed environment.
  factory NgoToolsMobileApi({
    required MobileEnvironmentConfiguration environment,
    required MobileApiAuthorizer authorize,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    _validateBaseUrl(environment.apiBaseUrl);

    final dio = Dio(
      BaseOptions(
        baseUrl: environment.apiBaseUrl.origin,
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );
    authorize(dio);

    return NgoToolsMobileApi.testing(dio: dio);
  }

  /// Creates an API pipeline around a controlled HTTP client.
  @visibleForTesting
  NgoToolsMobileApi.testing({
    required Dio dio,
    String Function()? requestId,
    StreamController<void>? capabilityInvalidations,
  }) : _dio = dio,
       _capabilityInvalidations =
           capabilityInvalidations ?? StreamController<void>.broadcast() {
    _runtimeApi = RuntimeApi(_dio);
    _contactsApi = ContactsApi(_dio);
    _dio.interceptors.addAll([
      MobileRequestMetadataInterceptor(requestId ?? () => const Uuid().v4()),
      MobileReadRetryInterceptor(_dio),
      MobileProblemInterceptor(_capabilityInvalidations),
    ]);
  }

  final Dio _dio;
  final StreamController<void> _capabilityInvalidations;
  late final RuntimeApi _runtimeApi;
  late final ContactsApi _contactsApi;

  /// Emits whenever a denied request may indicate changed server access.
  Stream<void> get capabilityInvalidations => _capabilityInvalidations.stream;

  /// Loads effective features, permissions, and import capabilities.
  Future<MobileRuntimeCapabilities> fetchCapabilities() async {
    try {
      final currentUserRequest = _runtimeApi.getCurrentUser(
        extra: const {capabilityRefreshExtra: true},
      );
      final capabilitiesRequest = _runtimeApi.getCapabilities(
        extra: const {capabilityRefreshExtra: true},
      );
      final responses = await (currentUserRequest, capabilitiesRequest).wait;
      final currentUser = responses.$1.data;
      final capabilities = responses.$2.data;

      if (currentUser == null || capabilities == null) {
        throw MobileApiException(
          MobileApiProblem(
            code: 'invalid_response',
            title: 'Invalid server response',
            status: 0,
          ),
        );
      }

      final runtime = capabilities.data;

      return MobileRuntimeCapabilities(
        schemaVersion: runtime.schemaVersion,
        features: runtime.features,
        permissions: currentUser.permissions,
        importsEnabled: runtime.imports.enabled,
        importTypes: runtime.imports.types.map(
          (key, capability) =>
              MapEntry(key, _mapImportCapability(key, capability)),
        ),
      );
    } on DioException catch (error) {
      final normalized = error.error;

      if (normalized is MobileApiException) {
        throw normalized;
      }

      throw MobileApiException(MobileApiProblemParser.fromDio(error));
    } on MobileApiException {
      rethrow;
    } on Object {
      throw MobileApiException(
        MobileApiProblem(
          code: 'invalid_response',
          title: 'Invalid server response',
          status: 0,
        ),
      );
    }
  }

  /// Searches the server-authorized contact projection.
  @override
  Future<MobileContactPage> searchContacts({
    String? query,
    int page = 1,
    int perPage = 25,
    List<MobileContactSort> sort = const [
      MobileContactSort(field: MobileContactSortField.lastName),
      MobileContactSort(field: MobileContactSortField.id),
    ],
  }) => _guard(() async {
    if (page < 1) {
      throw ArgumentError.value(page, 'page', 'Must be at least one.');
    }

    if (perPage < 1 || perPage > 100) {
      throw ArgumentError.value(
        perPage,
        'perPage',
        'Must be between one and 100.',
      );
    }

    if (sort.length > 2) {
      throw ArgumentError.value(sort, 'sort', 'At most two sorts are allowed.');
    }

    final normalizedQuery = query?.trim();
    final response = await _contactsApi.searchContacts(
      contactSearchRequest: generated.ContactSearchRequest(
        search: normalizedQuery == null || normalizedQuery.isEmpty
            ? null
            : generated.ContactSearchTerm(value: normalizedQuery),
        sort: sort.map(_mapSort).toList(growable: false),
      ),
      page: page,
      limit: perPage,
    );
    final data = response.data;

    if (data == null) {
      throw _invalidResponse();
    }

    final meta = data.meta;

    if (meta != null &&
        (meta.currentPage < 1 ||
            meta.perPage < 1 ||
            meta.total < 0 ||
            (meta.lastPage != null && meta.lastPage! < 1))) {
      throw _invalidResponse();
    }

    final total = meta?.total ?? data.data.length;
    final resolvedPerPage = meta?.perPage ?? perPage;
    final lastPage =
        meta?.lastPage ?? (total == 0 ? 1 : (total / resolvedPerPage).ceil());

    return MobileContactPage(
      items: data.data.map(_mapContact),
      page: meta?.currentPage ?? page,
      perPage: resolvedPerPage,
      total: total,
      lastPage: lastPage,
    );
  });

  /// Loads one contact with its server-visible addresses.
  @override
  Future<MobileContact> fetchContact(int contactId) => _guard(() async {
    if (contactId < 1) {
      throw ArgumentError.value(
        contactId,
        'contactId',
        'Must be at least one.',
      );
    }

    final response = await _contactsApi.getContact(contactId: contactId);
    final data = response.data;

    if (data == null) {
      throw _invalidResponse();
    }

    return _mapContact(data.data);
  });

  /// Creates one contact through the idempotent mutation boundary.
  @override
  Future<MobileContactMutationResult> createContact({
    required String idempotencyKey,
    required MobileContactMutation contact,
  }) => _mutationGuard(() async {
    final response = await _contactsApi.createContact(
      idempotencyKey: _requireIdempotencyKey(idempotencyKey),
      createContactRequest: generated.CreateContactRequest(
        type: switch (contact.kind) {
          MobileWritableContactKind.person =>
            generated.CreateContactRequestTypeEnum.person,
          MobileWritableContactKind.organization =>
            generated.CreateContactRequestTypeEnum.organization,
        },
        name: contact.name,
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        salutation: contact.salutation,
        title: contact.title,
        gender: contact.gender,
        birthday: _formatDate(contact.birthday),
      ),
    );

    return _mapMutationResponse(response);
  });

  /// Updates one contact from its exact opaque version.
  @override
  Future<MobileContactMutationResult> updateContact({
    required int contactId,
    required String idempotencyKey,
    required String baseVersion,
    required MobileContactMutation contact,
  }) => _mutationGuard(() async {
    if (contactId < 1) {
      throw ArgumentError.value(
        contactId,
        'contactId',
        'Must be at least one.',
      );
    }

    if (!_isContactVersion(baseVersion)) {
      throw ArgumentError.value(
        baseVersion,
        'baseVersion',
        'Must be an opaque 64-character lowercase hex value.',
      );
    }

    final response = await _contactsApi.updateContact(
      contactId: contactId,
      idempotencyKey: _requireIdempotencyKey(idempotencyKey),
      updateContactRequest: generated.UpdateContactRequest(
        baseVersion: baseVersion,
        name: contact.name,
        firstName: contact.firstName,
        lastName: contact.lastName,
        email: contact.email,
        salutation: contact.salutation,
        title: contact.title,
        gender: contact.gender,
        birthday: _formatDate(contact.birthday),
      ),
    );

    return _mapMutationResponse(response);
  });

  /// Releases HTTP and stream resources owned by this client.
  Future<void> close() async {
    _dio.close(force: true);
    await _capabilityInvalidations.close();
  }

  static MobileImportCapability _mapImportCapability(
    String key,
    generated.ImportCapability capability,
  ) => MobileImportCapability(
    key: key,
    label: capability.label,
    supported: capability.supported,
    requiredFeature: capability.requiredFeature,
    featureEnabled: capability.featureEnabled,
    permissionGranted: capability.permissionGranted,
    available: capability.available,
    requires: capability.requires,
    batchImportSupported: capability.batchImportSupported,
    blockers: capability.blockers
        .map(
          (blocker) => MobileCapabilityBlocker(
            code: blocker.code,
            message: blocker.message,
          ),
        )
        .toList(growable: false),
    maxBatchSize: capability.limits?.maxBatchSize,
  );

  static generated.ContactSort _mapSort(MobileContactSort sort) =>
      generated.ContactSort(
        field: switch (sort.field) {
          MobileContactSortField.name => generated.ContactSortFieldEnum.name,
          MobileContactSortField.firstName =>
            generated.ContactSortFieldEnum.firstName,
          MobileContactSortField.lastName =>
            generated.ContactSortFieldEnum.lastName,
          MobileContactSortField.updatedAt =>
            generated.ContactSortFieldEnum.updatedAt,
          MobileContactSortField.createdAt =>
            generated.ContactSortFieldEnum.createdAt,
          MobileContactSortField.id => generated.ContactSortFieldEnum.id,
        },
        direction: switch (sort.direction) {
          MobileContactSortDirection.ascending =>
            generated.ContactSortDirectionEnum.asc,
          MobileContactSortDirection.descending =>
            generated.ContactSortDirectionEnum.desc,
        },
      );

  static MobileContact _mapContact(generated.Contact contact) {
    if (contact.id < 1 ||
        !_isContactVersion(contact.version) ||
        (contact.activeAddressId != null && contact.activeAddressId! < 1) ||
        (contact.addresses?.any((address) => address.id < 1) ?? false)) {
      throw _invalidResponse();
    }

    return MobileContact(
      id: contact.id,
      kind: switch (contact.type) {
        'person' => MobileContactKind.person,
        'organization' => MobileContactKind.organization,
        'couple' => MobileContactKind.couple,
        _ => MobileContactKind.unknown,
      },
      version: contact.version,
      name: contact.name,
      firstName: contact.firstName,
      lastName: contact.lastName,
      email: contact.email,
      salutation: contact.salutation,
      title: contact.title,
      gender: contact.gender,
      birthday: contact.birthday,
      activeAddressId: contact.activeAddressId,
      updatedAt: contact.updatedAt,
      addresses:
          contact.addresses?.map(
            (address) => MobileContactAddress(
              id: address.id,
              type: address.type,
              line1: address.line1,
              line2: address.line2,
              postalCode: address.postalCode,
              city: address.city,
              state: address.state,
              country: address.country,
            ),
          ) ??
          const [],
    );
  }

  static MobileContactMutationSuccess _mapMutationResponse(
    Response<generated.ContactResponse> response,
  ) {
    final data = response.data;
    final replayed = switch (response.headers.value('idempotency-replayed')) {
      'true' => true,
      'false' => false,
      _ => throw _invalidResponse(),
    };

    if (data == null) {
      throw _invalidResponse();
    }

    return MobileContactMutationSuccess(
      contact: _mapContact(data.data),
      replayed: replayed,
    );
  }

  Future<MobileContactMutationResult> _mutationGuard(
    Future<MobileContactMutationSuccess> Function() operation,
  ) async {
    try {
      return await _guard(operation);
    } on MobileApiException catch (error) {
      if (error.problem.status == 409 &&
          error.problem.code == 'contact_version_conflict') {
        return const MobileContactVersionConflict();
      }

      rethrow;
    }
  }

  static String _requireIdempotencyKey(String value) {
    final normalized = value.trim();
    final uuid = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-8][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );

    if (!uuid.hasMatch(normalized)) {
      throw ArgumentError.value(
        value,
        'idempotencyKey',
        'Must be an RFC 9562 UUID.',
      );
    }

    return normalized;
  }

  static bool _isContactVersion(String value) =>
      RegExp(r'^[a-f0-9]{64}$').hasMatch(value);

  static String? _formatDate(DateTime? value) {
    if (value == null) {
      return null;
    }

    final year = value.year.toString().padLeft(4, '0');
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');

    return '$year-$month-$day';
  }

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioException catch (error) {
      final normalized = error.error;

      if (normalized is MobileApiException) {
        throw normalized;
      }

      throw MobileApiException(MobileApiProblemParser.fromDio(error));
    } on MobileApiException {
      rethrow;
    }
  }

  static MobileApiException _invalidResponse() => MobileApiException(
    MobileApiProblem(
      code: 'invalid_response',
      title: 'Invalid server response',
      status: 0,
    ),
  );

  static void _validateBaseUrl(Uri uri) {
    if (uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      throw ArgumentError.value(
        uri,
        'environment.apiBaseUrl',
        'The API base URL must be a fixed HTTPS origin.',
      );
    }
  }
}
