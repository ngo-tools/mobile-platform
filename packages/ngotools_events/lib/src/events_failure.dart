import 'package:ngotools_api/ngotools_api.dart';

/// Stable failures safe to expose to event user interfaces.
enum EventsFailureCode {
  /// The session expired.
  unauthenticated,

  /// The account may not perform the operation, e.g. a read-only token.
  forbidden,

  /// The event is no longer visible.
  notFound,

  /// The request cannot be accepted, e.g. the event already started.
  rejected,

  /// The device could not reach NGO.Tools.
  network,

  /// The server sent an unexpected response.
  invalidResponse,

  /// Anything else.
  unknown,
}

/// Maps [error] to a failure code without leaking transport details.
EventsFailureCode eventsFailureFor(Object error) {
  if (error is! MobileApiException) {
    return EventsFailureCode.unknown;
  }

  return switch (error.problem.status) {
    401 => EventsFailureCode.unauthenticated,
    403 => EventsFailureCode.forbidden,
    404 => EventsFailureCode.notFound,
    422 => EventsFailureCode.rejected,
    _ => switch (error.problem.code) {
      'network_error' => EventsFailureCode.network,
      'invalid_response' => EventsFailureCode.invalidResponse,
      _ => EventsFailureCode.unknown,
    },
  };
}
