/// Enforces fail-closed invariants for the generated release workflow.
abstract final class ReleaseWorkflowValidator {
  static final _action = RegExp(
    r'^\s*uses:\s*([^@\s]+)@([^\s]+)\s*$',
    multiLine: true,
  );
  static final _forbiddenTrigger = RegExp(
    r'^\s*(?:push|pull_request|pull_request_target|schedule|workflow_run):',
    multiLine: true,
  );

  /// Returns security violations in [source].
  static List<String> validate(String source) {
    final errors = <String>[];

    if (!source.contains('  workflow_dispatch:\n')) {
      errors.add('Release workflow must be manually dispatched.');
    }

    if (_forbiddenTrigger.hasMatch(source)) {
      errors.add('Release workflow must not have an automatic trigger.');
    }

    if (!source.contains('permissions:\n  actions: read\n  contents: read\n')) {
      errors.add('Release workflow must use read-only token permissions.');
    }

    if (RegExp(r'^\s+[a-z-]+:\s+write\s*$', multiLine: true).hasMatch(source)) {
      errors.add('Release workflow must not grant write token permissions.');
    }

    final actions = _action.allMatches(source).toList(growable: false);

    if (actions.isEmpty ||
        actions.any(
          (match) => !RegExp(r'^[0-9a-f]{40}$').hasMatch(match.group(2)!),
        )) {
      errors.add('Every release action must be pinned to a full commit SHA.');
    }

    final checkoutCount = actions
        .where((match) => match.group(1) == 'actions/checkout')
        .length;
    final nonPersistingCheckoutCount = RegExp(
      r'persist-credentials:\s*false',
    ).allMatches(source).length;

    if (checkoutCount == 0 || checkoutCount != nonPersistingCheckoutCount) {
      errors.add('Every release checkout must disable credential persistence.');
    }

    if (!source.contains(r'[[ "$SOURCE_REVISION" =~ ^[0-9a-f]{40}$ ]]') ||
        !source.contains('git merge-base --is-ancestor')) {
      errors.add('Release source must be an immutable default-branch commit.');
    }

    for (final environment in const {
      'mobile-production-android',
      'mobile-production-ios',
    }) {
      if (!source.contains('environment: $environment')) {
        errors.add('Release workflow must use the $environment environment.');
      }
    }

    if (!source.contains(
          '.type == "required_reviewers" and .prevent_self_review == true',
        ) ||
        !source.contains(
          '.deployment_branch_policy.protected_branches == true',
        )) {
      errors.add('Release environments must be verified as protected.');
    }

    final firstReleaseJob = source.indexOf('\n  release_android:');
    final firstSecret = source.indexOf(r'${{ secrets.');

    if (firstReleaseJob < 0 || firstSecret < firstReleaseJob) {
      errors.add('Protected secrets must not be available to preflight.');
    }

    if (source.contains('secrets: inherit')) {
      errors.add(
        'Release workflow must name each protected secret explicitly.',
      );
    }

    _requireOrder(
      source,
      'Request NGO.Tools release approval',
      'Upload approved artifact to Google Play',
      errors,
      'Android store upload must follow NGO.Tools approval.',
    );
    _requireOrder(
      source,
      'Request NGO.Tools release approval',
      'Upload approved artifact to TestFlight',
      errors,
      'iOS store upload must follow NGO.Tools approval.',
      start: source.indexOf('\n  release_ios:'),
    );

    if (!source.contains('if: always()') ||
        !source.contains(r'$RUNNER_TEMP/release.jks') ||
        !source.contains('security delete-keychain')) {
      errors.add('Release workflow must always remove signing material.');
    }

    if (!source.contains(r'path: ${{ runner.temp }}/release-provenance.json') ||
        source.contains('path: build/app/outputs') ||
        source.contains('path: build/ios/ipa')) {
      errors.add('Only public release provenance may be archived.');
    }

    return errors;
  }

  static void _requireOrder(
    String source,
    String first,
    String second,
    List<String> errors,
    String message, {
    int start = 0,
  }) {
    final firstIndex = source.indexOf(first, start);
    final secondIndex = source.indexOf(second, start);

    if (firstIndex < start || secondIndex < firstIndex) {
      errors.add(message);
    }
  }
}
