/// A sanitized RFC 9457-style API problem exposed to application code.
final class MobileApiProblem {
  /// Creates an API problem without retaining raw server responses.
  MobileApiProblem({
    required this.code,
    required this.title,
    required this.status,
    this.type,
    this.detail,
    this.instance,
    this.requestId,
    this.retryAfter,
    this.retriable = false,
    Map<String, List<String>> validationErrors = const {},
  }) : validationErrors = Map.unmodifiable(
         validationErrors.map(
           (field, messages) =>
               MapEntry(field, List<String>.unmodifiable(messages)),
         ),
       );

  /// Stable machine-readable problem code.
  final String code;

  /// Human-readable summary safe to show in the user interface.
  final String title;

  /// HTTP status, or zero when no response was received.
  final int status;

  /// Optional RFC 9457 problem type URI.
  final Uri? type;

  /// Optional detail received for a non-server error.
  final String? detail;

  /// Optional RFC 9457 occurrence identifier.
  final Uri? instance;

  /// Safe request identifier used for support diagnostics.
  final String? requestId;

  /// Server-requested delay before a later retry.
  final Duration? retryAfter;

  /// Whether retrying later may succeed.
  final bool retriable;

  /// Field-level validation messages, without the raw response payload.
  final Map<String, List<String>> validationErrors;

  @override
  String toString() =>
      'MobileApiProblem(code: $code, status: $status, requestId: $requestId)';
}

/// Exception carrying a sanitized [MobileApiProblem].
final class MobileApiException implements Exception {
  /// Creates an API exception.
  const MobileApiException(this.problem);

  /// The sanitized problem safe for application code.
  final MobileApiProblem problem;

  @override
  String toString() => problem.toString();
}
