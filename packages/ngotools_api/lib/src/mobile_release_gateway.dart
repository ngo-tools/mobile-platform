import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'generated/api/release_api.dart';
import 'generated/model/mobile_app_approved_release.dart' as generated;
import 'generated/model/mobile_app_release_poll_request.dart' as generated;
import 'generated/model/mobile_app_release_poll_response.dart' as generated;
import 'generated/model/mobile_app_release_request.dart' as generated;
import 'internal/mobile_api_interceptors.dart';
import 'mobile_api_problem.dart';

/// Mobile artifact platform understood by the release registry.
enum MobileReleasePlatform { ios, android }

/// Distribution audience recorded for a mobile release.
enum MobileReleaseChannel { internal, beta, production }

/// Immutable metadata for one signed artifact awaiting release approval.
final class MobileReleaseArtifact {
  /// Creates and validates immutable release metadata.
  MobileReleaseArtifact({
    required this.appId,
    required this.platform,
    required this.channel,
    required this.version,
    required this.buildNumber,
    required this.sourceRevision,
    required this.artifactSha256,
    required this.sdkVersion,
    required this.contractVersion,
  }) {
    if (!RegExp(r'^[a-f0-9]{40}$').hasMatch(sourceRevision)) {
      throw ArgumentError.value(
        sourceRevision,
        'sourceRevision',
        'Must be a full lowercase Git commit SHA.',
      );
    }

    if (!RegExp(r'^[a-f0-9]{64}$').hasMatch(artifactSha256)) {
      throw ArgumentError.value(
        artifactSha256,
        'artifactSha256',
        'Must be a lowercase SHA-256 digest.',
      );
    }

    for (final versionEntry in {
      'version': version,
      'sdkVersion': sdkVersion,
      'contractVersion': contractVersion,
    }.entries) {
      if (!RegExp(
        r'^\d+\.\d+\.\d+(?:-[0-9A-Za-z.-]+)?$',
      ).hasMatch(versionEntry.value)) {
        throw ArgumentError.value(
          versionEntry.value,
          versionEntry.key,
          'Must be a semantic version.',
        );
      }
    }

    if (!RegExp(r'^\d+(?:\.\d+){0,2}$').hasMatch(buildNumber)) {
      throw ArgumentError.value(
        buildNumber,
        'buildNumber',
        'Must be a numeric build number.',
      );
    }
  }

  /// Stable app registration identifier.
  final String appId;

  /// Native platform of the signed artifact.
  final MobileReleasePlatform platform;

  /// Intended release audience.
  final MobileReleaseChannel channel;

  /// User-visible semantic app version.
  final String version;

  /// Platform build number.
  final String buildNumber;

  /// Immutable organization-app source commit.
  final String sourceRevision;

  /// SHA-256 of the signed artifact submitted to the store.
  final String artifactSha256;

  /// Mobile platform SDK version used by the app.
  final String sdkVersion;

  /// NGO.Tools API contract version used by the app.
  final String contractVersion;
}

/// A short-lived human approval without exposed polling credentials.
final class MobileReleaseApproval {
  const MobileReleaseApproval._({
    required this.authorizationUri,
    required this.expiresAt,
    required this.pollInterval,
    required String requestId,
    required String pollToken,
    required MobileReleaseArtifact artifact,
  }) : _requestId = requestId,
       _pollToken = pollToken,
       _artifact = artifact;

  /// URL an organization administrator must open to resolve the release.
  final Uri authorizationUri;

  /// Local upper bound after which polling stops.
  final DateTime expiresAt;

  /// Minimum interval advertised by the server.
  final Duration pollInterval;

  final String _requestId;
  final String _pollToken;
  final MobileReleaseArtifact _artifact;

  @override
  String toString() =>
      'MobileReleaseApproval(expiresAt: $expiresAt, '
      'pollInterval: $pollInterval)';
}

/// Sanitized immutable result of an approved release.
final class MobileApprovedRelease {
  /// Creates an approved release result.
  const MobileApprovedRelease({required this.id, required this.managementUri});

  /// Stable public release identifier.
  final String id;

  /// Authenticated organization management page for this release.
  final Uri managementUri;
}

/// Starts and polls the NGO.Tools human approval for signed artifacts.
final class MobileReleaseGateway {
  /// Creates a release gateway bound to one fixed production API origin.
  factory MobileReleaseGateway({
    required Uri apiBaseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    _validateBaseUrl(apiBaseUrl);
    final dio = Dio(
      BaseOptions(
        baseUrl: apiBaseUrl.origin,
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );

    return MobileReleaseGateway.testing(dio: dio);
  }

  /// Creates a gateway around a controlled client and clock.
  @visibleForTesting
  MobileReleaseGateway.testing({
    required Dio dio,
    DateTime Function()? now,
    Future<void> Function(Duration)? wait,
    String Function()? requestId,
  }) : _dio = dio,
       _now = now ?? DateTime.now,
       _wait = wait ?? Future<void>.delayed {
    _releaseApi = ReleaseApi(_dio);
    _dio.interceptors.add(
      MobileRequestMetadataInterceptor(requestId ?? () => const Uuid().v4()),
    );
  }

  final Dio _dio;
  final DateTime Function() _now;
  final Future<void> Function(Duration) _wait;
  late final ReleaseApi _releaseApi;

  /// Starts a short-lived approval for [artifact].
  Future<MobileReleaseApproval> start(MobileReleaseArtifact artifact) async {
    try {
      final response = await _releaseApi.startMobileAppRelease(
        mobileAppReleaseRequest: generated.MobileAppReleaseRequest(
          appId: artifact.appId,
          platform: _platform(artifact.platform),
          channel: _channel(artifact.channel),
          version: artifact.version,
          buildNumber: artifact.buildNumber,
          sourceRevision: artifact.sourceRevision,
          artifactSha256: artifact.artifactSha256,
          sdkVersion: artifact.sdkVersion,
          contractVersion: artifact.contractVersion,
        ),
      );
      _requireNoStore(response);
      final approval = response.data?.data;

      if (approval == null ||
          approval.pollToken.length != 64 ||
          approval.pollInterval < 1 ||
          approval.expiresIn < 1) {
        throw _invalidResponse();
      }

      final authorizationUri = Uri.tryParse(approval.authorizationUrl);

      if (!_isSafeHttpsUri(authorizationUri)) {
        throw _invalidResponse();
      }

      return MobileReleaseApproval._(
        authorizationUri: authorizationUri!,
        expiresAt: _now().toUtc().add(Duration(seconds: approval.expiresIn)),
        pollInterval: Duration(seconds: approval.pollInterval),
        requestId: approval.releaseRequestId,
        pollToken: approval.pollToken,
        artifact: artifact,
      );
    } on DioException catch (error) {
      throw _normalized(error);
    }
  }

  /// Waits until [approval] is approved, denied, or expired.
  Future<MobileApprovedRelease> waitForApproval(
    MobileReleaseApproval approval,
  ) async {
    var delay = approval.pollInterval;

    while (_now().toUtc().isBefore(approval.expiresAt)) {
      await _wait(delay);

      if (!_now().toUtc().isBefore(approval.expiresAt)) {
        break;
      }

      try {
        final response = await _releaseApi.pollMobileAppRelease(
          releaseRequestId: approval._requestId,
          mobileAppReleasePollRequest: generated.MobileAppReleasePollRequest(
            pollToken: approval._pollToken,
          ),
        );
        _requireNoStore(response);
        final result = response.data;

        if (result == null) {
          throw _invalidResponse();
        }

        if (result.status ==
            generated.MobileAppReleasePollResponseStatusEnum.pending) {
          delay = _retryAfter(response) ?? approval.pollInterval;
          continue;
        }

        if (result.status !=
                generated.MobileAppReleasePollResponseStatusEnum.approved ||
            result.release == null) {
          throw _invalidResponse();
        }

        return _approved(result.release!, approval._artifact);
      } on DioException catch (error) {
        throw _normalized(error);
      }
    }

    throw MobileApiException(
      MobileApiProblem(
        code: 'expired_release_request',
        title: 'Release approval expired',
        status: 410,
      ),
    );
  }

  /// Releases the underlying HTTP resources.
  void close() => _dio.close(force: true);

  static MobileApprovedRelease _approved(
    generated.MobileAppApprovedRelease release,
    MobileReleaseArtifact artifact,
  ) {
    final managementUri = Uri.tryParse(release.managementUrl);
    final matchesArtifact =
        release.appId == artifact.appId &&
        release.platform.value == artifact.platform.name &&
        release.channel.value == artifact.channel.name &&
        release.version == artifact.version &&
        release.buildNumber == artifact.buildNumber &&
        release.status == generated.MobileAppApprovedReleaseStatusEnum.approved;

    if (!matchesArtifact || !_isSafeHttpsUri(managementUri)) {
      throw _invalidResponse();
    }

    return MobileApprovedRelease(id: release.id, managementUri: managementUri!);
  }

  static generated.MobileAppReleaseRequestPlatformEnum _platform(
    MobileReleasePlatform platform,
  ) => switch (platform) {
    MobileReleasePlatform.ios =>
      generated.MobileAppReleaseRequestPlatformEnum.ios,
    MobileReleasePlatform.android =>
      generated.MobileAppReleaseRequestPlatformEnum.android,
  };

  static generated.MobileAppReleaseRequestChannelEnum _channel(
    MobileReleaseChannel channel,
  ) => switch (channel) {
    MobileReleaseChannel.internal =>
      generated.MobileAppReleaseRequestChannelEnum.internal,
    MobileReleaseChannel.beta =>
      generated.MobileAppReleaseRequestChannelEnum.beta,
    MobileReleaseChannel.production =>
      generated.MobileAppReleaseRequestChannelEnum.production,
  };

  static void _requireNoStore(Response<Object?> response) {
    final cacheControl = response.headers.value('cache-control');

    if (cacheControl == null ||
        !cacheControl
            .toLowerCase()
            .split(',')
            .map((part) => part.trim())
            .contains('no-store')) {
      throw _invalidResponse();
    }
  }

  static Duration? _retryAfter(Response<Object?> response) {
    final seconds = int.tryParse(response.headers.value('retry-after') ?? '');

    return seconds == null || seconds < 1 ? null : Duration(seconds: seconds);
  }

  static MobileApiException _invalidResponse() => MobileApiException(
    MobileApiProblem(
      code: 'invalid_response',
      title: 'Invalid server response',
      status: 0,
    ),
  );

  static MobileApiException _normalized(DioException error) {
    final response = error.response;

    if (response != null) {
      _requireNoStore(response);
    }

    final parsed = MobileApiProblemParser.fromDio(error);
    final code = RegExp(r'^[a-z0-9_]{1,80}$').hasMatch(parsed.code)
        ? parsed.code
        : 'release_failed';

    return MobileApiException(
      MobileApiProblem(
        code: code,
        title: 'Release approval failed',
        status: parsed.status,
        requestId: parsed.requestId,
        retryAfter: parsed.retryAfter,
        retriable: parsed.retriable,
      ),
    );
  }

  static void _validateBaseUrl(Uri uri) {
    if (!_isSafeHttpsUri(uri)) {
      throw ArgumentError.value(
        uri,
        'apiBaseUrl',
        'The API base URL must be a fixed HTTPS origin.',
      );
    }
  }

  static bool _isSafeHttpsUri(Uri? uri) =>
      uri != null &&
      uri.scheme == 'https' &&
      uri.hasAuthority &&
      uri.userInfo.isEmpty &&
      uri.query.isEmpty &&
      uri.fragment.isEmpty;
}
