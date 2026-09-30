import 'dart:async';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:uuid/uuid.dart';

import 'generated/api/chat_api.dart';
import 'generated/api/contacts_api.dart';
import 'generated/api/events_api.dart';
import 'generated/api/runtime_api.dart';
import 'generated/model/chat_account.dart' as generated;
import 'generated/model/chat_person.dart' as generated;
import 'generated/model/chat_session.dart' as generated;
import 'generated/model/contact.dart' as generated;
import 'generated/model/contact_response.dart' as generated;
import 'generated/model/contact_search_request.dart' as generated;
import 'generated/model/contact_search_term.dart' as generated;
import 'generated/model/contact_sort.dart' as generated;
import 'generated/model/create_chat_session_request.dart' as generated;
import 'generated/model/create_contact_request.dart' as generated;
import 'generated/model/event_agenda_entry.dart' as generated;
import 'generated/model/event_agenda_sub_item.dart' as generated;
import 'generated/model/event_availability.dart' as generated;
import 'generated/model/event_person.dart' as generated;
import 'generated/model/event_reference.dart' as generated;
import 'generated/model/event_service_reference.dart' as generated;
import 'generated/model/event_summary.dart' as generated;
import 'generated/model/import_capability.dart' as generated;
import 'generated/model/update_contact_request.dart' as generated;
import 'generated/model/update_event_availability_request.dart' as generated;
import 'internal/mobile_api_interceptors.dart';
import 'mobile_api_problem.dart';
import 'mobile_chat.dart';
import 'mobile_contact.dart';
import 'mobile_events.dart';
import 'mobile_runtime_capabilities.dart';

/// Connects the protected authentication session to an HTTP client.
typedef MobileApiAuthorizer = void Function(Dio client);

/// Secure typed access to the NGO.Tools mobile runtime API.
final class NgoToolsMobileApi
    implements MobileContactsApi, MobileEventsApi, MobileChatApi {
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
    _eventsApi = EventsApi(_dio);
    _chatApi = ChatApi(_dio);
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
  late final EventsApi _eventsApi;
  late final ChatApi _chatApi;

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

  /// Lists visible events starting between the calendar days [from] and [to].
  @override
  Future<List<MobileEventSummary>> listEvents({DateTime? from, DateTime? to}) =>
      _guard(() async {
        if (from != null &&
            to != null &&
            _calendarDay(to).isBefore(_calendarDay(from))) {
          throw ArgumentError.value(to, 'to', 'Must not be before from.');
        }

        final response = await _eventsApi.listEvents(
          from: _formatDate(from),
          to: _formatDate(to),
        );
        final data = response.data;

        if (data == null) {
          throw _invalidResponse();
        }

        return data.data.map(_mapEventSummary).toList(growable: false);
      });

  /// Loads one visible event with its agenda and team.
  @override
  Future<MobileEventDetail> fetchEvent(int eventId) => _guard(() async {
    _requirePositive(eventId, 'eventId');

    final response = await _eventsApi.getEvent(eventId: eventId);
    final data = response.data?.data;

    if (data == null) {
      throw _invalidResponse();
    }

    final agenda = data.agenda;

    return MobileEventDetail(
      summary: _mapEventSummary(
        generated.EventSummary(
          id: data.id,
          name: data.name,
          type: data.type,
          start: data.start,
          end: data.end,
          allDay: data.allDay,
          planningCompleted: data.planningCompleted,
          myServices: data.myServices,
          availabilityOpen: data.availabilityOpen,
        ),
      ),
      details: data.details,
      agenda: agenda == null
          ? null
          : MobileEventAgenda(
              completed: agenda.completed,
              entries: agenda.items.map(_mapAgendaEntry),
            ),
      team: data.team.map((slot) {
        if (slot.required_ < 0 || slot.open < 0) {
          throw _invalidResponse();
        }

        return MobileEventTeamSlot(
          service: _mapService(slot.service),
          required: slot.required_,
          open: slot.open,
          members: slot.members.map(_mapPerson),
        );
      }),
    );
  });

  /// Lists the user's own assignments for today and upcoming events.
  @override
  Future<List<MobileEventAssignment>> listEventAssignments() =>
      _guard(() async {
        final response = await _eventsApi.listEventAssignments();
        final data = response.data;

        if (data == null) {
          throw _invalidResponse();
        }

        return data.data
            .map((assignment) {
              _requireValidId(assignment.id);

              return MobileEventAssignment(
                id: assignment.id,
                event: _mapEventReference(assignment.event),
                service: _mapService(assignment.service),
              );
            })
            .toList(growable: false);
      });

  /// Lists upcoming availability requests with the current answer.
  @override
  Future<List<MobileEventAvailability>> listEventAvailabilities() =>
      _guard(() async {
        final response = await _eventsApi.listEventAvailabilities();
        final data = response.data;

        if (data == null) {
          throw _invalidResponse();
        }

        return data.data.map(_mapAvailability).toList(growable: false);
      });

  /// Stores the user's answer for [serviceId] of the upcoming [eventId].
  @override
  Future<MobileEventAvailability> answerEventAvailability({
    required int eventId,
    required int serviceId,
    required MobileAvailabilityStatus status,
  }) => _guard(() async {
    _requirePositive(eventId, 'eventId');
    _requirePositive(serviceId, 'serviceId');

    final response = await _eventsApi.updateEventAvailability(
      eventId: eventId,
      serviceId: serviceId,
      updateEventAvailabilityRequest: generated.UpdateEventAvailabilityRequest(
        status: switch (status) {
          MobileAvailabilityStatus.available =>
            generated.UpdateEventAvailabilityRequestStatusEnum.available,
          MobileAvailabilityStatus.ifNeedsMust =>
            generated.UpdateEventAvailabilityRequestStatusEnum.ifNeedsMust,
          MobileAvailabilityStatus.notAvailable =>
            generated.UpdateEventAvailabilityRequestStatusEnum.notAvailable,
          MobileAvailabilityStatus.notSet => throw ArgumentError.value(
            status,
            'status',
            'Use withdrawEventAvailability to remove an answer.',
          ),
        },
      ),
    );
    final data = response.data?.data;

    if (data == null) {
      throw _invalidResponse();
    }

    return _mapAvailability(data);
  });

  /// Withdraws the user's answer for [serviceId] of the upcoming [eventId].
  @override
  Future<void> withdrawEventAvailability({
    required int eventId,
    required int serviceId,
  }) => _guard(() async {
    _requirePositive(eventId, 'eventId');
    _requirePositive(serviceId, 'serviceId');

    await _eventsApi.deleteEventAvailability(
      eventId: eventId,
      serviceId: serviceId,
    );
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

  /// Loads the user's chat account and the organization's homeserver.
  @override
  Future<MobileChatAccount> fetchChatAccount() => _guard(() async {
    final account = (await _chatApi.getChatAccount()).data?.data;

    if (account == null) {
      throw _invalidResponse();
    }

    final homeserverUrl = account.homeserverUrl;

    return MobileChatAccount(
      status: switch (account.status) {
        generated.ChatAccountStatusEnum.active =>
          MobileChatAccountStatus.active,
        generated.ChatAccountStatusEnum.locked =>
          MobileChatAccountStatus.locked,
        generated.ChatAccountStatusEnum.deactivated =>
          MobileChatAccountStatus.deactivated,
        generated.ChatAccountStatusEnum.none => MobileChatAccountStatus.none,
        generated.ChatAccountStatusEnum.unknownDefaultOpenApi =>
          throw _invalidResponse(),
      },
      available: account.available,
      matrixUserId: account.matrixUserId,
      serverName: account.serverName,
      homeserverUrl: homeserverUrl == null
          ? null
          : _homeserverUrl(homeserverUrl),
    );
  });

  /// Lists the organization's chat address book without the user.
  @override
  Future<MobileChatPeoplePage> listChatPeople({
    String? search,
    int page = 1,
    int perPage = 50,
  }) => _guard(() async {
    _requirePositive(page, 'page');

    if (perPage < 1 || perPage > 100) {
      throw ArgumentError.value(
        perPage,
        'perPage',
        'Must be between one and 100.',
      );
    }

    final normalizedSearch = search?.trim();
    final data = (await _chatApi.listChatPeople(
      search: normalizedSearch == null || normalizedSearch.isEmpty
          ? null
          : normalizedSearch,
      page: page,
      perPage: perPage,
    )).data;

    if (data == null) {
      throw _invalidResponse();
    }

    final meta = data.meta;
    final lastPage = meta.lastPage ?? meta.currentPage;

    if (meta.currentPage < 1 || lastPage < 1 || meta.total < 0) {
      throw _invalidResponse();
    }

    return MobileChatPeoplePage(
      people: data.data.map(_mapChatPerson),
      page: meta.currentPage,
      lastPage: lastPage,
      total: meta.total,
    );
  });

  /// Signs the app into the chat in the background.
  @override
  Future<MobileChatSession> createChatSession({String? deviceName}) =>
      _guard(() async {
        final normalizedName = deviceName?.trim();

        if (normalizedName != null && normalizedName.length > 100) {
          throw ArgumentError.value(
            deviceName,
            'deviceName',
            'Must be at most 100 characters.',
          );
        }

        final response = await _chatApi.createChatSession(
          createChatSessionRequest: generated.CreateChatSessionRequest(
            deviceName: normalizedName == null || normalizedName.isEmpty
                ? null
                : normalizedName,
          ),
        );

        return _mapChatSession(response.data?.data);
      });

  /// Renews the access token of the current chat session.
  @override
  Future<MobileChatSession> renewChatSession() => _guard(
    () async => _mapChatSession((await _chatApi.renewChatSession()).data?.data),
  );

  /// Ends the chat session of the current API token.
  @override
  Future<void> deleteChatSession() =>
      _guard(() async => _chatApi.deleteChatSession());

  static MobileChatPerson _mapChatPerson(generated.ChatPerson person) =>
      MobileChatPerson(
        matrixUserId: _requireMatrixUserId(person.matrixUserId),
        displayName: person.displayName,
        kind: switch (person.kind) {
          generated.ChatPersonKindEnum.teamMember =>
            MobileChatPersonKind.teamMember,
          generated.ChatPersonKindEnum.contact => MobileChatPersonKind.contact,
          generated.ChatPersonKindEnum.unknownDefaultOpenApi =>
            throw _invalidResponse(),
        },
      );

  static MobileChatSession _mapChatSession(generated.ChatSession? session) {
    if (session == null ||
        session.accessToken.isEmpty ||
        session.deviceId.isEmpty) {
      throw _invalidResponse();
    }

    return MobileChatSession(
      matrixUserId: _requireMatrixUserId(session.matrixUserId),
      deviceId: session.deviceId,
      accessToken: session.accessToken,
      expiresAt: session.expiresAt,
      homeserverUrl: _homeserverUrl(session.homeserverUrl),
      serverName: session.serverName,
    );
  }

  static String _requireMatrixUserId(String value) {
    if (!RegExp(r'^@[^:\s]+:[^\s]+$').hasMatch(value)) {
      throw _invalidResponse();
    }

    return value;
  }

  /// Only HTTPS origins; the chat client sends the access token there.
  static Uri _homeserverUrl(String value) {
    final uri = Uri.tryParse(value);

    if (uri == null ||
        uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      throw _invalidResponse();
    }

    return uri;
  }

  static MobileEventSummary _mapEventSummary(generated.EventSummary event) {
    _requireValidId(event.id);

    final type = event.type;

    if (type != null) {
      _requireValidId(type.id);
    }

    return MobileEventSummary(
      id: event.id,
      name: event.name,
      type: type == null ? null : MobileEventType(id: type.id, name: type.name),
      start: event.start,
      end: event.end,
      allDay: event.allDay,
      planningCompleted: event.planningCompleted,
      myServices: event.myServices.map(_mapService),
      availabilityOpen: event.availabilityOpen,
    );
  }

  static MobileEventReference _mapEventReference(
    generated.EventReference event,
  ) {
    _requireValidId(event.id);

    return MobileEventReference(
      id: event.id,
      name: event.name,
      start: event.start,
      end: event.end,
      allDay: event.allDay,
    );
  }

  static MobileEventService _mapService(
    generated.EventServiceReference service,
  ) {
    _requireValidId(service.id);

    return MobileEventService(id: service.id, name: service.name);
  }

  static MobileEventPerson _mapPerson(generated.EventPerson person) =>
      MobileEventPerson(name: person.name, isMe: person.isMe);

  static MobileEventAgendaEntry _mapAgendaEntry(
    generated.EventAgendaEntry entry,
  ) {
    final responsibleService = entry.responsibleService;

    if (entry.durationMinutes != null && entry.durationMinutes! < 0) {
      throw _invalidResponse();
    }

    return MobileEventAgendaEntry(
      item: _mapAgendaItem(
        generated.EventAgendaSubItem(
          id: entry.id,
          type: entry.type,
          name: entry.name,
          key: entry.key,
          language: entry.language,
          items: entry.items,
        ),
      ),
      startsAt: entry.startsAt,
      durationMinutes: entry.durationMinutes,
      responsibleService: responsibleService == null
          ? null
          : _mapService(responsibleService),
      responsible: entry.responsible.map(_mapPerson),
      isMine: entry.isMine,
    );
  }

  static MobileEventAgendaItem _mapAgendaItem(
    generated.EventAgendaSubItem item,
  ) {
    _requireValidId(item.id);

    return MobileEventAgendaItem(
      id: item.id,
      type: item.type,
      name: item.name,
      key: item.key,
      language: item.language,
      children: item.items.map(_mapAgendaItem),
    );
  }

  static MobileEventAvailability _mapAvailability(
    generated.EventAvailability availability,
  ) => MobileEventAvailability(
    event: _mapEventReference(availability.event),
    service: _mapService(availability.service),
    status: switch (availability.status) {
      generated.EventAvailabilityStatusEnum.available =>
        MobileAvailabilityStatus.available,
      generated.EventAvailabilityStatusEnum.ifNeedsMust =>
        MobileAvailabilityStatus.ifNeedsMust,
      generated.EventAvailabilityStatusEnum.notAvailable =>
        MobileAvailabilityStatus.notAvailable,
      generated.EventAvailabilityStatusEnum.notSet =>
        MobileAvailabilityStatus.notSet,
      generated.EventAvailabilityStatusEnum.unknownDefaultOpenApi =>
        throw _invalidResponse(),
    },
  );

  static void _requireValidId(int id) {
    if (id < 1) {
      throw _invalidResponse();
    }
  }

  static void _requirePositive(int value, String name) {
    if (value < 1) {
      throw ArgumentError.value(value, name, 'Must be at least one.');
    }
  }

  static DateTime _calendarDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

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
