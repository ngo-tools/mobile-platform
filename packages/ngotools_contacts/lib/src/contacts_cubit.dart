import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ngotools_api/ngotools_api.dart';

import 'contact_models.dart';
import 'contacts_repository.dart';

part 'contacts_cubit.freezed.dart';

/// Observable lifecycle of the contact list.
enum ContactsStatus { initial, loading, ready, loadingMore, empty, failure }

/// Stable failures safe to expose to contact user interfaces.
enum ContactsFailureCode {
  unauthenticated,
  forbidden,
  notFound,
  network,
  invalidResponse,
  unavailable,
  unknown,
}

/// Immutable state emitted by [ContactsCubit].
@freezed
abstract class ContactsState with _$ContactsState {
  const ContactsState._();

  /// Creates contact-list state without transport error details.
  const factory ContactsState({
    @Default(ContactsStatus.initial) ContactsStatus status,
    @Default(<ContactRecord>[]) List<ContactRecord> contacts,
    @Default('') String query,
    @Default(ContactsSort.lastName) ContactsSort sort,
    @Default(1) int page,
    @Default(25) int perPage,
    @Default(0) int total,
    @Default(1) int lastPage,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
    ContactsFailureCode? failure,
  }) = _ContactsState;

  /// Whether the next server page can be requested.
  bool get hasNextPage => page < lastPage;
}

/// Coordinates contact searches while discarding stale responses.
final class ContactsCubit extends Cubit<ContactsState> {
  /// Creates a contact-list Cubit.
  ContactsCubit({required ContactsRepository repository, int perPage = 25})
    : _repository = repository,
      super(ContactsState(perPage: _validatePerPage(perPage)));

  final ContactsRepository _repository;
  int _requestGeneration = 0;

  static int _validatePerPage(int perPage) {
    if (perPage < 1 || perPage > 100) {
      throw ArgumentError.value(
        perPage,
        'perPage',
        'Must be between one and 100.',
      );
    }

    return perPage;
  }

  /// Loads the first page using the current query and sort.
  Future<void> load() => _loadFirstPage(query: state.query, sort: state.sort);

  /// Searches from the first page and ignores older in-flight responses.
  Future<void> search(String query) =>
      _loadFirstPage(query: query.trim(), sort: state.sort);

  /// Applies [sort] and reloads the first page.
  Future<void> changeSort(ContactsSort sort) =>
      _loadFirstPage(query: state.query, sort: sort);

  /// Retries the current query after a failed request.
  Future<void> retry() => state.contacts.isEmpty ? load() : loadMore();

  /// Appends the next page when one is available.
  Future<void> loadMore() async {
    if (!state.hasNextPage ||
        state.status == ContactsStatus.loading ||
        state.status == ContactsStatus.loadingMore) {
      return;
    }

    final requestGeneration = ++_requestGeneration;
    final previous = state;
    emit(previous.copyWith(status: ContactsStatus.loadingMore, failure: null));

    try {
      final result = await _repository.search(
        ContactSearch(
          query: previous.query,
          sort: previous.sort,
          page: previous.page + 1,
          perPage: previous.perPage,
        ),
      );

      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        previous.copyWith(
          status: ContactsStatus.ready,
          contacts: [...previous.contacts, ...result.items],
          page: result.page,
          total: result.total,
          lastPage: result.lastPage,
          source: result.source,
          cachedAt: result.cachedAt,
          failure: null,
        ),
      );
    } on Object catch (error) {
      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        previous.copyWith(
          status: ContactsStatus.failure,
          failure: _failureFor(error),
        ),
      );
    }
  }

  Future<void> _loadFirstPage({
    required String query,
    required ContactsSort sort,
  }) async {
    final requestGeneration = ++_requestGeneration;
    emit(
      ContactsState(
        status: ContactsStatus.loading,
        query: query,
        sort: sort,
        perPage: state.perPage,
      ),
    );

    try {
      final result = await _repository.search(
        ContactSearch(query: query, sort: sort, perPage: state.perPage),
      );

      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        ContactsState(
          status: result.items.isEmpty
              ? ContactsStatus.empty
              : ContactsStatus.ready,
          contacts: result.items,
          query: query,
          sort: sort,
          page: result.page,
          perPage: result.perPage,
          total: result.total,
          lastPage: result.lastPage,
          source: result.source,
          cachedAt: result.cachedAt,
        ),
      );
    } on Object catch (error) {
      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        ContactsState(
          status: ContactsStatus.failure,
          query: query,
          sort: sort,
          perPage: state.perPage,
          failure: _failureFor(error),
        ),
      );
    }
  }

  static ContactsFailureCode _failureFor(Object error) {
    if (error is! MobileApiException) {
      return ContactsFailureCode.unknown;
    }

    return switch (error.problem.status) {
      401 => ContactsFailureCode.unauthenticated,
      403 => ContactsFailureCode.forbidden,
      404 => ContactsFailureCode.notFound,
      _ => switch (error.problem.code) {
        'network_error' => ContactsFailureCode.network,
        'invalid_response' => ContactsFailureCode.invalidResponse,
        'feature_disabled' ||
        'permission_denied' => ContactsFailureCode.unavailable,
        _ => ContactsFailureCode.unknown,
      },
    };
  }
}
