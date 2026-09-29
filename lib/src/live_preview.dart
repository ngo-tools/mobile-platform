import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// Sends one JSON request and returns the status code and decoded body.
typedef LivePreviewTransport =
    Future<(int, Map<String, Object?>)> Function(
      Uri uri,
      Map<String, Object?> body,
    );

/// Modules a live preview can request from NGO.Tools.
const livePreviewModules = {'contacts', 'events', 'profile'};

/// The request of a live preview, sent before an admin approves it.
final class LivePreviewRequest {
  /// Creates and validates a request.
  LivePreviewRequest({
    required this.tenant,
    required Iterable<String> modules,
    required this.platform,
    required this.redirectUri,
  }) : modules = List.unmodifiable(modules) {
    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(tenant)) {
      throw FormatException('The organization slug "$tenant" is invalid.');
    }

    if (this.modules.isEmpty ||
        this.modules.toSet().length != this.modules.length ||
        !this.modules.every(livePreviewModules.contains)) {
      throw FormatException(
        'Modules must be distinct values of ${livePreviewModules.join(', ')}.',
      );
    }

    if (platform != 'ios' && platform != 'android') {
      throw const FormatException('The platform must be ios or android.');
    }

    if (!RegExp(
      r'^ngotools-[a-z0-9]+(?:-[a-z0-9]+)*://oauth/callback$',
    ).hasMatch(redirectUri)) {
      throw const FormatException(
        'The redirect URI must be ngotools-<name>://oauth/callback.',
      );
    }
  }

  /// Organization slug, e.g. the subdomain of `<slug>.ngo.tools`.
  final String tenant;

  /// Requested modules.
  final List<String> modules;

  /// `ios` or `android`.
  final String platform;

  /// Private-scheme redirect of the preview app.
  final String redirectUri;
}

/// A started preview waiting for an admin.
final class LivePreviewStart {
  /// Creates a started preview.
  const LivePreviewStart({
    required this.previewId,
    required this.pollToken,
    required this.userCode,
    required this.authorizationUrl,
    required this.expiresIn,
    required this.pollInterval,
  });

  /// Public preview identifier.
  final String previewId;

  /// Secret used only to poll; never persisted.
  final String pollToken;

  /// Code the admin compares on the approval page.
  final String userCode;

  /// Approval page for an organization admin.
  final Uri authorizationUrl;

  /// Time until the approval request expires.
  final Duration expiresIn;

  /// Minimum delay between polls.
  final Duration pollInterval;
}

/// Public configuration of an approved live preview.
final class LivePreviewConfiguration {
  /// Creates a configuration.
  LivePreviewConfiguration({
    required this.appId,
    required this.environmentId,
    required this.configRevision,
    required this.tenant,
    required Iterable<String> modules,
    required this.platform,
    required this.apiBaseUrl,
    required this.expiresAt,
    required this.issuer,
    required this.clientId,
    required this.redirectUri,
    required Iterable<String> scopes,
  }) : modules = List.unmodifiable(modules),
       scopes = List.unmodifiable(scopes);

  /// Validates the `configuration` object of an approved poll.
  factory LivePreviewConfiguration.fromJson(Map<String, Object?> json) {
    final oidc = json['oidc'];

    if (oidc is! Map<String, Object?>) {
      throw const FormatException('The preview configuration has no OIDC.');
    }

    String text(Map<String, Object?> source, String key, RegExp pattern) {
      final value = source[key];

      if (value is! String || !pattern.hasMatch(value)) {
        throw FormatException('The preview configuration has an invalid $key.');
      }

      return value;
    }

    Uri https(Map<String, Object?> source, String key) {
      final uri = Uri.tryParse(text(source, key, RegExp(r'^https://[^\s]+$')));

      if (uri == null || uri.userInfo.isNotEmpty || uri.hasQuery) {
        throw FormatException('The preview configuration has an invalid $key.');
      }

      return uri;
    }

    List<String> strings(Map<String, Object?> source, String key) {
      final value = source[key];

      if (value is! List || value.any((item) => item is! String)) {
        throw FormatException('The preview configuration has invalid $key.');
      }

      return value.cast<String>();
    }

    final expiresAt = DateTime.tryParse(
      text(json, 'expires_at', RegExp(r'^\d{4}-\d{2}-\d{2}T')),
    );

    if (expiresAt == null) {
      throw const FormatException('The preview configuration has no expiry.');
    }

    if (json['attestation_mode'] != 'disabled') {
      throw const FormatException('Live previews run without attestation.');
    }

    final scopes = strings(oidc, 'scopes');

    if (scopes.contains('offline_access')) {
      throw const FormatException(
        'Live previews must not request offline access.',
      );
    }

    return LivePreviewConfiguration(
      appId: text(json, 'app_id', RegExp(r'^prv_[0-9A-HJKMNP-TV-Z]{26}$')),
      environmentId: text(
        json,
        'environment_id',
        RegExp(r'^env_[0-9A-HJKMNP-TV-Z]{26}$'),
      ),
      configRevision: text(
        json,
        'config_revision',
        RegExp(r'^cfg_[0-9A-HJKMNP-TV-Z]{26}$'),
      ),
      tenant: text(json, 'tenant', RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$')),
      modules: strings(json, 'modules'),
      platform: text(json, 'platform', RegExp(r'^(ios|android)$')),
      apiBaseUrl: https(json, 'api_base_url'),
      expiresAt: expiresAt,
      issuer: https(oidc, 'issuer'),
      clientId: text(oidc, 'client_id', RegExp(r'^mobile-preview-[a-z0-9]+$')),
      redirectUri: text(
        oidc,
        'redirect_uri',
        RegExp(r'^ngotools-[a-z0-9]+(?:-[a-z0-9]+)*://oauth/callback$'),
      ),
      scopes: scopes,
    );
  }

  /// Temporary app identifier (`prv_…`).
  final String appId;

  /// Temporary environment identifier.
  final String environmentId;

  /// Configuration revision.
  final String configRevision;

  /// Organization slug.
  final String tenant;

  /// Approved modules.
  final List<String> modules;

  /// Approved platform.
  final String platform;

  /// Tenant API origin with the `/api/v3` path.
  final Uri apiBaseUrl;

  /// End of the read access.
  final DateTime expiresAt;

  /// OIDC issuer of the tenant realm.
  final Uri issuer;

  /// Temporary public PKCE client.
  final String clientId;

  /// Redirect registered for the client.
  final String redirectUri;

  /// OIDC scopes without `offline_access`.
  final List<String> scopes;

  /// Non-secret summary written next to the preview app.
  Map<String, Object?> toSummary() => {
    'app_id': appId,
    'tenant': tenant,
    'modules': modules,
    'platform': platform,
    'expires_at': expiresAt.toUtc().toIso8601String(),
  };
}

/// Outcome of one poll.
sealed class LivePreviewPoll {
  const LivePreviewPoll();
}

/// The admin has not decided yet.
final class LivePreviewPending extends LivePreviewPoll {
  /// Creates a pending result.
  const LivePreviewPending();
}

/// The admin approved the preview.
final class LivePreviewApproved extends LivePreviewPoll {
  /// Creates an approved result.
  const LivePreviewApproved(this.configuration);

  /// The public configuration.
  final LivePreviewConfiguration configuration;
}

/// The preview cannot be used, e.g. denied, revoked or expired.
final class LivePreviewRejected extends LivePreviewPoll {
  /// Creates a rejected result with the server [code].
  const LivePreviewRejected(this.code);

  /// Stable server code such as `access_denied` or `expired_preview`.
  final String code;
}

/// Starts and polls tenant-authorized live previews.
final class LivePreviewClient {
  /// Creates a client for the NGO.Tools organization at [baseUrl].
  LivePreviewClient({required this.baseUrl, LivePreviewTransport? transport})
    : _transport = transport ?? _httpTransport {
    if (baseUrl.scheme != 'https' ||
        !baseUrl.hasAuthority ||
        baseUrl.userInfo.isNotEmpty) {
      throw const FormatException('The organization URL must use HTTPS.');
    }
  }

  /// Origin of the organization, e.g. `https://<slug>.ngo.tools`.
  final Uri baseUrl;

  final LivePreviewTransport _transport;

  /// Requests a preview that an organization admin has to approve.
  Future<LivePreviewStart> start(LivePreviewRequest request) async {
    final (
      status,
      body,
    ) = await _transport(baseUrl.replace(path: '/api/v3/mobile-app-previews'), {
      'modules': request.modules,
      'platform': request.platform,
      'redirect_uri': request.redirectUri,
    });

    if (status == 404) {
      throw const LivePreviewException(
        'Live previews are not enabled for this organization.',
      );
    }

    final data = body['data'];

    if (status != 201 || data is! Map<String, Object?>) {
      throw LivePreviewException(
        'The preview could not be started (HTTP $status).',
      );
    }

    final previewId = data['preview_id'];
    final pollToken = data['poll_token'];
    final userCode = data['user_code'];
    final authorizationUrl = Uri.tryParse('${data['authorization_url']}');
    final expiresIn = data['expires_in'];
    final pollInterval = data['poll_interval'];

    if (previewId is! String ||
        pollToken is! String ||
        userCode is! String ||
        authorizationUrl == null ||
        authorizationUrl.scheme != 'https' ||
        expiresIn is! int ||
        pollInterval is! int) {
      throw const LivePreviewException('The server sent an invalid start.');
    }

    return LivePreviewStart(
      previewId: previewId,
      pollToken: pollToken,
      userCode: userCode,
      authorizationUrl: authorizationUrl,
      expiresIn: Duration(seconds: expiresIn),
      pollInterval: Duration(seconds: pollInterval < 1 ? 1 : pollInterval),
    );
  }

  /// Polls once for the admin's decision.
  Future<LivePreviewPoll> poll(LivePreviewStart start) async {
    final (status, body) = await _transport(
      baseUrl.replace(
        path: '/api/v3/mobile-app-previews/${start.previewId}/poll',
      ),
      {'poll_token': start.pollToken},
    );
    final code = body['code'];

    return switch (status) {
      202 => const LivePreviewPending(),
      200 when body['configuration'] is Map<String, Object?> =>
        LivePreviewApproved(
          LivePreviewConfiguration.fromJson(
            body['configuration']! as Map<String, Object?>,
          ),
        ),
      403 ||
      404 ||
      410 => LivePreviewRejected(code is String ? code : 'invalid_preview'),
      _ => throw LivePreviewException(
        'The preview status could not be read (HTTP $status).',
      ),
    };
  }

  /// Polls until the admin decides or the approval request expires.
  Future<LivePreviewPoll> waitForDecision(
    LivePreviewStart start, {
    Future<void> Function(Duration delay) sleep = _sleep,
  }) async {
    final attempts = (start.expiresIn.inSeconds / start.pollInterval.inSeconds)
        .ceil();

    for (var attempt = 0; attempt <= attempts; attempt++) {
      final result = await poll(start);

      if (result is! LivePreviewPending) {
        return result;
      }

      await sleep(start.pollInterval);
    }

    return const LivePreviewRejected('expired_preview');
  }

  static Future<void> _sleep(Duration delay) => Future<void>.delayed(delay);

  static Future<(int, Map<String, Object?>)> _httpTransport(
    Uri uri,
    Map<String, Object?> body,
  ) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(uri);
      request.headers
        ..contentType = ContentType.json
        ..set(HttpHeaders.acceptHeader, 'application/json');
      request.write(jsonEncode(body));
      final response = await request.close();
      final text = await response.transform(utf8.decoder).join();
      final decoded = text.isEmpty ? null : jsonDecode(text);

      return (
        response.statusCode,
        decoded is Map<String, Object?> ? decoded : <String, Object?>{},
      );
    } finally {
      client.close(force: true);
    }
  }
}

/// A preview failure safe to show to the developer.
final class LivePreviewException implements Exception {
  /// Creates an exception with a [message].
  const LivePreviewException(this.message);

  /// Human-readable reason without secrets.
  final String message;

  @override
  String toString() => message;
}

/// Renders the development configuration of a preview app.
///
/// Only the development environment is written: the preview is temporary and
/// never becomes a staging or production app.
String renderLivePreviewConfiguration(
  LivePreviewConfiguration configuration, {
  required String defaultLocale,
  required Iterable<String> locales,
}) {
  String literal(String value) =>
      "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";

  return '''
// GENERATED BY tool/live_preview.dart. DO NOT EDIT.
// Temporary live preview for ${configuration.tenant}; read access ends at
// ${configuration.expiresAt.toUtc().toIso8601String()}.

import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

/// Public configuration of an approved live preview.
final mobileAppConfiguration = MobileAppConfiguration(
  appId: ${literal(configuration.appId)},
  tenant: ${literal(configuration.tenant)},
  defaultLocale: ${literal(defaultLocale)},
  locales: [${locales.map(literal).join(', ')}],
  environments: {
    MobileEnvironment.development: MobileEnvironmentConfiguration(
      environment: MobileEnvironment.development,
      id: ${literal(configuration.environmentId)},
      apiBaseUrl: Uri.parse(${literal(configuration.apiBaseUrl.toString())}),
      configRevision: ${literal(configuration.configRevision)},
      attestationMode: MobileAttestationMode.disabled,
      oidc: MobileOidcConfiguration(
        issuer: Uri.parse(${literal(configuration.issuer.toString())}),
        clientId: ${literal(configuration.clientId)},
        redirectUri: Uri.parse(${literal(configuration.redirectUri)}),
        scopes: [${configuration.scopes.map(literal).join(', ')}],
      ),
    ),
  },
);
''';
}
