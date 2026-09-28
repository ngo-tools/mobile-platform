import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:ngotools_api/ngotools_api.dart';
import 'package:ngotools_auth/ngotools_auth.dart';
import 'package:ngotools_contacts/ngotools_contacts.dart';
import 'package:ngotools_events/ngotools_events.dart';
import 'package:ngotools_mobile_core/ngotools_mobile_core.dart';

import 'app.dart';
import 'generated/mobile_app_config.dart';

/// Build number passed with `--dart-define=BUILD_NUMBER=…`.
const _buildNumber = String.fromEnvironment('BUILD_NUMBER', defaultValue: '1');

/// Composition root: authentication, API connection and module repositories.
///
/// Sign-in is available in environments without attestation, which includes
/// live previews. Environments that enforce attestation need a native
/// attestation provider supplied by the organization app.
final class GoldenRuntime extends StatefulWidget {
  /// Creates the runtime for [environment].
  const GoldenRuntime({required this.environment, super.key});

  /// The environment selected at build time.
  final MobileEnvironment environment;

  @override
  State<GoldenRuntime> createState() => _GoldenRuntimeState();
}

final class _GoldenRuntimeState extends State<GoldenRuntime> {
  MobileAuthCubit? _auth;
  NgoToolsMobileApi? _api;
  MobileCapabilitiesCubit? _capabilities;
  StreamSubscription<MobileAuthStatus>? _authChanges;

  MobileEnvironmentConfiguration get _environment =>
      mobileAppConfiguration.forEnvironment(widget.environment);

  @override
  void initState() {
    super.initState();

    if (_environment.attestationMode != MobileAttestationMode.disabled) {
      return;
    }

    final auth = MobileAuthCubit(
      configuration: MobileAuthConfiguration.fromApp(
        app: mobileAppConfiguration,
        environment: widget.environment,
        platform: Platform.isIOS ? MobilePlatform.ios : MobilePlatform.android,
        deviceName: 'NGO.Tools App',
        buildNumber: _buildNumber,
      ),
      attestationProvider: const DisabledMobileAttestationProvider(),
    );
    final api = NgoToolsMobileApi(
      environment: _environment,
      authorize: auth.attachTo,
    );
    final capabilities = MobileCapabilitiesCubit(api);

    _auth = auth;
    _api = api;
    _capabilities = capabilities;
    _authChanges = auth.stream.map((state) => state.status).distinct().listen((
      status,
    ) {
      if (status == MobileAuthStatus.authenticated) {
        unawaited(capabilities.load());
      }
    });
    unawaited(auth.restore());
  }

  @override
  void dispose() {
    unawaited(_authChanges?.cancel());
    unawaited(_capabilities?.close());
    unawaited(_api?.close());
    unawaited(_auth?.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = _auth;
    final api = _api;
    final capabilities = _capabilities;

    if (auth == null || api == null || capabilities == null) {
      return GoldenApp(environment: widget.environment);
    }

    return StreamBuilder<MobileAuthState>(
      stream: auth.stream,
      initialData: auth.state,
      builder: (context, authSnapshot) =>
          StreamBuilder<MobileCapabilitiesState>(
            stream: capabilities.stream,
            initialData: capabilities.state,
            builder: (context, capabilitySnapshot) {
              final status =
                  authSnapshot.data?.status ?? MobileAuthStatus.signedOut;
              final authenticated = status == MobileAuthStatus.authenticated;

              return GoldenApp(
                environment: widget.environment,
                authStatus: status,
                capabilities: authenticated
                    ? capabilitySnapshot.data?.capabilities
                    : null,
                contactsRepository: authenticated
                    ? NgoToolsContactsRepository(api)
                    : null,
                eventsRepository: authenticated
                    ? NgoToolsEventsRepository(api)
                    : null,
                onSignIn: auth.signIn,
                onSignOut: auth.signOut,
              );
            },
          ),
    );
  }
}
