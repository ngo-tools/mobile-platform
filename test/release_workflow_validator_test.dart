import 'dart:io';

import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {
  late String workflow;

  setUpAll(() async {
    workflow = await File(
      path.join(
        Directory.current.path,
        'example',
        'golden_app',
        '.github',
        'workflows',
        'release.yml',
      ),
    ).readAsString();
  });

  test('accepts the protected generated release workflow', () {
    expect(ReleaseWorkflowValidator.validate(workflow), isEmpty);
  });

  test('rejects automatic triggers and mutable action tags', () {
    final unsafe = workflow
        .replaceFirst('  workflow_dispatch:', '  push:\n  workflow_dispatch:')
        .replaceFirst(
          'actions/checkout@11d5960a326750d5838078e36cf38b85af677262',
          'actions/checkout@v6',
        );

    expect(
      ReleaseWorkflowValidator.validate(unsafe),
      containsAll([
        'Release workflow must not have an automatic trigger.',
        'Every release action must be pinned to a full commit SHA.',
      ]),
    );
  });

  test('rejects secrets in preflight and missing environment protection', () {
    final unsafe = workflow
        .replaceFirst(
          r'DEFAULT_BRANCH: ${{ github.event.repository.default_branch }}',
          r'UNSAFE: ${{ secrets.UNSAFE }}'
              '\n'
              '          DEFAULT_BRANCH: '
              r'${{ github.event.repository.default_branch }}',
        )
        .replaceFirst(
          '.type == "required_reviewers" and .prevent_self_review == true',
          '.type == "wait_timer"',
        );

    expect(
      ReleaseWorkflowValidator.validate(unsafe),
      containsAll([
        'Protected secrets must not be available to preflight.',
        'Release environments must be verified as protected.',
      ]),
    );
  });

  test('rejects a store upload before organization approval', () {
    final unsafe = workflow.replaceFirst(
      'Request NGO.Tools release approval',
      'Approval happens after upload',
    );

    expect(
      ReleaseWorkflowValidator.validate(unsafe),
      contains('Android store upload must follow NGO.Tools approval.'),
    );
  });
}
