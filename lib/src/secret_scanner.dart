/// Scans repository paths and text for production credential material.
abstract final class SecretScanner {
  static final _forbiddenExtensions = RegExp(
    r'\.(?:jks|keystore|mobileprovision|p12|p8|pem)$',
    caseSensitive: false,
  );

  static final _contentPatterns = <String, RegExp>{
    'private key': RegExp(
      '-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE'
      ' KEY-----',
    ),
    'GitHub token': RegExp(r'\b(?:ghp|github_pat)_[A-Za-z0-9_]{20,}\b'),
    'AWS access key': RegExp(r'\bAKIA[0-9A-Z]{16}\b'),
    'Google API key': RegExp(r'\bAIza[0-9A-Za-z_-]{35}\b'),
  };

  /// Returns secret violations for [files], keyed by repository-relative path.
  static List<String> validate(Map<String, String> files) {
    final errors = <String>[];

    for (final entry in files.entries) {
      if (_forbiddenExtensions.hasMatch(entry.key)) {
        errors.add('${entry.key}: forbidden credential file type.');
      }

      for (final pattern in _contentPatterns.entries) {
        if (pattern.value.hasMatch(entry.value)) {
          errors.add('${entry.key}: possible ${pattern.key}.');
        }
      }

      if (entry.value.contains(
            '"type": "service'
            '_account"',
          ) &&
          entry.value.contains(
            '"private'
            '_key"',
          )) {
        errors.add('${entry.key}: possible Google service-account credential.');
      }
    }

    return errors;
  }
}
