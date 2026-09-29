import 'package:ngo_tools_mobile_platform/mobile_platform_tooling.dart';
import 'package:test/test.dart';

void main() {
  final request = LivePreviewRequest(
    tenant: 'synthetic-demo',
    modules: const ['events', 'profile'],
    platform: 'ios',
    redirectUri: 'ngotools-synthetic-preview://oauth/callback',
  );

  Map<String, Object?> approvedBody() => {
    'status': 'approved',
    'configuration': {
      'app_id': 'prv_01J00000000000000000000000',
      'environment_id': 'env_01J00000000000000000000009',
      'config_revision': 'cfg_01J00000000000000000000009',
      'tenant': 'synthetic-demo',
      'modules': ['events', 'profile'],
      'platform': 'ios',
      'api_base_url': 'https://synthetic-demo.example.invalid/api/v3',
      'expires_at': '2026-09-28T18:00:00+00:00',
      'attestation_mode': 'disabled',
      'oidc': {
        'issuer': 'https://identity.example.invalid/realms/synthetic',
        'client_id': 'mobile-preview-01j00000000000000000000000',
        'redirect_uri': 'ngotools-synthetic-preview://oauth/callback',
        'scopes': ['openid', 'profile', 'email'],
      },
    },
  };

  Map<String, Object?> startBody() => {
    'data': {
      'preview_id': 'prv_01J00000000000000000000000',
      'poll_token': 'synthetic-poll-token',
      'user_code': 'K7QM-2XRA-P9TD',
      'authorization_url':
          'https://synthetic-demo.example.invalid/mobile-app-previews/K7QM-2XRA-P9TD',
      'expires_in': 600,
      'poll_interval': 2,
    },
  };

  test('starts a preview and waits for the approval', () async {
    final requests = <(Uri, Map<String, Object?>)>[];
    var polls = 0;
    final client = LivePreviewClient(
      baseUrl: Uri.parse('https://synthetic-demo.example.invalid'),
      transport: (uri, body) async {
        requests.add((uri, body));

        if (uri.path.endsWith('/mobile-app-previews')) {
          return (201, startBody());
        }

        polls += 1;

        return polls < 3
            ? (202, <String, Object?>{'status': 'pending'})
            : (200, approvedBody());
      },
    );
    final sleeps = <Duration>[];

    final start = await client.start(request);
    final result = await client.waitForDecision(
      start,
      sleep: (delay) async => sleeps.add(delay),
    );

    expect(start.userCode, 'K7QM-2XRA-P9TD');
    expect(requests.first.$2, {
      'modules': ['events', 'profile'],
      'platform': 'ios',
      'redirect_uri': 'ngotools-synthetic-preview://oauth/callback',
    });
    expect(
      requests.last.$1.path,
      '/api/v3/mobile-app-previews/prv_01J00000000000000000000000/poll',
    );
    expect(requests.last.$2, {'poll_token': 'synthetic-poll-token'});
    expect(sleeps, [const Duration(seconds: 2), const Duration(seconds: 2)]);
    final configuration = (result as LivePreviewApproved).configuration;
    expect(configuration.appId, 'prv_01J00000000000000000000000');
    expect(configuration.scopes, ['openid', 'profile', 'email']);
    expect(configuration.toSummary().containsKey('poll_token'), isFalse);
  });

  test('reports denied, revoked and expired previews', () async {
    for (final (status, code) in [
      (403, 'access_denied'),
      (403, 'preview_revoked'),
      (410, 'expired_preview'),
    ]) {
      final client = LivePreviewClient(
        baseUrl: Uri.parse('https://synthetic-demo.example.invalid'),
        transport: (uri, body) async => uri.path.endsWith('/poll')
            ? (status, <String, Object?>{'code': code})
            : (201, startBody()),
      );

      final result = await client.waitForDecision(
        await client.start(request),
        sleep: (_) async {},
      );

      expect((result as LivePreviewRejected).code, code);
    }
  });

  test('explains a tenant without live previews', () async {
    final client = LivePreviewClient(
      baseUrl: Uri.parse('https://synthetic-demo.example.invalid'),
      transport: (uri, body) async => (404, <String, Object?>{}),
    );

    expect(
      client.start(request),
      throwsA(
        isA<LivePreviewException>().having(
          (error) => error.message,
          'message',
          contains('not enabled'),
        ),
      ),
    );
  });

  test('rejects unsafe requests and configurations', () {
    expect(
      () => LivePreviewRequest(
        tenant: 'Synthetic Demo',
        modules: const ['events'],
        platform: 'ios',
        redirectUri: 'ngotools-synthetic://oauth/callback',
      ),
      throwsFormatException,
    );
    expect(
      () => LivePreviewRequest(
        tenant: 'synthetic-demo',
        modules: const ['finance'],
        platform: 'ios',
        redirectUri: 'ngotools-synthetic://oauth/callback',
      ),
      throwsFormatException,
    );
    expect(
      () => LivePreviewClient(baseUrl: Uri.parse('http://synthetic.invalid')),
      throwsFormatException,
    );

    final withOfflineAccess =
        approvedBody()['configuration']! as Map<String, Object?>;
    (withOfflineAccess['oidc']! as Map<String, Object?>)['scopes'] = [
      'openid',
      'profile',
      'offline_access',
    ];

    expect(
      () => LivePreviewConfiguration.fromJson(withOfflineAccess),
      throwsFormatException,
    );
  });

  test('renders only the development environment of the preview', () {
    final configuration = LivePreviewConfiguration.fromJson(
      approvedBody()['configuration']! as Map<String, Object?>,
    );

    final source = renderLivePreviewConfiguration(
      configuration,
      defaultLocale: 'de',
      locales: const ['de', 'en'],
    );

    expect(source, contains("appId: 'prv_01J00000000000000000000000'"));
    expect(source, contains('MobileEnvironment.development'));
    expect(source, isNot(contains('MobileEnvironment.production')));
    expect(source, contains("scopes: ['openid', 'profile', 'email']"));
    expect(source, isNot(contains('synthetic-poll-token')));
  });
}
