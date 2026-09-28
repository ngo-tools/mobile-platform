import 'package:ngotools_api/ngotools_api.dart';

import 'events_failure.dart';
import 'events_repository.dart';

/// Identifies an availability request by event and service.
String availabilityKey(MobileEventAvailability request) =>
    '${request.event.id}-${request.service.id}';

/// Outcome of an optimistic answer.
final class AvailabilityAnswerResult {
  /// Creates an outcome.
  const AvailabilityAnswerResult({required this.request, this.failure});

  /// The request as confirmed by the server, or the original on failure.
  final MobileEventAvailability request;

  /// The failure, if the server rejected the change.
  final EventsFailureCode? failure;
}

/// Sends an answer or withdrawal and reports the confirmed state.
Future<AvailabilityAnswerResult> submitAvailability({
  required EventsRepository repository,
  required MobileEventAvailability request,
  required MobileAvailabilityStatus status,
}) async {
  try {
    if (status == MobileAvailabilityStatus.notSet) {
      await repository.withdraw(request);

      return AvailabilityAnswerResult(request: request.withStatus(status));
    }

    return AvailabilityAnswerResult(
      request: await repository.answer(request, status),
    );
  } on Object catch (error) {
    return AvailabilityAnswerResult(
      request: request,
      failure: eventsFailureFor(error),
    );
  }
}

/// Replaces the entry of [updated] in [requests].
List<MobileEventAvailability> replaceAvailability(
  List<MobileEventAvailability> requests,
  MobileEventAvailability updated,
) => requests
    .map(
      (request) => availabilityKey(request) == availabilityKey(updated)
          ? updated
          : request,
    )
    .toList(growable: false);
