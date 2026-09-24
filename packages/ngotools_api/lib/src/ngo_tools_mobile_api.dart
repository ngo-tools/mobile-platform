import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';
import 'package:uuid/uuid.dart';

import 'generated/api/runtime_api.dart';
import 'generated/model/import_capability.dart' as generated;
import 'internal/mobile_api_interceptors.dart';
import 'mobile_api_problem.dart';
import 'mobile_runtime_capabilities.dart';

/// Connects the protected authentication session to an HTTP client.
typedef MobileApiAuthorizer = void Function(Dio client);

/// Secure typed access to the NGO.Tools mobile runtime API.
final class NgoToolsMobileApi {
  /// Creates the production API pipeline for one fixed environment.
  factory NgoToolsMobileApi({
    required MobileEnvironmentConfiguration environment,
    required MobileApiAuthorizer authorize,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration sendTimeout = const Duration(seconds: 20),
    Duration receiveTimeout = const Duration(seconds: 20),
  }) {
    _validateBaseUrl(environment.apiBaseUrl);

    final dio = Dio(
      BaseOptions(
        baseUrl: environment.apiBaseUrl.origin,
        connectTimeout: connectTimeout,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        contentType: Headers.jsonContentType,
      ),
    );
    authorize(dio);

    return NgoToolsMobileApi.testing(dio: dio);
  }

  /// Creates an API pipeline around a controlled HTTP client.
  @visibleForTesting
  NgoToolsMobileApi.testing({
    required Dio dio,
    String Function()? requestId,
    StreamController<void>? capabilityInvalidations,
  }) : _dio = dio,
       _capabilityInvalidations =
           capabilityInvalidations ?? StreamController<void>.broadcast() {
    _runtimeApi = RuntimeApi(_dio);
    _dio.interceptors.addAll([
      MobileRequestMetadataInterceptor(requestId ?? () => const Uuid().v4()),
      MobileReadRetryInterceptor(_dio),
      MobileProblemInterceptor(_capabilityInvalidations),
    ]);
  }

  final Dio _dio;
  final StreamController<void> _capabilityInvalidations;
  late final RuntimeApi _runtimeApi;

  /// Emits whenever a denied request may indicate changed server access.
  Stream<void> get capabilityInvalidations => _capabilityInvalidations.stream;

  /// Loads effective features, permissions, and import capabilities.
  Future<MobileRuntimeCapabilities> fetchCapabilities() async {
    try {
      final currentUserRequest = _runtimeApi.getCurrentUser(
        extra: const {capabilityRefreshExtra: true},
      );
      final capabilitiesRequest = _runtimeApi.getCapabilities(
        extra: const {capabilityRefreshExtra: true},
      );
      final responses = await (currentUserRequest, capabilitiesRequest).wait;
      final currentUser = responses.$1.data;
      final capabilities = responses.$2.data;

      if (currentUser == null || capabilities == null) {
        throw MobileApiException(
          MobileApiProblem(
            code: 'invalid_response',
            title: 'Invalid server response',
            status: 0,
          ),
        );
      }

      final runtime = capabilities.data;

      return MobileRuntimeCapabilities(
        schemaVersion: runtime.schemaVersion,
        features: runtime.features,
        permissions: currentUser.permissions,
        importsEnabled: runtime.imports.enabled,
        importTypes: runtime.imports.types.map(
          (key, capability) =>
              MapEntry(key, _mapImportCapability(key, capability)),
        ),
      );
    } on DioException catch (error) {
      final normalized = error.error;

      if (normalized is MobileApiException) {
        throw normalized;
      }

      throw MobileApiException(MobileApiProblemParser.fromDio(error));
    } on MobileApiException {
      rethrow;
    } on Object {
      throw MobileApiException(
        MobileApiProblem(
          code: 'invalid_response',
          title: 'Invalid server response',
          status: 0,
        ),
      );
    }
  }

  /// Releases HTTP and stream resources owned by this client.
  Future<void> close() async {
    _dio.close(force: true);
    await _capabilityInvalidations.close();
  }

  static MobileImportCapability _mapImportCapability(
    String key,
    generated.ImportCapability capability,
  ) => MobileImportCapability(
    key: key,
    label: capability.label,
    supported: capability.supported,
    requiredFeature: capability.requiredFeature,
    featureEnabled: capability.featureEnabled,
    permissionGranted: capability.permissionGranted,
    available: capability.available,
    requires: capability.requires,
    batchImportSupported: capability.batchImportSupported,
    blockers: capability.blockers
        .map(
          (blocker) => MobileCapabilityBlocker(
            code: blocker.code,
            message: blocker.message,
          ),
        )
        .toList(growable: false),
    maxBatchSize: capability.limits?.maxBatchSize,
  );

  static void _validateBaseUrl(Uri uri) {
    if (uri.scheme != 'https' ||
        !uri.hasAuthority ||
        uri.userInfo.isNotEmpty ||
        uri.query.isNotEmpty ||
        uri.fragment.isNotEmpty) {
      throw ArgumentError.value(
        uri,
        'environment.apiBaseUrl',
        'The API base URL must be a fixed HTTPS origin.',
      );
    }
  }
}
