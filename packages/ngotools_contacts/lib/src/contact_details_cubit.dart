import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ngotools_api/ngotools_api.dart';

import 'contact_models.dart';
import 'contacts_cubit.dart';
import 'contacts_repository.dart';

part 'contact_details_cubit.freezed.dart';

/// Observable lifecycle of one contact detail request.
enum ContactDetailsStatus { initial, loading, ready, failure }

/// Immutable state emitted by [ContactDetailsCubit].
@freezed
abstract class ContactDetailsState with _$ContactDetailsState {
  /// Creates sanitized detail state.
  const factory ContactDetailsState({
    @Default(ContactDetailsStatus.initial) ContactDetailsStatus status,
    ContactRecord? contact,
    @Default(ContactDataSource.remote) ContactDataSource source,
    DateTime? cachedAt,
    ContactsFailureCode? failure,
  }) = _ContactDetailsState;
}

/// Loads one contact detail projection and discards stale responses.
final class ContactDetailsCubit extends Cubit<ContactDetailsState> {
  /// Creates a contact-details Cubit.
  ContactDetailsCubit({
    required ContactsRepository repository,
    required int contactId,
  }) : _repository = repository,
       _contactId = _validateContactId(contactId),
       super(const ContactDetailsState());

  final ContactsRepository _repository;
  final int _contactId;
  int _requestGeneration = 0;

  static int _validateContactId(int contactId) {
    if (contactId < 1) {
      throw ArgumentError.value(
        contactId,
        'contactId',
        'Must be at least one.',
      );
    }

    return contactId;
  }

  /// Loads or reloads the contact details.
  Future<void> load() async {
    final requestGeneration = ++_requestGeneration;
    emit(const ContactDetailsState(status: ContactDetailsStatus.loading));

    try {
      final snapshot = await _repository.getById(_contactId);

      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        ContactDetailsState(
          status: ContactDetailsStatus.ready,
          contact: snapshot.contact,
          source: snapshot.source,
          cachedAt: snapshot.cachedAt,
        ),
      );
    } on Object catch (error) {
      if (requestGeneration != _requestGeneration || isClosed) {
        return;
      }

      emit(
        ContactDetailsState(
          status: ContactDetailsStatus.failure,
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
