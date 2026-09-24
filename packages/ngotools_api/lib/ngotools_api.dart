/// Stable API contracts for NGO.Tools mobile apps.
library;

/// A semantic NGO.Tools API contract version.
class MobileContractVersion implements Comparable<MobileContractVersion> {
  /// Creates a semantic API contract version.
  const MobileContractVersion(this.major, this.minor, this.patch);

  /// Parses a `major.minor.patch` contract version.
  factory MobileContractVersion.parse(String value) {
    final parts = value.split('.');

    if (parts.length != 3) {
      throw FormatException('Invalid contract version.', value);
    }

    final numbers = parts.map(int.tryParse).toList(growable: false);

    if (numbers.any((number) => number == null)) {
      throw FormatException('Invalid contract version.', value);
    }

    return MobileContractVersion(numbers[0]!, numbers[1]!, numbers[2]!);
  }

  /// Major contract version.
  final int major;

  /// Minor contract version.
  final int minor;

  /// Patch contract version.
  final int patch;

  @override
  int compareTo(MobileContractVersion other) {
    final majorComparison = major.compareTo(other.major);

    if (majorComparison != 0) {
      return majorComparison;
    }

    final minorComparison = minor.compareTo(other.minor);

    if (minorComparison != 0) {
      return minorComparison;
    }

    return patch.compareTo(other.patch);
  }

  @override
  String toString() => '$major.$minor.$patch';
}

/// A sanitized RFC 9457-style API problem exposed to application code.
class MobileApiProblem {
  /// Creates an API problem without raw server responses.
  const MobileApiProblem({
    required this.code,
    required this.title,
    required this.status,
    this.requestId,
  });

  /// Stable machine-readable problem code.
  final String code;

  /// Localized human-readable title.
  final String title;

  /// HTTP status associated with the problem.
  final int status;

  /// Safe request identifier used for support diagnostics.
  final String? requestId;
}
